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
const STATUSES = ["未着手", "進行中", "完了", "見送り"] as const;
type Status = (typeof STATUSES)[number];
const IMPLEMENTATION = "実装";
const AGGREGATE = "集約";
// A kind outside this list is a violation, so a typo cannot silently drop an item from the work
// an agent picks up on its own. Extra kinds come from --kind and are never autonomous.
const DEFAULT_KINDS = [IMPLEMENTATION, "人手", "判断", AGGREGATE];
/** A dependent no longer waits for a dependency in one of these states */
const SETTLED: ReadonlySet<Status> = new Set(["完了", "見送り"]);

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
  const live = statuses.filter((s) => s !== "見送り");
  if (live.length === 0) return "見送り";
  if (live.every((s) => s === "完了")) return "完了";
  if (live.every((s) => s === "未着手")) return "未着手";
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
  const items = parsed.map((item) =>
    item.ranges.length === 0
      ? item
      : { ...item, deps: [...item.deps, ...suffixedInRanges(item, allIds)] },
  );

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
      } else if (item.status === "完了" && !SETTLED.has(target.status)) {
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

function printStatus({ items, files }: Model): void {
  for (const file of files) {
    const own = items.filter((item) => item.file === file);
    const count = (s: Status) => own.filter((item) => item.status === s).length;
    const breakdown = STATUSES.map((s) => `${s} ${count(s)}`).join("、");
    // derive([]) is 見送り for aggregates, which would misreport a file without a table
    const state = own.length === 0 ? "項目なし" : derive(own.map((item) => item.status));
    console.log(`${state}  ${display(file)}  ${breakdown}`);
  }
  const inProgress = items.filter((item) => item.status === "進行中" && item.kind !== AGGREGATE);
  console.log(`\n進行中の項目: ${inProgress.length === 0 ? "なし" : ""}`);
  for (const item of inProgress)
    console.log(`  ${item.id}  ${item.at}  ${truncate(item.summary, 50)}`);
}

/** Unsettled items that list each ID as a dependency */
function pendingDependents(items: readonly Item[]): Map<string, string[]> {
  const dependents = new Map<string, string[]>();
  for (const item of items) {
    if (SETTLED.has(item.status)) continue;
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

/** Unsettled items, narrowed to the ancestors and descendants of focus. A focus may be settled */
function selectPending({ items, byId }: Model, focus: readonly string[]): Set<string> {
  const pendingIds = new Set(
    items.filter((item) => !SETTLED.has(item.status)).map((item) => item.id),
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

function printReady({ items, byId }: Model, kinds: readonly string[]): void {
  const dependents = pendingDependents(items);
  // Priority hint: unsettled items that cannot start until this one is done, transitively.
  // Aggregates only bundle other items, so they are not counted.
  const unblocks = (item: Item) =>
    [
      ...reachable(
        item.id,
        (x) => dependents.get(x) ?? [],
        () => true,
      ),
    ].filter((id) => byId.get(id)?.kind !== AGGREGATE).length;
  const ready = items.filter(
    (item) =>
      item.status === "未着手" &&
      item.kind !== AGGREGATE &&
      item.deps.every((dep) => {
        const status = byId.get(dep)?.status;
        return status !== undefined && SETTLED.has(status);
      }),
  );
  for (const kind of kinds.filter((k) => k !== AGGREGATE)) {
    const group = ready
      .filter((item) => item.kind === kind)
      .map((item) => ({ item, count: unblocks(item) }))
      // Array.prototype.sort is stable, so ties keep file order and then row order
      .sort((a, b) => b.count - a.count);
    console.log(`[${kind}] ${group.length} 件（解放 = 片付くまで着手できない未完了の項目数）`);
    for (const { item, count } of group)
      console.log(`  ${item.id}  解放 ${count}  ${item.at}  ${truncate(item.summary, 60)}`);
  }
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
    const waiting = item.deps.filter((dep) => {
      const status = byId.get(dep)?.status;
      return status !== undefined && !SETTLED.has(status);
    });
    console.log(
      `${item.id} ${item.status}/${item.kind} ← ${list(waiting)} → ${list(dependents.get(item.id) ?? [])}  ${truncate(item.summary, 30)}`,
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

function usage(): string {
  return [
    "使い方: node plans.ts <status | ready | deps [ID...] | graph [ID...] | check> [--kind=<種別>]... -- <path>...",
    "  path: ファイル、または直下の *.md を読むディレクトリ（README.md と _ で始まる名前は除く）",
    `  --kind: ${DEFAULT_KINDS.join(" / ")} に足す、自律作業でない種別`,
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
  const positional: string[] = [];
  for (const arg of argv.slice(0, dashes)) {
    if (arg.startsWith(KIND_OPTION)) {
      const kind = arg.slice(KIND_OPTION.length).trim();
      if (kind === "") throw new UsageError("--kind に種別が無い");
      extraKinds.push(kind);
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

  const files = [...new Set(pathArgs.flatMap(expandPath))].sort();
  return { command, ids, kinds: [...new Set([...DEFAULT_KINDS, ...extraKinds])], files };
}

function run(argv: readonly string[]): number {
  const { command, ids, kinds, files } = parseArgs(argv);
  const model = load(files, kinds);
  if (model.violations.length > 0) {
    for (const violation of model.violations) console.error(violation);
    console.error(
      `\n${model.violations.length} 件の違反。文法は backlog skill の SKILL.md（${display(SKILL_DOC)}）を参照`,
    );
    return 1;
  }
  switch (command) {
    case "check":
      console.log(`${model.items.length} 件の項目に違反なし`);
      break;
    case "status":
      printStatus(model);
      break;
    case "ready":
      printReady(model, kinds);
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
