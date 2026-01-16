## コミットメッセージ チートシート

### 形式
`type(scope): subject`
- `scope` は任意（例: ui, router, api, deps）
- `subject` は短く「何をしたか」

### type一覧
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

