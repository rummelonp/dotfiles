# CLAUDE.md

個人用 dotfiles。`install.sh` が `$HOME` 配下へ symlink を張り、`uninstall.sh` が symlink だけを外す。

## 規約

- コード内のコメントと git コミットメッセージは**英語**で書く。日本語は散文ドキュメント（`skills/README.md`、`claude/CLAUDE.md`、各 `SKILL.md`）に限る。
- コミットメッセージは `<領域>: 簡潔な要約` の 1 行（例 `git: ignore claude plans`）。body は書かない。
- コメントはセクション見出し（`# homebrew`）に留め、意図が読み取れない箇所だけ英語 1 行で補う。

## 注意

- `claude/CLAUDE.md` と `claude/settings.json` は `~/.claude/` へ配られる**ユーザー設定**で、このリポジトリ自身の設定ではない。このリポジトリの設定はこのファイル。
