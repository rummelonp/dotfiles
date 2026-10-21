import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import { chmodSync, mkdirSync, mkdtempSync, realpathSync, symlinkSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { test } from "node:test";

const SCRIPT = join(import.meta.dirname, "plans.ts");
const TABLE = "| # | 状態 | 種別 | 依存 | 内容 |\n|---|---|---|---|---|\n";

// realpath: process.cwd() in the child is the real path, and display() compares against it
const root = realpathSync(mkdtempSync(join(tmpdir(), "backlog-plans-")));
let counter = 0;

function fixtureDir(): string {
  const dir = join(root, `case${counter++}`);
  mkdirSync(dir, { recursive: true });
  return dir;
}

function write(dir: string, name: string, body: string): string {
  const path = join(dir, name);
  writeFileSync(path, body);
  return path;
}

function plan(...rows: string[]): string {
  return `${TABLE}${rows.join("\n")}\n`;
}

interface Result {
  readonly status: number | null;
  readonly stdout: string;
  readonly stderr: string;
}

function run(args: string[], options: { cwd?: string } = {}): Result {
  const result = spawnSync(process.execPath, [SCRIPT, ...args], {
    cwd: options.cwd ?? root,
    encoding: "utf8",
  });
  return { status: result.status, stdout: result.stdout, stderr: result.stderr };
}

const VALID = [
  "---",
  "name: sample",
  "description: a | b",
  "---",
  "# Sample",
  "",
  TABLE.trimEnd(),
  "| A1 | 完了 | 実装 | — | first |",
  "| A2 | 未着手 | 実装 | A1 | second |",
  "| A3 | 未着手 | 人手 | A1 | manual step |",
  "| A4 | 未着手 | 判断 | — | decide `this` |",
  "| A5 | 進行中 | 集約 | A1、A2 | bundle |",
  "",
].join("\n");

test("status summarizes each file and lists items in progress and items waiting", () => {
  const dir = fixtureDir();
  write(
    dir,
    "a.md",
    VALID.replace("| A2 | 未着手", "| A2 | 進行中").replace(
      "bundle |\n",
      [
        "bundle |",
        "| A6 | 未着手 | 人手 | A1、A2〜A4 | after second |",
        "| A7 | 未着手 | 集約 | A6 | later bundle |",
        "",
      ].join("\n"),
    ),
  );
  const { status, stdout } = run(["status", "--", "a.md"], { cwd: dir });
  assert.equal(status, 0);
  assert.equal(
    stdout,
    [
      "進行中  a.md  未着手 4、進行中 2、完了 1、取りやめ 0、保留 0",
      "",
      "進行中の項目: ",
      "  A2  a.md:10  second",
      "  A5  a.md:13  （集約）bundle",
      "",
      "依存待ちの項目（← 待っている未完了の項目）: ",
      "  A6  ← A2、A3、A4  a.md:14  （人手）after second",
      "  A7  ← A6  a.md:15  （集約）later bundle",
      "",
      "保留の項目: なし",
      "",
    ].join("\n"),
  );
});

test("status says なし when nothing is in progress or waiting", () => {
  const dir = fixtureDir();
  write(dir, "a.md", plan("| A1 | 完了 | 実装 | — | x |", "| A2 | 未着手 | 実装 | A1 | y |"));
  const { stdout } = run(["status", "--", "a.md"], { cwd: dir });
  assert.match(stdout, /^進行中の項目: なし$/m);
  assert.match(stdout, /^依存待ちの項目（← 待っている未完了の項目）: なし$/m);
  assert.match(stdout, /^保留の項目: なし$/m);
});

const ON_HOLD = plan(
  "| O1 | 完了 | 実装 | — | done |",
  "| O2 | 保留 | 判断 | O1 | decide later |",
  "| O3 | 未着手 | 実装 | O2 | build after the decision |",
  "| O4 | 未着手 | 実装 | O3 | build after that |",
  "| O5 | 未着手 | 実装 | O1 | unrelated |",
  "| O6 | 保留 | 実装 | — | parked |",
  "| O7 | 未着手 | 実装 | — | independent |",
);

test("status lists items on hold last and marks dependencies on hold", () => {
  const dir = fixtureDir();
  write(dir, "a.md", ON_HOLD.replace("| O3 | 未着手 | 実装 | O2 |", "| O3 | 未着手 | 実装 | O2、O7 |"));
  const { status, stdout } = run(["status", "--", "a.md"], { cwd: dir });
  assert.equal(status, 0);
  assert.equal(
    stdout,
    [
      "進行中  a.md  未着手 4、進行中 0、完了 1、取りやめ 0、保留 2",
      "",
      "進行中の項目: なし",
      "",
      "依存待ちの項目（← 待っている未完了の項目）: ",
      "  O3  ← O2（保留）、O7  a.md:5  build after the decision",
      "  O4  ← O3  a.md:6  build after that",
      "",
      "保留の項目: ",
      "  O2  a.md:4  （判断）decide later",
      "  O6  a.md:8  parked",
      "",
    ].join("\n"),
  );
});

test("ready skips items on hold and items waiting on them, and does not count past them", () => {
  const dir = fixtureDir();
  write(
    dir,
    "a.md",
    `${ON_HOLD.replace("| O4 | 未着手 | 実装 | O3 |", "| O4 | 未着手 | 実装 | O3、O7 |")}${[
      "| O8 | 保留 | 実装 | O7 | held after O7 |",
      "| O9 | 未着手 | 実装 | O8 | after the held one |",
      "| O10 | 未着手 | 実装 | O7 | only after O7 |",
      "",
    ].join("\n")}`,
  );
  const { status, stdout } = run(["ready", "--", "a.md"], { cwd: dir });
  assert.equal(status, 0);
  const ids = [...stdout.matchAll(/^ {2}(\w+) {2}解放 (\d+)/gm)].map((m) => `${m[1]}:${m[2]}`);
  // O7 unblocks O10 only: O8 is on hold, O9 is behind O8, and O4 is behind O2 through O3.
  // O1 is done, and O3 waits on O2, which is on hold
  assert.deepEqual(ids, ["O7:1", "O5:0"]);
  assert.match(stdout, /^\[判断\] 0 件/m);
});

test("deps lists items on hold with their state", () => {
  const dir = fixtureDir();
  write(dir, "a.md", ON_HOLD);
  const { stdout } = run(["deps", "O3", "--", "a.md"], { cwd: dir });
  assert.match(stdout, /^O2 保留\/判断 ← — → O3 {2}decide later$/m);
  assert.match(stdout, /^O3 未着手\/実装 ← O2 → O4 /m);
});

test("status and ready print the whole 内容", () => {
  const dir = fixtureDir();
  const long = "x".repeat(100);
  write(
    dir,
    "a.md",
    plan(`| A1 | 未着手 | 実装 | — | ${long} |`, `| A2 | 進行中 | 実装 | — | ${long} |`),
  );
  const ready = run(["ready", "--", "a.md"], { cwd: dir }).stdout;
  assert.match(ready, new RegExp(`^ {2}A1 .* ${long}$`, "m"));
  const status = run(["status", "--", "a.md"], { cwd: dir }).stdout;
  assert.match(status, new RegExp(`^ {2}A2 .* ${long}$`, "m"));
});

test("ready groups by kind and lists only unblocked, unstarted items", () => {
  const dir = fixtureDir();
  write(dir, "a.md", VALID);
  const { status, stdout } = run(["ready", "--", "a.md"], { cwd: dir });
  assert.equal(status, 0);
  assert.equal(
    stdout,
    [
      "[実装] 1 件（解放 = 片付くまで着手できない未完了の項目数）",
      "  A2  解放 0  a.md:10  second",
      "[人手] 1 件（解放 = 片付くまで着手できない未完了の項目数）",
      "  A3  解放 0  a.md:11  manual step",
      "[判断] 1 件（解放 = 片付くまで着手できない未完了の項目数）",
      "  A4  解放 0  a.md:12  decide this",
      "",
    ].join("\n"),
  );
});

test("deps prints one line per unsettled item and narrows by ID", () => {
  const dir = fixtureDir();
  write(dir, "a.md", VALID);
  const all = run(["deps", "--", "a.md"], { cwd: dir });
  assert.equal(all.status, 0);
  assert.equal(
    all.stdout,
    [
      "ID 状態/種別 ← 待っている未完了の項目 → 待たせている項目  内容",
      "## a.md",
      "A2 未着手/実装 ← — → A5  second",
      "A3 未着手/人手 ← — → —  manual step",
      "A4 未着手/判断 ← — → —  decide this",
      "A5 進行中/集約 ← A2 → —  bundle",
      "",
    ].join("\n"),
  );
  const focused = run(["deps", "A5", "--", "a.md"], { cwd: dir });
  assert.match(focused.stdout, /^A2 /m);
  assert.match(focused.stdout, /^A5 /m);
  assert.doesNotMatch(focused.stdout, /^A3 /m);
});

test("graph draws implementation, aggregate and other kinds with distinct shapes", () => {
  const dir = fixtureDir();
  write(dir, "a.md", VALID);
  const { status, stdout } = run(["graph", "--", "a.md"], { cwd: dir });
  assert.equal(status, 0);
  assert.equal(
    stdout,
    [
      "flowchart TD",
      '  subgraph s0["a"]',
      '    A2["A2<br/>second"]',
      '    A3(["A3<br/>manual step"])',
      '    A4(["A4<br/>decide this"])',
      '    A5[["A5<br/>bundle"]]',
      "  end",
      "  A2 --> A5",
      "",
    ].join("\n"),
  );
});

test("graph node IDs keep ASCII alphanumerics and encode other characters", () => {
  const dir = fixtureDir();
  write(dir, "a.md", plan("| α1 | 未着手 | 実装 | — | greek |", "| β2a | 未着手 | 実装 | α1 | next |"));
  const { status, stdout } = run(["graph", "--", "a.md"], { cwd: dir });
  assert.equal(status, 0);
  assert.match(stdout, /^ {4}u3b11\["α1<br\/>greek"\]$/m);
  assert.match(stdout, /^ {2}u3b11 --> u3b22a$/m);
});

test("check passes a valid fixture and reports the item count", () => {
  const dir = fixtureDir();
  write(dir, "a.md", VALID);
  const { status, stdout } = run(["check", "--", "a.md"], { cwd: dir });
  assert.equal(status, 0);
  assert.equal(stdout, "5 件の項目に違反なし\n");
});

const VIOLATIONS: ReadonlyArray<readonly [string, string, RegExp]> = [
  [
    "duplicate ID",
    plan("| A1 | 未着手 | 実装 | — | x |", "| A1 | 未着手 | 実装 | — | y |"),
    /ID "A1" が a\.md:3 と重複/,
  ],
  ["missing dependency", plan("| A1 | 未着手 | 実装 | A9 | x |"), /A1 の依存 "A9" が存在しない/],
  [
    "completed item depending on unfinished",
    plan("| A1 | 未着手 | 実装 | — | x |", "| A2 | 完了 | 実装 | A1 | y |"),
    /完了した A2 が 未着手 の A1 に依存/,
  ],
  [
    "completed item depending on an item on hold",
    plan("| A1 | 保留 | 実装 | — | x |", "| A2 | 完了 | 実装 | A1 | y |"),
    /完了した A2 が 保留 の A1 に依存/,
  ],
  [
    "completed item depending on a cancelled one",
    plan("| A1 | 取りやめ | 実装 | — | x |", "| A2 | 完了 | 実装 | A1 | y |"),
    /完了した A2 が取りやめの A1 に依存している（依存から外す）/,
  ],
  ...(["未着手", "進行中", "保留"] as const).map(
    (status) =>
      [
        `${status} item depending on a cancelled one`,
        plan("| A1 | 取りやめ | 判断 | — | x |", `| A2 | ${status} | 実装 | A1 | y |`),
        new RegExp(`${status}の A2 が取りやめの A1 に依存している（A2 も取りやめにするか、依存から外す）`),
      ] as const,
  ),
  [
    "aggregate state mismatch",
    plan("| A1 | 完了 | 実装 | — | x |", "| A2 | 未着手 | 集約 | A1 | y |"),
    /集約 A2 の状態は子から導くと "完了"（現在 "未着手"）/,
  ],
  ["aggregate without children", plan("| A1 | 未着手 | 集約 | — | x |"), /集約 A1 の依存に子が無い/],
  [
    "dependency cycle",
    plan("| A1 | 未着手 | 実装 | A2 | x |", "| A2 | 未着手 | 実装 | A1 | y |"),
    /依存が循環している: A1 → A2 → A1/,
  ],
  ["unknown kind", plan("| A1 | 未着手 | 実施 | — | x |"), /種別 "実施" は 実装 \/ 人手 \/ 判断 \/ 集約/],
  ["unknown status", plan("| A1 | 待機 | 実装 | — | x |"), /状態 "待機" は/],
  ["bad ID", plan("| 1A | 未着手 | 実装 | — | x |"), /ID "1A" は ID の文法に合わない/],
  ["prose dependency", plan("| A1 | 未着手 | 実装 | 先に調べる | x |"), /依存 "先に調べる" は ID でも範囲でもない/],
  [
    "descending range",
    plan("| A1 | 未着手 | 実装 | — | x |", "| A2 | 未着手 | 実装 | A1 | x |", "| A3 | 未着手 | 実装 | A2〜A1 | y |"),
    /範囲 "A2〜A1" は同じ接頭辞で昇順/,
  ],
  [
    "full-width tilde in range",
    plan("| A1 | 未着手 | 実装 | — | x |", "| A2 | 未着手 | 実装 | A1～A2 | y |"),
    /依存 "A1～A2" は ID でも範囲でもない/,
  ],
  [
    "ID in a table that is not a backlog item table",
    "| 番号 | 状態 |\n|---|---|\n| A1 | 未着手 |\n",
    /ID "A1" が項目の表でない表にある/,
  ],
  [
    "missing separator row",
    "| # | 状態 | 種別 | 依存 | 内容 |\n| A1 | 未着手 | 実装 | — | x |\n",
    /項目の表のヘッダの次に区切り行が無い/,
  ],
  ["table without leading pipe", "a | b\n--- | ---\n1 | 2\n", /表の行頭の "\|" を省かない/],
];

for (const [name, body, message] of VIOLATIONS) {
  test(`check rejects: ${name}`, () => {
    const dir = fixtureDir();
    write(dir, "a.md", body);
    const { status, stderr, stdout } = run(["check", "--", "a.md"], { cwd: dir });
    assert.equal(status, 1);
    assert.equal(stdout, "");
    assert.match(stderr, message);
    assert.match(stderr, /backlog skill の SKILL\.md/);
  });
}

test("a violation stops every command, not only check", () => {
  const dir = fixtureDir();
  write(dir, "a.md", plan("| A1 | 未着手 | 実施 | — | x |"));
  for (const command of ["status", "ready", "deps", "graph"]) {
    assert.equal(run([command, "--", "a.md"], { cwd: dir }).status, 1, command);
  }
});

test("tables inside code fences are ignored", () => {
  const dir = fixtureDir();
  write(dir, "a.md", `\`\`\`\n${plan("| A1 | 未着手 | 実施 | — | x |")}\`\`\`\n\n${plan("| B1 | 未着手 | 実装 | — | y |")}`);
  const { status, stdout } = run(["check", "--", "a.md"], { cwd: dir });
  assert.equal(status, 0);
  assert.equal(stdout, "1 件の項目に違反なし\n");
});

test("--kind adds a non-autonomous kind and is required for it to pass check", () => {
  const dir = fixtureDir();
  write(
    dir,
    "a.md",
    plan("| A1 | 未着手 | PO 判断 | — | ask the PO |", "| A2 | 未着手 | 実装 | — | build |"),
  );
  const without = run(["check", "--", "a.md"], { cwd: dir });
  assert.equal(without.status, 1);
  assert.match(without.stderr, /種別 "PO 判断" は/);
  assert.match(without.stderr, /--kind=<種別>/);

  const args = ["--kind=PO 判断", "--kind=PO 判断", "--", "a.md"];
  assert.equal(run(["check", ...args], { cwd: dir }).status, 0);

  const ready = run(["ready", ...args], { cwd: dir }).stdout;
  assert.match(ready, /^\[PO 判断\] 1 件/m);
  assert.match(ready, /^ {2}A1 {2}解放 0 {2}a\.md:3 {2}ask the PO$/m);
  assert.ok(ready.indexOf("[判断]") < ready.indexOf("[PO 判断]"));

  const graph = run(["graph", ...args], { cwd: dir }).stdout;
  assert.match(graph, /^ {4}A1\(\["A1<br\/>ask the PO"\]\)$/m);
  assert.match(graph, /^ {4}A2\["A2<br\/>build"\]$/m);
});

test("--kind may appear before the command", () => {
  const dir = fixtureDir();
  write(dir, "a.md", plan("| A1 | 未着手 | PO 判断 | — | x |"));
  assert.equal(run(["--kind=PO 判断", "check", "--", "a.md"], { cwd: dir }).status, 0);
});

test("directory arguments read direct *.md children except README.md and _-prefixed names", () => {
  const dir = fixtureDir();
  const bad = plan("| Z1 | 未着手 | 実施 | — | x |");
  write(dir, "a.md", plan("| A1 | 未着手 | 実装 | — | x |"));
  write(dir, "README.md", bad);
  write(dir, "_template.md", bad);
  write(dir, "notes.txt", bad);
  mkdirSync(join(dir, "nested"));
  write(join(dir, "nested"), "b.md", bad);
  const { status, stdout } = run(["check", "--", "."], { cwd: dir });
  assert.equal(status, 0);
  assert.equal(stdout, "1 件の項目に違反なし\n");
});

test("an explicitly named README.md is read", () => {
  const dir = fixtureDir();
  write(dir, "README.md", plan("| Z1 | 未着手 | 実施 | — | x |"));
  assert.equal(run(["check", "--", "README.md"], { cwd: dir }).status, 1);
});

test("files are deduplicated and sorted by resolved path regardless of argument order", () => {
  const dir = fixtureDir();
  write(dir, "x.md", plan("| X1 | 未着手 | 実装 | — | x1 |", "| X2 | 未着手 | 実装 | — | x2 |", "| X3 | 未着手 | 実装 | X2 | x3 |"));
  write(dir, "y.md", plan("| Y1 | 未着手 | 実装 | — | y1 |"));
  const { status, stdout } = run(["ready", "--", "y.md", "x.md", ".", "./y.md"], { cwd: dir });
  assert.equal(status, 0);
  const ids = [...stdout.matchAll(/^ {2}(\w+) {2}解放 (\d+)/gm)].map((m) => `${m[1]}:${m[2]}`);
  // X2 unblocks X3; X1 and Y1 tie and keep file order, then row order
  assert.deepEqual(ids, ["X2:1", "X1:0", "Y1:0"]);
  assert.match(run(["check", "--", "y.md", "x.md", ".", "./y.md"], { cwd: dir }).stdout, /^4 件/);
});

test("ties in ready keep row order within a file", () => {
  const dir = fixtureDir();
  write(dir, "a.md", plan("| A3 | 未着手 | 実装 | — | c |", "| A1 | 未着手 | 実装 | — | a |", "| A2 | 未着手 | 実装 | — | b |"));
  const ids = [...run(["ready", "--", "a.md"], { cwd: dir }).stdout.matchAll(/^ {2}(A\d)/gm)].map((m) => m[1]);
  assert.deepEqual(ids, ["A3", "A1", "A2"]);
});

test("a file outside cwd is shown as an absolute path, even under HOME", () => {
  const dir = fixtureDir();
  const file = write(dir, "a.md", plan("| A1 | 未着手 | 実施 | — | x |"));
  const elsewhere = fixtureDir();

  const absolute = spawnSync(process.execPath, [SCRIPT, "check", "--", file], {
    cwd: elsewhere,
    encoding: "utf8",
    env: { ...process.env, HOME: root },
  });
  assert.equal(absolute.status, 1);
  assert.ok(absolute.stderr.startsWith(`${file}:3: `), absolute.stderr);

  const relative = run(["check", "--", file], { cwd: dir });
  assert.ok(relative.stderr.startsWith("a.md:3: "), relative.stderr);
});

test("YAML frontmatter is ignored, including a | in its values", () => {
  const dir = fixtureDir();
  write(
    dir,
    "memo.md",
    ["---", "name: backlog", "description: a | b", "metadata:", "  note: |", "    x | y", "---", "", plan("| M1 | 未着手 | 実装 | — | from memory |")].join("\n"),
  );
  const { status, stdout } = run(["ready", "--", "memo.md"], { cwd: dir });
  assert.equal(status, 0);
  assert.match(stdout, /^ {2}M1 {2}解放 0 {2}memo\.md:11 {2}from memory$/m);
});

test("ranges expand, include suffixed IDs inside the range, and exclude others", () => {
  const dir = fixtureDir();
  write(
    dir,
    "a.md",
    plan(
      "| C1 | 完了 | 実装 | — | c1 |",
      "| C2 | 完了 | 実装 | — | c2 |",
      "| C2a | 未着手 | 実装 | C1 | split from c2 |",
      "| C3 | 完了 | 実装 | — | c3 |",
      "| C4 | 未着手 | 実装 | — | outside |",
      "| D1 | 未着手 | 実装 | C1〜C3 | uses range |",
      "| D2 | 進行中 | 集約 | C1〜C3、C4 | bundle |",
    ),
  );
  const { status, stdout } = run(["deps", "D1", "--", "a.md"], { cwd: dir });
  assert.equal(status, 0);
  assert.match(stdout, /^D1 未着手\/実装 ← C2a → — {2}uses range$/m);
  assert.match(stdout, /^C2a /m);
  assert.doesNotMatch(stdout, /^C4 /m);
  assert.equal(run(["check", "--", "a.md"], { cwd: dir }).status, 0);
});

test("a range does not capture suffixed IDs of other prefixes or outside its bounds", () => {
  const dir = fixtureDir();
  write(
    dir,
    "a.md",
    plan(
      "| C1 | 完了 | 実装 | — | c1 |",
      "| C2 | 完了 | 実装 | — | c2 |",
      "| C5a | 未着手 | 実装 | — | out of range |",
      "| E2a | 未着手 | 実装 | — | other prefix |",
      "| D1 | 未着手 | 実装 | C1〜C2 | uses range |",
    ),
  );
  const { stdout } = run(["deps", "D1", "--", "a.md"], { cwd: dir });
  assert.match(stdout, /^D1 未着手\/実装 ← — → — /m);
});

test("a dependency given both in a range and explicitly is listed once", () => {
  const dir = fixtureDir();
  write(
    dir,
    "a.md",
    plan(
      "| C1 | 未着手 | 実装 | — | c1 |",
      "| C2 | 未着手 | 実装 | — | c2 |",
      "| C2a | 未着手 | 実装 | — | split from c2 |",
      "| D1 | 未着手 | 実装 | C1〜C2、C2、C2a | uses range |",
    ),
  );
  const { status, stdout } = run(["status", "--", "a.md"], { cwd: dir });
  assert.equal(status, 0);
  assert.match(stdout, /^ {2}D1 {2}← C1、C2、C2a {2}/m);
});

test("usage errors exit 2", () => {
  const dir = fixtureDir();
  write(dir, "a.md", plan("| A1 | 未着手 | 実装 | — | x |"));
  const cases: ReadonlyArray<readonly [string, string[], RegExp]> = [
    ["missing --", ["check", "a.md"], /`--` が要る/],
    ["no paths", ["check", "--"], /パスが無い/],
    ["nonexistent path", ["check", "--", "missing.md"], /存在しないパス: missing\.md/],
    ["unknown command", ["frobnicate", "--", "a.md"], /未知のコマンド "frobnicate"/],
    ["no command", ["--", "a.md"], /コマンドが無い/],
    ["unknown option", ["check", "--kinds=x", "--", "a.md"], /未知のオプション/],
    ["empty --kind", ["check", "--kind=", "--", "a.md"], /--kind に種別が無い/],
    ["unknown ID", ["deps", "Z9", "--", "a.md"], /存在しない ID: Z9/],
    ["ID given to ready", ["ready", "A1", "--", "a.md"], /ready は ID を取らない/],
  ];
  for (const [name, args, message] of cases) {
    const { status, stderr, stdout } = run(args, { cwd: dir });
    assert.equal(status, 2, name);
    assert.equal(stdout, "", name);
    assert.match(stderr, message, name);
    assert.match(stderr, /使い方: node plans\.ts/, name);
  }
});

test("a usage error wins over table violations", () => {
  const dir = fixtureDir();
  write(dir, "a.md", plan("| A1 | 未着手 | 実施 | — | x |"));
  assert.equal(run(["frobnicate", "--", "a.md"], { cwd: dir }).status, 2);
});

test("status reports a file without any item as 項目なし, not 取りやめ", () => {
  const dir = fixtureDir();
  write(dir, "empty.md", "# Notes\n\nno table here\n");
  write(dir, "cancelled.md", plan("| S1 | 取りやめ | 実装 | — | x |"));
  const { status, stdout } = run(["status", "--", "."], { cwd: dir });
  assert.equal(status, 0);
  assert.match(stdout, /^項目なし {2}empty\.md {2}未着手 0、進行中 0、完了 0、取りやめ 0、保留 0$/m);
  assert.match(stdout, /^取りやめ {2}cancelled\.md /m);
});

test("a cancelled item may depend on anything, and another cancelled item may depend on it", () => {
  const dir = fixtureDir();
  write(
    dir,
    "a.md",
    plan(
      "| A1 | 未着手 | 実装 | — | x |",
      "| A2 | 保留 | 実装 | — | x |",
      "| A3 | 取りやめ | 実装 | A1、A2 | x |",
      "| A4 | 取りやめ | 実装 | A3 | x |",
    ),
  );
  assert.equal(run(["check", "--", "a.md"], { cwd: dir }).status, 0);
});

for (const [children, derived] of [
  [["取りやめ"], "取りやめ"],
  [["取りやめ", "取りやめ"], "取りやめ"],
  [["完了", "完了"], "完了"],
  [["完了", "取りやめ"], "完了"],
  [["保留", "保留"], "保留"],
  [["完了", "保留", "取りやめ"], "保留"],
  [["未着手", "未着手"], "未着手"],
  [["未着手", "保留", "取りやめ"], "未着手"],
  [["完了", "未着手"], "進行中"],
  [["完了", "未着手", "保留"], "進行中"],
  [["進行中", "保留"], "進行中"],
] as const) {
  test(`an aggregate of ${children.join("、")} is derived as ${derived}`, () => {
    const dir = fixtureDir();
    const rows = children.map((status, i) => `| C${i + 1} | ${status} | 実装 | — | x |`);
    const deps = children.map((_, i) => `C${i + 1}`).join("、");
    const aggregate = (status: string) => plan(...rows, `| G1 | ${status} | 集約 | ${deps} | g |`);
    write(dir, "a.md", aggregate(derived));
    assert.equal(run(["check", "--", "a.md"], { cwd: dir }).stdout, `${children.length + 1} 件の項目に違反なし\n`);
    const wrong = derived === "進行中" ? "未着手" : "進行中";
    write(dir, "a.md", aggregate(wrong));
    assert.match(
      run(["check", "--", "a.md"], { cwd: dir }).stderr,
      new RegExp(`集約 G1 の状態は子から導くと "${derived}"（現在 "${wrong}"）`),
    );
  });
}

test("an open aggregate does not wait on its cancelled children", () => {
  const dir = fixtureDir();
  write(
    dir,
    "a.md",
    plan("| C1 | 取りやめ | 実装 | — | x |", "| C2 | 未着手 | 実装 | — | y |", "| G1 | 未着手 | 集約 | C1、C2 | g |"),
  );
  const { status, stdout } = run(["status", "--", "a.md"], { cwd: dir });
  assert.equal(status, 0);
  assert.match(stdout, /^ {2}G1 {2}← C2 {2}a\.md:5 /m);
});

const FENCED = (open: string, inner: string, close: string): string =>
  `${open}\n${inner}\n${close}\n\n${plan("| B1 | 未着手 | 実装 | — | real |")}`;
const BAD_ROW = plan("| A1 | 未着手 | 実施 | — | x |");

for (const [name, body] of [
  ["``` inside ~~~", FENCED("~~~", `\`\`\`\n${BAD_ROW}\`\`\``, "~~~")],
  ["``` inside a four-backtick fence", FENCED("````", `\`\`\`\n${BAD_ROW}\`\`\``, "````")],
  ["a shorter marker does not close", FENCED("````", `\`\`\`\n${BAD_ROW}`, "````")],
  ["a different marker does not close", FENCED("~~~", `\`\`\`\n${BAD_ROW}`, "~~~")],
  ["a closing marker may be longer", FENCED("```", BAD_ROW, "`````")],
  ["a closing marker has no info string", FENCED("```", `${BAD_ROW}\`\`\`ts`, "```")],
] as const) {
  test(`code fences follow CommonMark: ${name}`, () => {
    const dir = fixtureDir();
    write(dir, "a.md", body);
    const { status, stdout } = run(["check", "--", "a.md"], { cwd: dir });
    assert.equal(status, 0);
    assert.equal(stdout, "1 件の項目に違反なし\n");
  });
}

test("a table after a closed fence is read, and one in inline ``` is not hidden", () => {
  const dir = fixtureDir();
  write(dir, "a.md", `\`\`\`code\`\`\` is inline\n\n${BAD_ROW}`);
  const { status, stderr } = run(["check", "--", "a.md"], { cwd: dir });
  assert.equal(status, 1);
  assert.match(stderr, /種別 "実施"/);
});

for (const [name, line] of [
  ["indented", "  | # | 状態 | 種別 | 依存 | 内容 |"],
  ["in a list", "- | # | 状態 | 種別 | 依存 | 内容 |"],
  ["in a quote", "> | # | 状態 | 種別 | 依存 | 内容 |"],
  ["in a nested quote list", "> - | # | 状態 | 種別 | 依存 |"],
  ["in a nested list", "- * | # | 状態 | 種別 | 依存 |"],
  ["in an ordered list", "1. | # | 状態 | 種別 | 依存 |"],
  ["after a + marker", "+ | # | 状態 | 種別 | 依存 |"],
] as const) {
  test(`check rejects an item table header that is not at column 0: ${name}`, () => {
    const dir = fixtureDir();
    write(dir, "a.md", `${line}\n${line.replace(/[^|\s>-]+/g, "---")}\n`);
    const { status, stderr } = run(["check", "--", "a.md"], { cwd: dir });
    assert.equal(status, 1);
    assert.match(stderr, /a\.md:1: 項目の表は行頭から書く/);
  });
}

test("check rejects a fence that never closes", () => {
  const dir = fixtureDir();
  write(dir, "a.md", `intro\n\`\`\`\`\nx\n\`\`\`\n\n${BAD_ROW}`);
  const { status, stderr } = run(["check", "--", "a.md"], { cwd: dir });
  assert.equal(status, 1);
  assert.match(stderr, /a\.md:2: コードフェンスが閉じていない/);
});

test("a header quoted in prose or in a fence is not a violation", () => {
  const dir = fixtureDir();
  write(dir, "a.md", `ヘッダは \`| # | 状態 | 種別 | 依存 |\` で始める\n\n\`\`\`\n  | # | 状態 | 種別 | 依存 |\n\`\`\`\n`);
  assert.equal(run(["check", "--", "a.md"], { cwd: dir }).status, 0);
});

test("a separator row may use fewer than three hyphens", () => {
  const dir = fixtureDir();
  write(dir, "a.md", "| # | 状態 | 種別 | 依存 | 内容 |\n|-|-|-|-|-|\n| A1 | 未着手 | 実装 | — | x |\n");
  assert.equal(run(["check", "--", "a.md"], { cwd: dir }).stdout, "1 件の項目に違反なし\n");
  write(dir, "b.md", "a | b\n- | -\n1 | 2\n");
  assert.match(run(["check", "--", "b.md"], { cwd: dir }).stderr, /表の行頭の "\|" を省かない/);
});

test("the same file through a symlink and its real path is read once", () => {
  const dir = fixtureDir();
  const real = write(dir, "a.md", plan("| A1 | 未着手 | 実装 | — | x |"));
  symlinkSync(real, join(dir, "link.md"));
  for (const args of [["a.md", "link.md"], ["link.md", "a.md"], ["."]]) {
    const { status, stdout } = run(["check", "--", ...args], { cwd: dir });
    assert.equal(status, 0, args.join(" "));
    assert.equal(stdout, "1 件の項目に違反なし\n", args.join(" "));
  }
});

test("a dangling symlink in a directory is a usage error, not a stack trace", () => {
  const dir = fixtureDir();
  write(dir, "a.md", plan("| A1 | 未着手 | 実装 | — | x |"));
  symlinkSync(join(dir, "gone.md"), join(dir, "dangling.md"));
  const { status, stdout, stderr } = run(["check", "--", "."], { cwd: dir });
  assert.equal(status, 2);
  assert.equal(stdout, "");
  assert.match(stderr, /壊れた symlink.*: dangling\.md \(ENOENT\)/);
  assert.match(stderr, /使い方: node plans\.ts/);
  assert.doesNotMatch(stderr, /\n\s+at /);
});

test("a dangling symlink named directly is reported as missing", () => {
  const dir = fixtureDir();
  symlinkSync(join(dir, "gone.md"), join(dir, "dangling.md"));
  const { status, stderr } = run(["check", "--", "dangling.md"], { cwd: dir });
  assert.equal(status, 2);
  assert.match(stderr, /存在しないパス: dangling\.md/);
});

test("an unreadable file is a usage error, not a stack trace", { skip: process.getuid?.() === 0 }, () => {
  const dir = fixtureDir();
  const file = write(dir, "a.md", plan("| A1 | 未着手 | 実装 | — | x |"));
  chmodSync(file, 0o000);
  try {
    const { status, stdout, stderr } = run(["check", "--", "a.md"], { cwd: dir });
    assert.equal(status, 2);
    assert.equal(stdout, "");
    assert.match(stderr, /読めないファイル: a\.md \(EACCES\)/);
    assert.doesNotMatch(stderr, /\n\s+at /);
  } finally {
    chmodSync(file, 0o644);
  }
});
