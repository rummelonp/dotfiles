# skills

エージェント非依存のスキル。`install.sh` が 1 個ずつ symlink して
`~/.claude/skills/` と `~/.codex/skills/` の両方に配る。

Claude ハーネス固有の語彙に依存するスキルは、代わりに
[`../claude/skills/`](../claude/skills/) に置いて `~/.claude/skills/` へだけ配る。

Codex 固有のツールやタスク管理に依存するスキルは、
[`../codex/skills/`](../codex/skills/) に置いて `~/.agents/skills/` へだけ配る。

## 出所

| スキル | 上流 | ライセンス | 取得日 | 改変 |
| --- | --- | --- | --- | --- |
| `grilling` | [mattpocock/skills](https://github.com/mattpocock/skills) `skills/productivity/grilling` | MIT（[LICENSE](grilling/LICENSE) 同梱） | 2026-09-03 | なし |
| `japanese-tech-writing` | [k16shikano 氏の gist](https://gist.github.com/k16shikano/fd287c3133457c4fd8f5601d34aa817d) | Unlicense | 2026-09-03 | なし |

`../claude/skills/` に置いているものも同じ扱い:

| スキル | 上流 | ライセンス | 取得日 | 改変 |
| --- | --- | --- | --- | --- |
| `grill-me` | [mattpocock/skills](https://github.com/mattpocock/skills) `skills/productivity/grill-me` | MIT（[LICENSE](../claude/skills/grill-me/LICENSE) 同梱） | 2026-09-03 | なし |
| `empirical-prompt-tuning` | [mizchi/skills](https://github.com/mizchi/skills) `meta/empirical-prompt-tuning` | 上流に個別 LICENSE なし。README に「明示ライセンスのないスキルは MIT 扱い」の記述 | 2026-09-03 | なし |

`../codex/skills/` の `empirical-prompt-tuning` は同じ上流を基に、Codex のサブエージェントと取得可能なメトリクスに合わせて改変している。

## 上流の更新を取り込む

```sh
curl -sS https://raw.githubusercontent.com/mattpocock/skills/main/skills/productivity/grilling/SKILL.md \
  | diff skills/grilling/SKILL.md -
```

`SKILL.md` の frontmatter の `description` はスキルの自動起動判定に使われるので、
差分がそこに及ぶ場合は挙動が変わる点に注意する。
