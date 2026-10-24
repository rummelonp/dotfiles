# GitHub の issue をバックログにする

バックログの置き場所が GitHub の issue である repo で読む。
状態、種別、依存の語彙は `SKILL.md` と同じものを使う。

## 宣言に書くこと

範囲にする issue の条件（ラベル、マイルストーン、Project など）をユーザーに尋ねて書く。
あわせて次も書く。

- 種別（改善候補を含む）ごとに写すラベルか issue type
- 保留に写すラベル（使うなら）

## 引く

issue には表がないので、スクリプトを使わず、gh の出力を同じ語彙に写して判断する。
宣言で範囲にした issue を 1 つの計画として扱い、範囲の条件は `--label`、`--milestone`、`--search`（Project などほかの条件）で渡す。

```sh
gh issue list --state all --limit 200 \
  --json number,title,state,stateReason,assignees,labels,issueType,blockedBy,parent,subIssues,closedByPullRequestsReferences
```

表の列には、issue の次の値を写す。

- **ID**：`#<番号>`。
- **状態**：
  - closed で `stateReason` が completed なら完了、not planned なら取りやめ。
    判断の issue は、「やらない」と結論したときも completed で閉じる。
  - open で宣言した保留のラベルが付いていれば保留。
    保留のラベルを宣言していなければ、保留には写さない。
  - 保留でない open の issue は、担当者か紐づく PR があれば進行中、どちらでもなければ未着手。
- **依存**：`blockedBy`。
  取りやめに写した issue に open の issue が依存していれば、`check` の違反と同じくユーザーに知らせ、後ろの issue の扱いを `updating.md` の「後ろの項目の扱いを確かめる」と同じく確かめる。
  issue を書き換えるのは承認を得てから。
- **集約**：`subIssues` を持つ issue（状態は子から導く）。
- **種別**：repo が宣言したラベルか issue type との対応。宣言がなければ実装として扱わず、ユーザーに確かめる。

## 書き込む

- `updating.md` の「理由を残す」の内容は、`### <ID>` の節の代わりに issue のコメントに書く（書き込みは承認を得てから。得られなければ完了報告に書く）。
- follow-up を新しい項目として足すときに、改善候補に写すラベルを宣言していなければ、どのラベルにするかをユーザーに確かめて宣言に足す。
