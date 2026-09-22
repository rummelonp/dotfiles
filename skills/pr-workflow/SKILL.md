---
name: pr-workflow
description: Use when creating or updating a pull request, pushing fixes to a PR branch, or cleaning up after a PR is merged or abandoned. Covers the base-branch divergence check, draft-by-default creation, PR templates and body, when force push is allowed, and branch and worktree cleanup.
---

# PR の作成と更新

PR の作成と PR ブランチへの push は外部への書き込みなので、常駐の規則ファイル（`CLAUDE.md` / `AGENTS.md` / `GEMINI.md`）の規則どおり、ユーザーの指示か承認を得てから行う。
ブランチ名の付け方と push / fetch の実行方法も、同じ規則ファイルに従う。

## 作成・更新の前

1. `git fetch` し、`git merge-base HEAD origin/<base>` が `origin/<base>` の先端と異なれば取り込む。
   - PR が未作成か Draft なら rebase してよい（リポジトリに規約があればそれに従う）。
   - Ready の PR なら merge する（rebase は force push が必要になる）。
2. `git diff --stat origin/<base>...HEAD` を先に見てから差分を確認し、意図しないファイルが含まれていないことを確かめる。

## 作成

- 「Ready で」などの明示指示がない限り、Draft で作成する（`gh` なら `--draft`）。Ready への切り替えはユーザーの指示があるときだけ行う。
- PR テンプレート（`.github/pull_request_template.md` や `.github/PULL_REQUEST_TEMPLATE/` など）があれば、その構成を厳守する。
- 本文には目的と変更内容を書き、作業の経緯やコミット一覧を並べない。
- 作成したら、報告に PR の URL を含める。

## 更新

- Draft の間は amend / rebase して force push してよい（`--force-with-lease --force-if-includes` を使う。直前の `git fetch` でリモート追跡ブランチが更新されていると、`--force-with-lease` だけでは他人の push を上書きする）。
- Ready にした PR のブランチには force push しない。修正は新規コミットとして積み、amend や rebase はしない。

## 片付け

PR のマージ後、または作業を破棄したときは、不要になったものをその場で削除する。

- 作業に使った worktree があれば `git worktree remove` で外す。
- ローカルブランチを削除する。
