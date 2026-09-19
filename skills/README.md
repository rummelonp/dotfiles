# skills

エージェント非依存のスキル。`install.sh` が 1 個ずつ symlink して
`~/.claude/skills/`、`~/.agents/skills/`、`~/.gemini/config/skills/` の 3 箇所に配る。

Claude ハーネス固有の語彙に依存するスキルは、代わりに
[`../claude/skills/`](../claude/skills/) に置いて `~/.claude/skills/` へだけ配る。

Codex 固有のツールやタスク管理に依存するスキルは、
[`../codex/skills/`](../codex/skills/) に置いて `~/.agents/skills/` へだけ配る。

## 出所

| スキル | 上流 | ライセンス | 取得日 | 改変 |
| --- | --- | --- | --- | --- |
| `grilling` | [mattpocock/skills](https://github.com/mattpocock/skills) `skills/productivity/grilling` | MIT（[LICENSE](grilling/LICENSE) 同梱） | 2026-09-03 | なし |
| `japanese-tech-writing` | [k16shikano 氏の gist](https://gist.github.com/k16shikano/fd287c3133457c4fd8f5601d34aa817d) | Unlicense | 2026-09-03 | なし |
| `systematic-debugging` | [obra/superpowers](https://github.com/obra/superpowers) `skills/systematic-debugging` | MIT（[LICENSE](systematic-debugging/LICENSE) 同梱） | 2026-09-14 | `superpowers:test-driven-development`／`superpowers:verification-before-completion` へのプラグイン内参照を削除・付け替え、CLAUDE.md のバグ対応原則を追記。他は無改変 |
| `parallel-task-orchestration` | 自作（参考: wshobson/agents `agent-teams`、swarms `parallel-task`/`swarm-planner`） | - | 2026-09-14 | 上流の実装は使わず、着想（wave 実行、ファイル所有権チェック）のみを参考に文面は書き下ろし |
| `completion-verification` | [obra/superpowers](https://github.com/obra/superpowers) `skills/verification-before-completion` | MIT（[LICENSE](completion-verification/LICENSE) 同梱） | 2026-09-14 | Iron Law、ゲート手順、言い訳潰し表の構造を移植して日本語化、判定を完了/要修正の 2 値に変更し横展開チェックを追加、TDD 儀式は削除。wshobson/agents `code-review-preshipment` の SHIP/SHIP WITH FIXES/DO NOT SHIP 方式は比較検討のうえ不採用（本文からの引用なし） |
| `risk-based-review` | [obra/superpowers](https://github.com/obra/superpowers) `skills/requesting-code-review` | MIT（[LICENSE](risk-based-review/LICENSE) 同梱） | 2026-09-14 | ディスパッチ手順（git SHA の取得コマンド含む）、出力フォーマット、Red Flags を移植して日本語化、レビュー要否の判定ロジックを CLAUDE.md の 4 段階リスク分類に置き換え |

`../claude/skills/` に置いているものも同じ扱い:

| スキル | 上流 | ライセンス | 取得日 | 改変 |
| --- | --- | --- | --- | --- |
| `grill-me` | [mattpocock/skills](https://github.com/mattpocock/skills) `skills/productivity/grill-me` | MIT（[LICENSE](../claude/skills/grill-me/LICENSE) 同梱） | 2026-09-03 | なし |
| `empirical-prompt-tuning` | [mizchi/skills](https://github.com/mizchi/skills) `meta/empirical-prompt-tuning` | 上流に個別 LICENSE なし。README に「明示ライセンスのないスキルは MIT 扱い」の記述 | 2026-09-03 | なし |
| `lesson-persistence` | [mizchi/skills](https://github.com/mizchi/skills) `meta/retrospective-codify` | 上流に個別 LICENSE なし。README に「明示ライセンスのないスキルは MIT 扱い」の記述 | 2026-09-14 | Workflow、提示フォーマット、Red Flags を移植して日本語化。3 分岐（ast-grep rule/CLAUDE.md rule/新規 skill）のうち ast-grep rule を削除し、残りをこのユーザーの自動メモリ 4 分類にマッピングし直し |

`../codex/skills/` に置いているものも同じ扱い:

| スキル | 上流 | ライセンス | 取得日 | 改変 |
| --- | --- | --- | --- | --- |
| `empirical-prompt-tuning` | [mizchi/skills](https://github.com/mizchi/skills) `meta/empirical-prompt-tuning` | 上流に個別 LICENSE なし。README に「明示ライセンスのないスキルは MIT 扱い」の記述 | 2026-09-04 | `../claude/skills/` 版と同じ上流を基に、Codex のサブエージェントと取得可能なメトリクス（`tool_uses`/`duration_ms` 相当が取れない等）に合わせて改変 |

## 上流の更新を取り込む

```sh
curl -sS https://raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/grilling/SKILL.md \
  | diff skills/grilling/SKILL.md -
```

`SKILL.md` の frontmatter の `description` はスキルの自動起動判定に使われるので、
差分がそこに及ぶ場合は挙動が変わる点に注意する。
