---
name: session-title
description: Name the current session following the user's convention. Invoke at the start of a session as instructed by CLAUDE.md, or whenever the user asks to name, rename, or retitle a session.
---

# セッション名

セッション名は `<絵文字> <本体>` の形式。
デスクトップアプリでは `set_session_title`、CLI では `/rename <name>` を使う。
`set_session_title` は `session_id` が必須で、自分の id は `get_session` に `"self"` を渡すと分かる（scratchpad のパスにある UUID は別物で、渡しても `not found` になる）。
どちらも無い環境ではこの skill を適用しない（代わりの命名や報告は不要）。

## 種別

プロジェクトの `CLAUDE.md` が独自の種別を定義していればそちらを優先し、無ければ以下を使う。

- **👑 統括**：長寿命で、判断と指揮だけを担い実装しない。起動時に領域名で付け、issue 番号は入れない。例 `👑 統括: 決済基盤`
- **#️⃣ issue 作業**：起票・調査・実装。issue 番号が決まった時点で付ける。例 `#️⃣ 1234: ログイン失敗時のエラー表示を直す`
- **🧩 単発**：issue に紐づかない調査・相談・実装。起動時の既定で、issue を作らないと決めた時点で確定する。例 `🧩 CI の実行時間を調べる`

## 本体

本体の概要は作業内容を 20 字前後で書く。
issue タイトルの写しでなくてよく、サイドバーで末尾が切れる長さにしない。

## 改名

issue 番号が決まった時点で 🧩 から #️⃣ へ改名する。
より適切な名前が分かった時点で改名してよく、回数の制限はない。
セッション名は SendMessage の宛先ではないので、改名しても他セッションからの連絡経路は壊れない。
状態は「（吸収済み）」「（破棄）」のように、アーカイブでは伝わらない終わり方だけを末尾の括弧に書く。
