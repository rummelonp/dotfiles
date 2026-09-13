---
name: risk-based-review
description: Use when deciding whether a change needs independent review, and how to dispatch a review subagent with a git diff range, read-only constraints, and a structured output format.
---

# リスクに応じたレビュー依頼

サブエージェント（Task/Agent 相当のツール）を持たない環境ではこの skill は適用しない。

## レビューを依頼するかどうかの判定

毎タスク後に必ずレビューする、という前提は採らない。以下の 4 段階で決める。
複数の段階に当たるときは高い方を採る。着手前は分かっている範囲で分類し、調査の途中で
migration 等が判明したら分類を上げる。コードでない成果物（ノート、文章）も同じ軸で
分類する。

| リスク | 例 | 対応 |
|---|---|---|
| 軽微 | 文言、CSS、明白な小修正 | 自分で確認する。独立レビューは依頼しない |
| 通常 | 一般的な feature、refactor、test | 誤りが目視で分かりにくければ、同じモデルの独立レビュー 1 本 |
| 高リスク | DB schema、migration、認証と認可、データ整合性 | 上位モデルの独立レビュー 1 本 |
| 非常に高リスク | データ損失、race condition、security boundary、重大障害につながる変更 | 観点を分けた独立レビュー 2 本以上（1 本は上位モデル、残りは同じモデル） |

判定軸: 誤りが目視で分かるか、戻せるか（可逆性）、他の箇所に波及するか。

実装時のコンテキストを引き継ぐ自己レビューは常に行う。そのうえで、上記の表に従って
独立レビューの強度を変える。独立レビューは、その設計や実装に関わっていない新規の
サブエージェントに、新しいコンテキストで行わせる（自分で再読することを独立レビューの
代用にしない）。新規サブエージェントを起動できない環境では、独立レビューや bias-free
評価と称さず、代わりに構造的な自己審査に切り替える。

「簡単だから」を理由に軽微でない変更のレビューを省略しない。

## 依頼手順

1. **diff range を決める**:
```bash
BASE_SHA=$(git rev-parse HEAD~1)  # または比較したい起点
HEAD_SHA=$(git rev-parse HEAD)
```

2. **レビュアーをディスパッチする**: 新規サブエージェントに以下を渡す。
   - 何を作ったか（DESCRIPTION）
   - 期待する要件や元になった plan（PLAN_OR_REQUIREMENTS）
   - BASE_SHA / HEAD_SHA
   - レビュアーは read-only（コードを変更しない）
   - レビュアーは自分自身が更にサブエージェントを起動しない
   - 返却フォーマット: Strengths / Issues / Recommendations / Assessment

3. **結果に対応する**:
   - Critical/Important な指摘はすぐに直す
   - Minor な指摘は後回しでよいが記録する
   - レビュアーが誤っていると判断したら、根拠（コードやテスト結果）を示して押し返す

## Red Flags

- 「簡単だから」で軽微でない変更のレビューを省く
- Critical な指摘を無視する
- Important な指摘を未修正のまま進める
- 妥当な技術的指摘に理由なく反論する

## スコープの境界

この skill はレビュー依頼の手順であり、完了前の自己検証とは別物で 1 ファイルに
統合しない。完了前の自己検証は `completion-verification` skill（完了を宣言する直前に
検証コマンドを実行し直し、出力と終了コードを確認する自己チェックゲート）を使う。

## License

Adapted from [obra/superpowers](https://github.com/obra/superpowers)
`skills/requesting-code-review`, MIT License (see [LICENSE](LICENSE)).
