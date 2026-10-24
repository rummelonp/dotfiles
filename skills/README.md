# skills

エージェント非依存のスキル。`install.sh` が 1 個ずつ symlink して
`~/.claude/skills/` と `~/.agents/skills/` に配る。
Antigravity には `gemini/skills/` に置いた相対 symlink で配るため、スキルを追加したらそこにも手で link を張る。

Claude ハーネス固有の語彙に依存するスキルは、代わりに
[`../claude/skills/`](../claude/skills/) に置いて `~/.claude/skills/` へだけ配る。

Codex 固有のツールやタスク管理に依存するスキルは、
[`../codex/skills/`](../codex/skills/) に置いて `~/.agents/skills/` へだけ配る。

Antigravity 固有のスキルは [`../gemini/skills/`](../gemini/skills/) に実ディレクトリで置く
（`gemini/` ごと `~/.gemini/config/` へ link されるため）。

同じ名前のスキルを 3 つのエージェント用に書き分けることもある。
`subagent-delegation` は役割の定義と選び方を 3 つで同じ文面にし、モデルの割り当てだけを書き分ける。
共有スキルはモデル名を持たず、`subagent-delegation` の役割名で参照する。

スキルを作る・直すときの方針は [`../docs/skills.md`](../docs/skills.md) にある。

## 出所

| スキル | 上流 | ライセンス | 取得日 |
| --- | --- | --- | --- |
| `grilling` | [mattpocock/skills](https://github.com/mattpocock/skills) `skills/productivity/grilling` | MIT（[LICENSE](grilling/LICENSE) 同梱） | 2026-10-16（上流 `95249b0`） |
| `japanese-tech-writing` | [k16shikano 氏の gist](https://gist.github.com/k16shikano/fd287c3133457c4fd8f5601d34aa817d) | Unlicense | 2026-10-23（リビジョン `8f2d576`） |
| `completion-verification` | [obra/superpowers](https://github.com/obra/superpowers) `skills/verification-before-completion` | MIT（[LICENSE](completion-verification/LICENSE) 同梱） | 2026-09-14 |
| `risk-based-review` | [obra/superpowers](https://github.com/obra/superpowers) `skills/requesting-code-review` | MIT（[LICENSE](risk-based-review/LICENSE) 同梱） | 2026-09-14 |
| `empirical-prompt-tuning` | [mizchi/skills](https://github.com/mizchi/skills) `empirical-prompt-tuning`（日本語の原本 `SKILL-ja.md`） | MIT 扱い（上流に個別 LICENSE はなく、上流の README に「明示ライセンスのないスキルは MIT 扱い」とある） | 2026-09-03 |
| `learn`（`../claude/skills/`） | [mizchi/skills](https://github.com/mizchi/skills) `retrospective-codify`（2026-09-16 までは `meta/` 配下） | MIT 扱い（同上） | 2026-09-14 |

### 改変

`grilling`
- 本文は無改変。末尾に License 節を追加。

`japanese-tech-writing`
- なし。

`completion-verification`
- Iron Law、ゲート手順、言い訳とその却下の表、Red Flags の構造を移植して日本語化。
- 判定を完了 / 要修正の 2 値にし、横展開チェック、完了の基準（コード変更、調査・監査、未知の技術）、スコープの境界を追加。
- Common Failures、Key Patterns（TDD の手順を含む）、When To Apply は削除。
- wshobson/agents `code-review-preshipment` の SHIP/SHIP WITH FIXES/DO NOT SHIP 方式は比較検討のうえ不採用（本文からの引用なし）。

`risk-based-review`
- 依頼手順（git SHA の取得コマンド含む）、返却フォーマット、Red Flags を移植して日本語化し、Red Flags には項目を追加。
- 返却フォーマットの指摘を blocking / non-blocking に分ける。
- `code-reviewer.md` は持ち込まず、その規則（read-only など）を依頼手順に取り込み。
- 要否の判定を 4 つのリスク分類に、レビュアーの選び方を `subagent-delegation` の役割に置き換え。
- 用語、観点 A / B への分割、観点別の自己点検、再レビューの節を新設。
- 上流の Example と Common Rationalizations は削除。
- レビュアーの選び方、観点 A / B の定義、依頼手順、観点別の自己点検、再レビューは `references/` に分割。
- 2026-10-16 に上流 `5bf4e78` の Declined to judge を依頼手順に追加。

`empirical-prompt-tuning`
- Claude / Codex / Gemini の各エージェントの起動ツールと取得可能メトリクス（Codex/Gemini では `tool_uses`/`duration_ms` が親に返らない等）の違いを吸収する「実行者の起動」節を新設して統合。
- 上流の構造審査モードを独立した評価モードにし、「静的審査」と改名。
- hold-out をベースライン準備で確定する形に変更。
- 失敗パターン台帳に Cause を追加。
- 収束条件をワークフローに統合。
- 上流の「よくある失敗」は Red flags に統合。
- 関連 skill を `learn` に付け替え。
- 起動契約・台帳のエントリ・提示フォーマットの書式とバリアント探索は `references/` に分割。

`learn`
- Workflow、提示フォーマット、Red Flags を移植。
- 3 分岐（ast-grep rule/CLAUDE.md rule/新規 skill）のうち ast-grep rule を削除し、残りをこのユーザーの自動メモリ 4 分類にマッピングし直し。
- 明示起動専用（`disable-model-invocation`）にし、書き込み前の確認を必須にする節を追加。
- 上流の具体例と提示例は削除。

## 上流の更新を取り込む

```sh
curl -sS https://raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/grilling/SKILL.md \
  | diff skills/grilling/SKILL.md -
```

`SKILL.md` の frontmatter の `description` はスキルの自動起動判定に使われるので、
差分がそこに及ぶ場合は挙動が変わる点に注意する。
