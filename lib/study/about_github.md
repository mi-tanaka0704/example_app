# Git/GitHubについて(2025/1/12)

## git pullするタイミング
- 頻度1日に一回、確実にするタイミング
- PRを出す前
- コンフリクトで困らないようにこまめに行う

## rebaseとは
- 線がわかりやすくなる
- まだ理解できていないが以下が参考になりそう
  
参考：https://envader.plus/article/549

## ブランチを新しく切った場合でもコミットを分けることは可能か
- 答え：コミットを分けてpush可能。
- ステージングに上げるファイルをN個ずつ(分けること)にして、それぞれコミットすればいい

## ファイル編集をしてからブランチを切る場合

### Gitは未コミットの変更（作業中の変更）を持ったままブランチを切れる
- 先にちょっと直し始める（どのタスク名で切るか未定）→「これだな」と決まった時点でブランチを作る
- そのブランチに 今の変更がそのまま乗る

```
# すでに release/20260205 にいて、ファイルを編集してしまった後でも
git switch -c fix/route  # ←この時点の変更を持ったまま新ブランチ作成
```

### とりあえず進めていってあとからタスクの名前を決めることがある
- 例えば、fix/routeこうゆうのを切らずに、release/20260205（phase2ブランチ）←最新の開発環境で直せるかどうか調査や検証する
- ここで直せたら初めてブランチを切ってそのままPRだす
- でも、基本的には検証・調査だけにとどめておいた方がよさそう（途中で割り込みが多いと「変更がどのタスクのものか」混ざりやすくて事故りやすい）
- つまり「割り込み多い」「タスクが混ざりやすい」なら、ブランチは早めに切る方がいい（事故りにくい）
  
### ただし、defautのブランチでコミットpushは絶対にしないこと。
- 今回の例で言うと、release/20260205（phase2ブランチ）がdefaultのブランチ

## 他のタスクをお願いされた場合、別のブランチに切り替えて別の作業を行いたい場合
- 作業が中途半端だからコミットはしたくない時にgit stashで待避しておく
- ローカルだけの一時退避

```
# 変更の退避
git stash push -m "メッセージ（例：新機能の開発途中）"
```

- git stash使わずに、作業途中でコミット → pushがOKならやってしまう手もある
- 作業ブランチで行うこと
- この場合、コミット名は「wip（作業途中）」など作業途中とわかるようにする

https://envader.plus/article/344

## コンフリクト直す
```
fetch pull
rebase

# これはほぼ使わない
cherry pick
```

## コミットメッセージ チートシート

### 形式
`type(scope): subject`
- `scope` は任意（例: ui, router, api, deps）
- `subject` は短く「何をしたか」

### type一覧（よく使う）
- **feat**: 新機能
- **fix**: バグ修正
- **docs**: ドキュメントのみ
- **refactor**: 仕様変更なしの内部整理
- **perf**: パフォーマンス改善
- **test**: テスト追加/修正
- **style**: フォーマット/空白など（動作は不変、UI変更ではない）
- **chore**: 雑務（設定/生成物/小変更など）
- **build**: ビルド/依存関係（pubspec等）
- **ci**: CI設定（GitHub Actions等）
- **revert**: 取り消し

### 例
- `feat(ui): add settings screen`
- `fix(router): prevent crash on empty path`
- `docs: update Git workflow notes`
- `refactor(state): extract notifier`
- `build(deps): bump riverpod`

### 作業途中（許可されている場合）
- `wip: ...` / `wip(scope): ...`
  - 例: `wip(router): investigate redirect issue`
  - ※最終的にPRでsquash/rebaseして整える前提で使う

# ブランチ名メモ（develop起点）

- 基本は `develop` から切る
- PRも基本は `develop` へ
- ブランチ名は「何やったか」が一瞬でわかればOK（短めで）

## 命名ルール（これだけ守る）
`type/topic`
- `type`：作業の種類（feature/fix/docs…）
- `topic`：何をやるか（短く、具体的に）

topic は `study-list` みたいにハイフン区切りが無難（統一しやすい）
※ snake_caseでもいいけど、どっちかに寄せる

## type（よく使うやつだけ）
- `feature/` : 機能追加、学習実装（自分は学習もここに入れてる）
- `fix/` : バグ修正
- `docs/` : READMEとかメモだけ
- `refactor/` : 仕様変えずに整理
- `chore/` : 設定いじり、細かい片付け
- `test/` : テスト
- `spike/` or `experiment/` : 調査とか試し（捨ててもOKなやつ）

## 例（自分の用途だとこうなる）
### 文法の学習（List/Map/async）
- `feature/study-list`
- `feature/study-map`
- `feature/study-async-await`

### 学んだやつをカウンターアプリに組み込む
- `feature/list-add-to-counter`
- `feature/map-apply-to-ui`

### ドキュメントだけ
- `docs/git-workflow-notes`
- `docs/dart-list-cheatsheet`

### 小さい修正
- `fix/typo-readme`
- `fix/list-render-null`

## 後で自分が困るので、これは避けたい
- `feature/test`（何のテストか不明）
- `feature/study`（広すぎ）
- `feature/xxxx-20260114`（日付いれがちだけど、基本いらない）
- 日本語ブランチ名（環境で事故ることある）
