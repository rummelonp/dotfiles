---
name: tidy-commits
description: Use when asked to tidy, squash, fold, split, reorder, amend, or rebuild the commits on a branch (コミット整理, 畳み直し, 畳み込み, まとめて, 分割し直し, 粒度を整える, fixup で直して, amend して), including amending commits that are already pushed, or when the user is in the middle of their own interactive rebase and asks you to check or adjust a commit. Covers where to draw commit boundaries, keeping unrelated changes out, and proving the final tree is unchanged.
---

# コミットの整理

作業ブランチの `<起点>..HEAD` にあるコミット列を組み直す。
`<起点>` は書き換えない最後のコミットのハッシュで、次のように決める。
- ユーザーか呼び出し元が範囲を示したら、その起点にする。
- 特定のコミットを直す（amend など）ときは、直すコミットのうち最も古いものの親にする。
- ブランチ全体を整理するときは、`git merge-base HEAD origin/<base>` にする。

`<起点>` にブランチ名を渡さない。`git rebase -i origin/<base>` は base の先端への追従を兼ねるうえ、`<起点>` より前のコミットも書き換えることがある。
base への追従（rebase や merge）と push は、この skill では行わない。
書き換えた履歴を後で push するときは、`--force-with-lease --force-if-includes` で force push する。

## 着手前の判定

1. 進行中の操作を確かめる。
   `git rev-parse --git-path rebase-merge` が指すディレクトリがあり、自分が始めた操作でなければ、ユーザーが `rebase -i` の途中にいる。
   - 止まっているコミットの評価と、そのコミットへの `commit --amend` だけを行う。
     amend は「直して」と頼まれたときだけ行い、評価を頼まれただけなら直し方の提案で止める。
   - `--continue`、`--skip`、`--abort` は実行しない。
2. push 済みのコミットを書き換えるのは、規則ファイル（`CLAUDE.md` / `AGENTS.md` / `GEMINI.md`）が許している場合か、force push が要ることを伝えてユーザーが承認した場合だけにする。
   書き換えないと決まったときに、依頼が整理そのもの（畳み込み、分割、並べ替えなど）なら、何もせずに報告する。
3. 範囲にマージコミットがあれば、組み直す前に方針を確認する。
   rebase はマージコミットを落とすので、マージで解消した競合や取り込んだ変更が失われることがある。
4. 未コミットの変更を仕分ける。
   依頼に含まれると判断できない変更（ユーザーや他のエージェントの編集など）は、コミットに入れない。

## 粒度の基準

- 1 コミットに 1 つの意図を入れ、レビュアーがコミット単位で読んで判断できるようにする。
- 依存の追加、生成物（lockfile、コード生成の出力）、整形や rename などの機械的な変更は、それぞれ単独のコミットにする。
  単独にしておけば、レビュアーはそのコミットを読まずに済ませられる。
- リファクタと振る舞いの変更は分ける。
- 各コミットの時点で整合させ、後のコミットで入るものを参照しない。
- バグ修正とそのテストの追加は、テストが修正前に失敗するなら同じ意図として 1 コミットに畳み、修正前から通るなら分けたままにする。
- 最終状態が最初から計画されていたかのようなコミット列にする。
  試行錯誤、レビュー指摘への対応、誤字の修正は、それを入れたコミットへ畳む。
  追加して直後に直すような、中間状態が不自然な連続コミットは 1 つにする。
- コミットメッセージは畳んだ後の内容に合わせて書き直し、言語と形式はリポジトリの規約と既存の履歴に従う。
- リポジトリの規約に粒度の定め（1 設定 1 コミットなど）があれば、そちらを優先する。
- 既に基準を満たしていれば何もせず、その旨を報告する。

## 手順

- **元の先端の固定**：書き換える前に `git tag tidy/<目的> HEAD` を打つ。
  backup にブランチは使わない（`rebase.updateRefs` が有効だと、ブランチも新しい先端へ動き、元の先端が残らない）。
- **既存コミットへの修正**：`git commit --fixup=<sha> -- <paths>` を対象ごとに作り、`GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash <起点>` で畳む。
  対象は `git log --oneline <起点>..HEAD -- <path>` や `git log -S '<直す箇所の文字列>'` で、直す行を入れたコミットを探す。
  メッセージを直すときは `git commit --allow-empty -m 'amend! <sha>' -m '<新しいメッセージ>'` を作り、同じ autosquash で畳む（`--fixup=reword:<sha>` は `-m` と併用できない）。
- **全面的な組み直し**：`git reset <起点>` で差分を作業ツリーに戻し、意図ごとに add と commit を繰り返す。
  commit の前に `git diff --cached` の本文を読み、そのコミットに入れる変更だけになっていることを確かめる。
- **並べ替え、drop**：todo を書き換えるスクリプトを `GIT_SEQUENCE_EDITOR` に渡す。
  `sed -i` は GNU と BSD で構文が違うので、`perl -i -pe` を使う。
- **共通の注意**：
  - `git add` はパスを明示し、`-a`、`-A`、`.` を使わない。commit の前に `git diff --cached --stat` を見る。
  - エディタが開く操作には `GIT_EDITOR=true` か `commit -F` を使う。
  - reset 先はハッシュで書く。`HEAD~N` は、別の操作で HEAD が動くと指す先が変わる。

## 検証

- `git diff tidy/<目的> HEAD` が空であることを確かめる。
  依頼に内容の変更（手直しの取り込みなど）が含まれるときは、差分がその変更だけであることを確かめる。
  説明できない差分が出たら、元の先端からやり直す。
- 各コミットがその時点で成り立つかを確かめる。
  - 短時間で終わる検査（`package.json` の scripts、`Makefile`、CI の設定から探す）があれば、`git rebase -x '<検査コマンド>' <起点>` で各コミットを検査する。
  - 検査を実行できなければ、各コミットの差分を読み、参照している名前やファイルがそのコミットまでに入っているかを確かめ、検査の代わりに差分を読んで確かめたと報告する。
- 検証が通ったら、`git rev-parse tidy/<目的>` で元の先端のハッシュを控えてから、タグを消す。報告の「元の先端のハッシュ」には控えた値を書く（タグを消すと、タグ名では引けなくなる）。

## 報告

- 新しいコミット列（ハッシュと件名）
- 元の先端のハッシュ
- ツリー差分の結果と、実行した検査
