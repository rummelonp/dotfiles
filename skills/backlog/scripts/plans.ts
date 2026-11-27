/**
 * Reads the backlog item tables (`| # | 状態 | 種別 | 依存 |`) of markdown files and prints the state,
 * the items ready to start and the dependency tree, or validates the tables.
 * The tables are the only source of items; nothing is duplicated here.
 * The grammar is defined in the `backlog` skill (SKILL.md next to scripts/).
 *
 * Output stays at one line per item: it exists so an agent can learn the state without reading
 * whole documents.
 *
 * Usage:
 *   node plans.ts <status | ready | deps [ID...] | graph [ID...] | check> [--kind=<kind>]... -- <path>...
 *
 * Node >= 22.18 is required (type stripping is on by default), so no enum, namespace or parameter
 * property is used.
 */
import { readdirSync, readFileSync, realpathSync, statSync } from "node:fs";
import { basename, isAbsolute, join, relative, resolve, sep } from "node:path";

const HEADER_CELLS = String.raw`\|\s*#\s*\|\s*状態\s*\|\s*種別\s*\|\s*依存\s*\|`;
const HEADER = new RegExp(`^${HEADER_CELLS}`);
// The same header after indentation, a quote marker or a list marker. The parse only reads tables
// that start at column 0, so such a table would otherwise be dropped without a word.
const MISPLACED_HEADER = new RegExp(`^[\\s>]*(?:(?:[-*+]|\\d+[.)])[\\s>]*)*${HEADER_CELLS}`);
// GFM needs one hyphen per cell, not three
const SEPARATOR = /^\|?\s*:?-+:?\s*(\|\s*:?-+:?\s*)*\|?\s*$/;
const FENCE_OPEN = /^\s*(`{3,}|~{3,})(.*)$/;
const FENCE_CLOSE = /^\s*(`{3,}|~{3,})\s*$/;
const ID = /^[A-Za-zα-ω]+[0-9]+[a-z]?$/;
const ID_PARTS = /^([A-Za-zα-ω]+)([0-9]+)([a-z]?)$/;
// Range ends are unsuffixed IDs with the same prefix. Only U+301C is accepted as 〜, because a
// mix with U+FF5E (～) cannot be found by grep.
const RANGE = /^([A-Za-zα-ω]+)([0-9]+)〜([A-Za-zα-ω]+)([0-9]+)$/;
const STATUSES = ["未着手", "進行中", "完了", "取りやめ", "保留"] as const;
type Status = (typeof STATUSES)[number];
const IMPLEMENTATION = "実装";
const AGGREGATE = "集約";
// A kind outside this list is a violation, so a typo cannot silently drop an item from the work
// an agent picks up on its own. Extra kinds come from --kind and are never autonomous.
const DEFAULT_KINDS = [IMPLEMENTATION, "人手", "判断", "改善候補", AGGREGATE];
/**
 * Items in these states are no longer worked on and drop out of every list. Only 完了 satisfies a
 * dependency: 取りやめ does not, so cancelling an item forces a decision on its open dependents
 * (check rejects them) instead of silently releasing them to ready.
 */
const CLOSED: ReadonlySet<Status> = new Set(["完了", "取りやめ"]);

const SKILL_DOC = resolve(import.meta.dirname, "..", "SKILL.md");

interface Range {
  readonly prefix: string;
  readonly from: number;
  readonly to: number;
}

interface Item {
  readonly id: string;
  readonly status: Status;
  readonly kind: string;
  /** Ranges are expanded, including suffixed IDs inside a range */
  readonly deps: readonly string[];
  readonly ranges: readonly Range[];
  /** The 内容 column (the 5th column when absent) on one line */
  readonly summary: string;
  /** `path:line` as shown to the user */
  readonly at: string;
  /** Resolved absolute path */
  readonly file: string;
}

interface Model {
  readonly items: readonly Item[];
  readonly byId: ReadonlyMap<string, Item>;
  readonly files: readonly string[];
  readonly violations: readonly string[];
}

interface Fence {
  readonly char: string;
  readonly length: number;
}

interface Cli {
  readonly command: string;
  readonly ids: readonly string[];
  readonly kinds: readonly string[];
  readonly files: readonly string[];
  readonly only: { readonly ids: readonly string[]; readonly files: readonly string[] };
}

/**
 * What --only narrows status and ready to. Validation and 解放 still cover every plan, so a
 * dependency across plans is neither a violation nor dropped from the count.
 */
interface Scope {
  /** Plans named by path. status summarizes only these */
  readonly files: ReadonlySet<string>;
  readonly ids: ReadonlySet<string>;
  /** Open items outside ids that an open item in ids waits on, directly or through others */
  readonly blockers: ReadonlySet<string>;
  /** Open items outside ids that wait on an open item in ids, directly or through others */
  readonly waiters: ReadonlySet<string>;
}

class UsageError extends Error {}

function isStatus(value: string): value is Status {
  return (STATUSES as readonly string[]).includes(value);
}

function isInside(base: string, target: string): boolean {
  const rel = relative(base, target);
  return rel !== "" && rel !== ".." && !rel.startsWith(`..${sep}`) && !isAbsolute(rel);
}

// Absolute outside cwd, not `~/...`: agents open the shown path with file tools that need one
function display(path: string): string {
  return isInside(process.cwd(), path) ? relative(process.cwd(), path) : path;
}

function fenceOpening(line: string): Fence | undefined {
  const [, marker = "", info = ""] = line.match(FENCE_OPEN) ?? [];
  // A backtick fence cannot have a backtick in its info string, so ```code``` is inline code
  if (marker === "" || (marker.startsWith("`") && info.includes("`"))) return undefined;
  return { char: marker.charAt(0), length: marker.length };
}

/** Only the same character, at least as long as the opening, closes a fence */
function closesFence(line: string, fence: Fence): boolean {
  const marker = line.match(FENCE_CLOSE)?.[1] ?? "";
  return marker.startsWith(fence.char) && marker.length >= fence.length;
}

function ioError(what: string, path: string, error: unknown): UsageError {
  const code = error instanceof Error && "code" in error ? ` (${String(error.code)})` : "";
  return new UsageError(`${what}: ${display(path)}${code}`);
}

function cells(line: string): string[] {
  return line
    .trim()
    .replace(/^\|/, "")
    .replace(/\|$/, "")
    .split(/(?<!\\)\|/)
    .map((cell) => cell.trim());
}

function oneLine(markdown: string): string {
  return markdown
    .replace(/\[([^\]]*)\]\([^)]*\)/g, "$1")
    .replaceAll("`", "")
    .replaceAll("<br>", " ");
}

function truncate(text: string, length: number): string {
  const chars = [...text];
  return chars.length <= length ? text : `${chars.slice(0, length).join("")}…`;
}

function parseDeps(
  raw: string,
  at: string,
  violations: string[],
): { ids: string[]; ranges: Range[] } {
  const ids: string[] = [];
  const ranges: Range[] = [];
  if (raw === "—") return { ids, ranges };
  for (const token of raw.split("、").map((t) => t.trim())) {
    const range = token.match(RANGE);
    if (range !== null) {
      const [, fromPrefix = "", from = "", toPrefix = "", to = ""] = range;
      if (fromPrefix !== toPrefix || Number(from) >= Number(to)) {
        violations.push(`${at}: 範囲 "${token}" は同じ接頭辞で昇順にする`);
        continue;
      }
      ranges.push({ prefix: fromPrefix, from: Number(from), to: Number(to) });
      for (let n = Number(from); n <= Number(to); n++) ids.push(`${fromPrefix}${n}`);
    } else if (ID.test(token)) {
      ids.push(token);
    } else {
      violations.push(
        `${at}: 依存 "${token}" は ID でも範囲でもない（散文は内容列へ移す。無しは "—"）`,
      );
    }
  }
  return { ids, ranges };
}

function parsePlan(file: string, kinds: readonly string[], violations: string[]): Item[] {
  let text: string;
  try {
    text = readFileSync(file, "utf8");
  } catch (error) {
    throw ioError("読めないファイル", file, error);
  }
  const lines = text.split("\n");
  const where = (lineIndex: number) => `${display(file)}:${lineIndex + 1}`;
  const items: Item[] = [];
  let fence: Fence | undefined;
  let fenceStart = 0;
  let i = 0;
  while (i < lines.length) {
    const header = lines[i] ?? "";
    // A table inside a code block is an example, not items
    if (fence !== undefined) {
      if (closesFence(header, fence)) fence = undefined;
      i++;
      continue;
    }
    fence = fenceOpening(header);
    if (fence !== undefined) {
      fenceStart = i;
      i++;
      continue;
    }
    if (!header.startsWith("|")) {
      // A GFM table without the leading "|" is skipped by the parse below, so it is rejected
      if (header.includes("|") && SEPARATOR.test(header))
        violations.push(`${where(i)}: 表の行頭の "|" を省かない`);
      if (MISPLACED_HEADER.test(header))
        violations.push(`${where(i)}: 項目の表は行頭から書く（インデントやリスト、引用の中に置かない）`);
      i++;
      continue;
    }
    const tracked = HEADER.test(header);
    const hasSeparator = SEPARATOR.test(lines[i + 1] ?? "");
    if (tracked && !hasSeparator)
      violations.push(`${where(i)}: 項目の表のヘッダの次に区切り行が無い`);
    const headerCells = cells(header);
    const summaryColumn = headerCells.includes("内容") ? headerCells.indexOf("内容") : 4;
    i += hasSeparator ? 2 : 1;
    for (; i < lines.length && (lines[i] ?? "").startsWith("|"); i++) {
      const row = cells(lines[i] ?? "");
      const at = where(i);
      const [id = "", status = "", kind = "", deps = ""] = row;
      if (!tracked) {
        if (ID.test(id)) {
          violations.push(
            `${at}: ID "${id}" が項目の表でない表にある（ヘッダを "| # | 状態 | 種別 | 依存 |" で始める）`,
          );
        }
        continue;
      }
      if (!ID.test(id))
        violations.push(`${at}: ID "${id}" は ID の文法に合わない（注記は ID セルに書かない）`);
      if (!isStatus(status))
        violations.push(`${at}: 状態 "${status}" は ${STATUSES.join(" / ")} のどれかにする`);
      if (!kinds.includes(kind))
        violations.push(
          `${at}: 種別 "${kind}" は ${kinds.join(" / ")} のどれかにする（足す種別は --kind=<種別> で渡す）`,
        );
      if (!isStatus(status) || !kinds.includes(kind)) continue;
      const { ids, ranges } = parseDeps(deps, at, violations);
      items.push({
        id,
        status,
        kind,
        deps: ids,
        ranges,
        summary: oneLine(row[summaryColumn] ?? ""),
        at,
        file,
      });
    }
  }
  // Valid CommonMark, but every table after a mistyped fence would be dropped without a word
  if (fence !== undefined)
    violations.push(`${where(fenceStart)}: コードフェンスが閉じていない（後ろの表を読まない）`);
  return items;
}

/** Suffixed IDs inside a range (C7a for C2〜C9), so a row split off later is not missed by it */
function suffixedInRanges(item: Item, ids: Iterable<string>): string[] {
  return [...ids].filter((id) => {
    const [, prefix, number, suffix] = id.match(ID_PARTS) ?? [];
    return (
      id !== item.id &&
      suffix !== undefined &&
      suffix !== "" &&
      item.ranges.some(
        (range) =>
          range.prefix === prefix && Number(number) >= range.from && Number(number) <= range.to,
      )
    );
  });
}

/** State of an aggregate row (and of a whole file) derived from its parts */
function derive(statuses: readonly Status[]): Status {
  const live = statuses.filter((s) => s !== "取りやめ");
  if (live.length === 0) return "取りやめ";
  if (live.every((s) => s === "完了")) return "完了";
  if (live.every((s) => s === "完了" || s === "保留")) return "保留";
  if (live.every((s) => s === "未着手" || s === "保留")) return "未着手";
  return "進行中";
}

function findCycle(items: readonly Item[], byId: ReadonlyMap<string, Item>): string[] | undefined {
  const state = new Map<string, "visiting" | "done">();
  const path: string[] = [];
  const visit = (id: string): string[] | undefined => {
    if (state.get(id) === "done") return undefined;
    if (state.get(id) === "visiting") return [...path.slice(path.indexOf(id)), id];
    state.set(id, "visiting");
    path.push(id);
    for (const dep of byId.get(id)?.deps ?? []) {
      const cycle = visit(dep);
      if (cycle !== undefined) return cycle;
    }
    path.pop();
    state.set(id, "done");
    return undefined;
  };
  for (const item of items) {
    const cycle = visit(item.id);
    if (cycle !== undefined) return cycle;
  }
  return undefined;
}

function load(files: readonly string[], kinds: readonly string[]): Model {
  const violations: string[] = [];
  const parsed = files.flatMap((file) => parsePlan(file, kinds, violations));
  const allIds = new Set(parsed.map((item) => item.id));
  const items = parsed.map((item) => ({
    ...item,
    deps: [...new Set([...item.deps, ...suffixedInRanges(item, allIds)])],
  }));

  const byId = new Map<string, Item>();
  for (const item of items) {
    const existing = byId.get(item.id);
    if (existing !== undefined)
      violations.push(`${item.at}: ID "${item.id}" が ${existing.at} と重複している`);
    else byId.set(item.id, item);
  }

  for (const item of items) {
    for (const dep of item.deps) {
      const target = byId.get(dep);
      if (target === undefined) {
        violations.push(`${item.at}: ${item.id} の依存 "${dep}" が存在しない`);
        continue;
      }
      // An aggregate drops cancelled children and is checked against derive() below instead
      if (item.kind === AGGREGATE || item.status === "取りやめ") continue;
      if (target.status === "取りやめ") {
        violations.push(
          item.status === "完了"
            ? `${item.at}: 完了した ${item.id} が取りやめの ${dep} に依存している（依存から外す）`
            : `${item.at}: ${item.status}の ${item.id} が取りやめの ${dep} に依存している（${item.id} も取りやめにするか、依存から外す）`,
        );
      } else if (item.status === "完了" && target.status !== "完了") {
        violations.push(
          `${item.at}: 完了した ${item.id} が ${target.status} の ${dep} に依存している（再オープンは新しい ID で起こす）`,
        );
      }
    }
    if (item.kind === AGGREGATE) {
      const children = item.deps.flatMap((dep) => byId.get(dep)?.status ?? []);
      if (children.length === 0) violations.push(`${item.at}: 集約 ${item.id} の依存に子が無い`);
      else if (derive(children) !== item.status) {
        violations.push(
          `${item.at}: 集約 ${item.id} の状態は子から導くと "${derive(children)}"（現在 "${item.status}"）`,
        );
      }
    }
  }

  const cycle = findCycle(items, byId);
  if (cycle !== undefined) {
    const at = byId.get(cycle[0] ?? "")?.at ?? "";
    violations.push(`${at}: 依存が循環している: ${cycle.join(" → ")}`);
  }

  return { items, byId, files, violations };
}

// Kinds other than 実装 are marked where a list is not grouped by kind, unlike ready
function mark(item: Item): string {
  return item.kind === IMPLEMENTATION ? "" : `（${item.kind}）`;
}

function printStatus({ items, byId, files }: Model, scope: Scope | undefined): void {
  const summarized = scope === undefined ? files : files.filter((file) => scope.files.has(file));
  for (const file of summarized) {
    const own = items.filter((item) => item.file === file);
    const count = (s: Status) => own.filter((item) => item.status === s).length;
    const breakdown = STATUSES.map((s) => `${s} ${count(s)}`).join("、");
    // derive([]) is 取りやめ for aggregates, which would misreport a file without a table
    const state = own.length === 0 ? "項目なし" : derive(own.map((item) => item.status));
    console.log(`${state}  ${display(file)}  ${breakdown}`);
  }
  let first = scope !== undefined && summarized.length === 0;
  const heading = (title: string, empty: boolean) => {
    console.log(`${first ? "" : "\n"}${title}: ${empty ? "なし" : ""}`);
    first = false;
  };
  const shown = items.filter((item) => scope === undefined || scope.ids.has(item.id));
  // Aggregates are listed in both lists: the breakdown counts them, and a count the lists do not
  // add up to leaves the reader guessing where the item went. With ready, every open item
  // then appears somewhere, since an unstarted aggregate always waits on an unstarted child.
  const inProgress = shown.filter((item) => item.status === "進行中");
  heading("進行中の項目", inProgress.length === 0);
  for (const item of inProgress) console.log(`  ${item.id}  ${item.at}  ${mark(item)}${item.summary}`);
  const waiting = (item: Item) => openDeps(item, byId);
  // A dependency on hold will not move by itself, unlike one that is merely unfinished
  const onHold = (dep: string) => (byId.get(dep)?.status === "保留" ? "（保留）" : "");
  const blocked = shown.filter((item) => item.status === "未着手" && waiting(item).length > 0);
  heading("依存待ちの項目（← 待っている未完了の項目）", blocked.length === 0);
  for (const item of blocked) {
    const deps = waiting(item).map((dep) => `${dep}${onHold(dep)}`);
    console.log(`  ${item.id}  ← ${deps.join("、")}  ${item.at}  ${mark(item)}${item.summary}`);
  }
  if (scope !== undefined) {
    const blockers = items.filter((item) => scope.blockers.has(item.id));
    const related = (id: string) => scope.ids.has(id) || scope.blockers.has(id);
    const dependents = pendingDependents(items);
    heading("範囲外で待たれている項目（→ 直接待っている項目）", blockers.length === 0);
    for (const item of blockers) {
      const waiters = (dependents.get(item.id) ?? []).filter(related);
      console.log(
        `  ${item.id}  ${item.status}  → ${waiters.join("、")}  ${item.at}  ${mark(item)}${item.summary}`,
      );
    }
    const downstream = items.filter((item) => scope.waiters.has(item.id));
    heading("範囲の項目を待っている範囲外の項目（← 待っている未完了の項目）", downstream.length === 0);
    for (const item of downstream) {
      const deps = waiting(item).map((dep) => `${dep}${onHold(dep)}`);
      console.log(
        `  ${item.id}  ${item.status}  ← ${deps.join("、")}  ${item.at}  ${mark(item)}${item.summary}`,
      );
    }
  }
  // Last, so the work that can move comes first
  const held = shown.filter((item) => item.status === "保留");
  heading("保留の項目", held.length === 0);
  for (const item of held) console.log(`  ${item.id}  ${item.at}  ${mark(item)}${item.summary}`);
}

/**
 * Dependencies not yet 完了 or 取りやめ. check leaves a 取りやめ dependency only on an aggregate or
 * on another 取りやめ item, which are not waiting on it
 */
function openDeps(item: Item, byId: ReadonlyMap<string, Item>): string[] {
  return item.deps.filter((dep) => {
    const status = byId.get(dep)?.status;
    return status !== undefined && !CLOSED.has(status);
  });
}

/** Open items that list each ID as a dependency */
function pendingDependents(items: readonly Item[]): Map<string, string[]> {
  const dependents = new Map<string, string[]>();
  for (const item of items) {
    if (CLOSED.has(item.status)) continue;
    for (const dep of item.deps) dependents.set(dep, [...(dependents.get(dep) ?? []), item.id]);
  }
  return dependents;
}

/** IDs reachable from start through next, excluding start itself */
function reachable(
  start: string,
  next: (id: string) => readonly string[],
  include: (id: string) => boolean,
): Set<string> {
  const seen = new Set<string>();
  const stack = [...next(start)];
  for (let id = stack.pop(); id !== undefined; id = stack.pop()) {
    if (seen.has(id) || !include(id)) continue;
    seen.add(id);
    stack.push(...next(id));
  }
  return seen;
}

/** Open items, narrowed to the ancestors and descendants of focus. A focus may be closed */
function selectPending({ items, byId }: Model, focus: readonly string[]): Set<string> {
  const pendingIds = new Set(
    items.filter((item) => !CLOSED.has(item.status)).map((item) => item.id),
  );
  if (focus.length === 0) return pendingIds;
  const unknown = focus.filter((id) => !byId.has(id));
  if (unknown.length > 0) throw new UsageError(`存在しない ID: ${unknown.join(", ")}`);
  const dependents = pendingDependents(items);
  const isPending = (id: string) => pendingIds.has(id);
  const selected = new Set<string>();
  for (const id of focus) {
    selected.add(id);
    for (const x of reachable(id, (x) => byId.get(x)?.deps ?? [], isPending)) selected.add(x);
    for (const x of reachable(id, (x) => dependents.get(x) ?? [], isPending)) selected.add(x);
  }
  return selected;
}

function resolveScope({ items, byId }: Model, only: Cli["only"]): Scope {
  const unknown = only.ids.filter((id) => !byId.has(id));
  if (unknown.length > 0) throw new UsageError(`存在しない ID: ${unknown.join(", ")}`);
  const files = new Set(only.files);
  const ids = new Set([
    ...items.filter((item) => files.has(item.file)).map((item) => item.id),
    ...only.ids,
  ]);
  const isOpen = (id: string) => {
    const status = byId.get(id)?.status;
    return status !== undefined && !CLOSED.has(status);
  };
  const dependents = pendingDependents(items);
  const blockers = new Set<string>();
  const waiters = new Set<string>();
  for (const id of ids) {
    if (!isOpen(id)) continue;
    for (const dep of reachable(id, (x) => byId.get(x)?.deps ?? [], isOpen))
      if (!ids.has(dep)) blockers.add(dep);
    for (const dependent of reachable(id, (x) => dependents.get(x) ?? [], isOpen))
      if (!ids.has(dependent)) waiters.add(dependent);
  }
  return { files, ids, blockers, waiters };
}

function printReady({ items, byId }: Model, kinds: readonly string[], scope: Scope | undefined): void {
  const dependents = pendingDependents(items);
  const next = (x: string) => dependents.get(x) ?? [];
  // Items on hold and everything behind them, even through another path, would not start anyway
  const held = new Set(
    items
      .filter((item) => item.status === "保留")
      .flatMap((item) => [item.id, ...reachable(item.id, next, () => true)]),
  );
  // Priority hint: open items that cannot start until this one is done, transitively.
  // Aggregates only bundle other items, so they are not counted, and neither is anything held.
  const unblocks = (item: Item) =>
    [...reachable(item.id, next, (x) => !held.has(x))].filter(
      (id) => byId.get(id)?.kind !== AGGREGATE,
    );
  // Ranked by the whole count; the outside share tells whose work an item in scope holds up
  const rank = (group: readonly Item[]) =>
    group
      .map((item) => {
        const ids = unblocks(item);
        const outside = scope === undefined ? "" : `（範囲外 ${ids.filter((id) => !scope.ids.has(id)).length}）`;
        return { item, count: ids.length, label: `解放 ${ids.length}${outside}` };
      })
      // Array.prototype.sort is stable, so ties keep file order and then row order
      .sort((a, b) => b.count - a.count);
  const ready = items.filter(
    (item) =>
      item.status === "未着手" &&
      item.kind !== AGGREGATE &&
      item.deps.every((dep) => byId.get(dep)?.status === "完了"),
  );
  console.log(
    scope === undefined
      ? "解放 = 片付くまで着手できない未完了の項目数"
      : "解放 = 片付くまで着手できない未完了の項目数。括弧内はそのうち --only の範囲外の数",
  );
  for (const kind of kinds.filter((k) => k !== AGGREGATE)) {
    const group = rank(
      ready.filter((item) => item.kind === kind && (scope === undefined || scope.ids.has(item.id))),
    );
    console.log(`[${kind}] ${group.length} 件`);
    // The whole 内容, unlike deps and graph: an agent shows these to the user and would otherwise
    // read the rows again from the table
    for (const { item, label } of group) console.log(`  ${item.id}  ${label}  ${item.at}  ${item.summary}`);
  }
  if (scope === undefined) return;
  const blockers = rank(ready.filter((item) => scope.blockers.has(item.id)));
  console.log(
    `[範囲外で待たれている項目] ${blockers.length} 件（--only の項目が待っている、着手できる範囲外の項目）`,
  );
  for (const { item, label } of blockers)
    console.log(`  ${item.id}  ${label}  ${item.at}  ${mark(item)}${item.summary}`);
}

/** Dependencies for agents: one line per item, no diagram syntax or labels */
function printDeps(model: Model, focus: readonly string[]): void {
  const { items, byId } = model;
  const selected = selectPending(model, focus);
  const dependents = pendingDependents(items);
  const list = (ids: readonly string[]) => (ids.length === 0 ? "—" : ids.join("、"));
  console.log("ID 状態/種別 ← 待っている未完了の項目 → 待たせている項目  内容");
  let file: string | undefined;
  for (const item of items) {
    if (!selected.has(item.id)) continue;
    if (item.file !== file) {
      file = item.file;
      console.log(`## ${display(file)}`);
    }
    console.log(
      `${item.id} ${item.status}/${item.kind} ← ${list(openDeps(item, byId))} → ${list(dependents.get(item.id) ?? [])}  ${truncate(item.summary, 30)}`,
    );
  }
}

/** Mermaid node IDs are limited to ASCII letters and digits; anything else becomes u<hex> */
function nodeId(id: string): string {
  return id.replace(/[^A-Za-z0-9]/gu, (c) => `u${c.codePointAt(0)?.toString(16)}`);
}

/** Mermaid for humans. Agents read dependencies with printDeps */
function printGraph(model: Model, focus: readonly string[]): void {
  const { items } = model;
  const shown = selectPending(model, focus);
  const label = (item: Item) =>
    `${item.id}<br/>${truncate(item.summary, 16)}`.replaceAll('"', "#quot;");
  const shape = (item: Item) => {
    const text = label(item);
    if (item.kind === IMPLEMENTATION) return `["${text}"]`;
    if (item.kind === AGGREGATE) return `[["${text}"]]`;
    return `(["${text}"])`;
  };

  console.log("flowchart TD");
  const files = [...new Set(items.filter((item) => shown.has(item.id)).map((item) => item.file))];
  files.forEach((file, index) => {
    console.log(`  subgraph s${index}["${basename(file, ".md")}"]`);
    for (const item of items) {
      if (item.file === file && shown.has(item.id))
        console.log(`    ${nodeId(item.id)}${shape(item)}`);
    }
    console.log("  end");
  });
  for (const item of items) {
    if (!shown.has(item.id)) continue;
    const sources = item.deps.filter((dep) => shown.has(dep)).map(nodeId);
    if (sources.length > 0) console.log(`  ${sources.join(" & ")} --> ${nodeId(item.id)}`);
  }
}

const COMMANDS = ["status", "ready", "deps", "graph", "check"];
const KIND_OPTION = "--kind=";
const ONLY_OPTION = "--only=";

function usage(): string {
  return [
    "使い方: node plans.ts <status | ready | deps [ID...] | graph [ID...] | check> [--kind=<種別>]... [--only=<path か ID>]... -- <path>...",
    "  path: ファイル、または直下の *.md を読むディレクトリ（README.md と _ で始まる名前は除く）",
    `  --kind: ${DEFAULT_KINDS.join(" / ")} に足す、自律作業でない種別`,
    "  --only: status と ready の表示をこの計画と項目、それが待っている範囲外の項目に絞る（status は、この計画と項目を待っている範囲外の項目も出す。検証と解放は全体で計算する）",
    `  文法は backlog skill の SKILL.md（${display(SKILL_DOC)}）を参照`,
  ].join("\n");
}

/** Real paths, so one file reached through a symlink and directly is not read twice */
function expandPath(arg: string): string[] {
  const path = resolve(arg);
  try {
    const stat = statSync(path, { throwIfNoEntry: false });
    if (stat === undefined) throw new UsageError(`存在しないパス: ${arg}`);
    if (!stat.isDirectory()) return [realpathSync(path)];
  } catch (error) {
    if (error instanceof UsageError) throw error;
    throw ioError("読めないパス", path, error);
  }
  let names: string[];
  try {
    names = readdirSync(path);
  } catch (error) {
    throw ioError("読めないディレクトリ", path, error);
  }
  return names
    .filter((name) => name.endsWith(".md") && name !== "README.md" && !name.startsWith("_"))
    .map((name) => join(path, name))
    .flatMap((file) => {
      // A dangling link in the directory fails loudly: skipping it would hide a plan that is gone
      try {
        const real = realpathSync(file);
        return statSync(real).isFile() ? [real] : [];
      } catch (error) {
        throw ioError("読めないパス（壊れた symlink など）", file, error);
      }
    });
}

function parseArgs(argv: readonly string[]): Cli {
  const dashes = argv.indexOf("--");
  if (dashes === -1) throw new UsageError("パスの前に `--` が要る");
  const pathArgs = argv.slice(dashes + 1);
  if (pathArgs.length === 0) throw new UsageError("パスが無い");

  const extraKinds: string[] = [];
  const onlyArgs: string[] = [];
  const positional: string[] = [];
  for (const arg of argv.slice(0, dashes)) {
    if (arg.startsWith(KIND_OPTION)) {
      const kind = arg.slice(KIND_OPTION.length).trim();
      if (kind === "") throw new UsageError("--kind に種別が無い");
      extraKinds.push(kind);
    } else if (arg.startsWith(ONLY_OPTION)) {
      const target = arg.slice(ONLY_OPTION.length).trim();
      if (target === "") throw new UsageError("--only に計画のパスか ID が無い");
      onlyArgs.push(target);
    } else if (arg.startsWith("--")) {
      throw new UsageError(`未知のオプション "${arg}"`);
    } else {
      positional.push(arg);
    }
  }
  const [command = "", ...ids] = positional;
  if (!COMMANDS.includes(command))
    throw new UsageError(command === "" ? "コマンドが無い" : `未知のコマンド "${command}"`);
  if (ids.length > 0 && command !== "deps" && command !== "graph")
    throw new UsageError(`${command} は ID を取らない`);

  if (onlyArgs.length > 0 && command !== "status" && command !== "ready")
    throw new UsageError("--only は status と ready にだけ付ける");

  const files = [...new Set(pathArgs.flatMap(expandPath))].sort();
  const only = { ids: [] as string[], files: [] as string[] };
  for (const target of onlyArgs) {
    if (ID.test(target)) {
      only.ids.push(target);
      continue;
    }
    const targetFiles = expandPath(target);
    // Otherwise --only would be dropped and every plan shown as if it were not given
    if (targetFiles.length === 0) throw new UsageError(`--only のパス ${target} に計画が無い`);
    // A plan outside the paths would not be validated, and its items would not be found
    for (const file of targetFiles) {
      if (!files.includes(file))
        throw new UsageError(`--only のパス ${target} は \`--\` の後ろのパスに含まれない`);
      only.files.push(file);
    }
  }
  return { command, ids, kinds: [...new Set([...DEFAULT_KINDS, ...extraKinds])], files, only };
}

function run(argv: readonly string[]): number {
  const { command, ids, kinds, files, only } = parseArgs(argv);
  const model = load(files, kinds);
  if (model.violations.length > 0) {
    for (const violation of model.violations) console.error(violation);
    console.error(
      `\n${model.violations.length} 件の違反。文法は backlog skill の SKILL.md（${display(SKILL_DOC)}）を参照`,
    );
    return 1;
  }
  const scope =
    only.ids.length + only.files.length === 0 ? undefined : resolveScope(model, only);
  switch (command) {
    case "check":
      console.log(`${model.items.length} 件の項目に違反なし`);
      break;
    case "status":
      printStatus(model, scope);
      break;
    case "ready":
      printReady(model, kinds, scope);
      break;
    case "deps":
      printDeps(model, ids);
      break;
    case "graph":
      printGraph(model, ids);
      break;
  }
  return 0;
}

try {
  process.exitCode = run(process.argv.slice(2));
} catch (error) {
  if (!(error instanceof UsageError)) throw error;
  console.error(`${error.message}\n\n${usage()}`);
  process.exitCode = 2;
}
