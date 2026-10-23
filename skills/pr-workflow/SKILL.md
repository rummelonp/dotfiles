---
name: pr-workflow
description: Use when creating or updating a pull request (including pushing fixes to its branch), or cleaning up after a PR is merged or abandoned. Covers deciding the base branch, the base-branch divergence check, draft-by-default creation, PR templates and body, and branch and worktree cleanup.
---

# PR の作成と更新

PR の作成・更新と PR ブランチへの push は外部への書き込みなので、ユーザーの指示か承認を得てから行う。
push 済みのコミットを書き換えるのは、規則ファイル（`CLAUDE.md` / `AGENTS.md` / `GEMINI.md`）が許している場合か、force push が要ることを伝えてユーザーが承認した場合だけにする。
force push は `--force-with-lease --force-if-includes` で行う。

## 作成・更新の前

1. `git fetch` してから、base（PR の取り込み先ブランチ）を決める。
   既定ブランチと決めつけず、次の順で最初に決まったものを使う。
   1. ユーザーや呼び出し元の skill が指定したブランチ。
   2. このブランチの開いた PR の base。
      `gh pr view --json state,baseRefName,isDraft --jq 'select(.state == "OPEN") | {baseRefName, isDraft}'` で引く。
      出力が空か `no pull requests found` のエラーなら次へ進み、ほかのエラー（認証やネットワークなど）なら base を決めずに報告する。
   3. repo の規約（`CLAUDE.md`、`AGENTS.md`、`CONTRIBUTING.md` など）が定めるブランチ。
   4. 既定ブランチ（`gh repo view --json defaultBranchRef --jq .defaultBranchRef.name`）。
2. `git merge-base HEAD origin/<base>` が `origin/<base>` の先端と異なれば取り込む。
   - 書き換えてよければ rebase し（リポジトリに規約があればそれに従う）、書き換えない場合は merge する（rebase は force push が必要になる）。
   - 競合は両側の意図が読み取れる場合だけ解消する。読み取れなければ中断（`--abort`）して報告する。
   - 取り込んだら、テストなどの検証をやり直す。
3. `git diff --stat origin/<base>...HEAD` を先に見てから差分を確認し、意図しないファイルが含まれていないことを確かめる。

## 作成

- 「作成・更新の前」の 1 で決めた base を明示して作成する（`gh` なら `--base <base>`。省略すると既定ブランチ向けになりうるため）。
- 「Ready で」などの明示指示がない限り、Draft で作成する（`gh` なら `--draft`）。Ready への切り替えはユーザーの指示があるときだけ行う。
- PR テンプレート（`.github/pull_request_template.md` や `.github/PULL_REQUEST_TEMPLATE/` など）があれば、その構成を厳守する。
- 本文には目的と変更内容を書き、作業の経緯やコミット一覧を並べない。
- 作成したら、報告に PR の URL を含める。

## 更新

- push 済みのコミットを書き換えない場合は、修正を新規コミットとして積み、force push しない。

## 片付け

PR のマージ後、または作業を破棄したときは、不要になったものをその場で削除する。

- 作業に使った worktree があれば `git worktree remove` で外す。
- ローカルブランチを削除する。
