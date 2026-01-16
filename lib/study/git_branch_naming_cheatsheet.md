# ブランチ名メモ（develop起点）

- 基本は `develop` から切る
- PRも基本は `develop` へ
- ブランチ名は「何やったか」が一瞬でわかればOK（短めで）

## 命名ルール
`type/topic`
- `type`：作業の種類（feature/fix/docs…）
- `topic`：何をやるか（短く、具体的に）

topic は `study-list` みたいにハイフン区切りが無難（統一しやすい）
※ snake_caseでもいいけど、どっちかに寄せる

## type
- `feature/` : 機能追加、学習実装（自分は学習もここに入れてる）
- `fix/` : バグ修正
- `docs/` : READMEとかメモだけ
- `refactor/` : 仕様変えずに整理
- `chore/` : 設定いじり、細かい片付け
- `test/` : テスト
- `spike/` or `experiment/` : 調査とか試し（捨ててもOKなやつ）

## 例:自分の用途だとこうなるだろう
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

## 後で自分が困るので、これは避けよう
- `feature/test`（何のテストか不明）
- `feature/study`（広すぎ）
- `feature/xxxx-20260114`（日付いれがちだけど、基本いらない）
- 日本語ブランチ名（環境で事故ることある）