# リモートの上げ方

## ローカルの作業内容

### まずブランチを切る

今回は「feature/study_int」を選択

<img width="352" height="38" alt="スクリーンショット 2025-12-29 15 30 10" src="https://github.com/user-attachments/assets/9cd487c3-a37f-40fc-95a2-a7c01155512b" />

### 「新しいブランチを以下から作成」を選択

<img width="602" height="376" alt="スクリーンショット 2025-12-29 15 32 42" src="https://github.com/user-attachments/assets/27c3b0de-92b4-4242-9d5b-799773ec8fdf" />

### 「origin/develop」を選択(誤ってdevelopを選択しないように）

<img width="604" height="331" alt="スクリーンショット 2025-12-29 15 33 22" src="https://github.com/user-attachments/assets/ee698e57-87d0-411f-9696-321497e66db8" />

⚠️ここでファイルが消されるようなことが発生した場合は以下を行う
git fetch
git pull

### feature/ブランチ名を入力

<img width="599" height="87" alt="スクリーンショット 2025-12-29 15 35 50" src="https://github.com/user-attachments/assets/7c96f6af-2021-4c39-bef5-f491534fdc96" />

### ステージングにあげる（変更横+マークを押す）

⚠️各ファイルの保存を忘れないこと

<img width="412" height="211" alt="スクリーンショット 2025-12-29 15 41 43" src="https://github.com/user-attachments/assets/51ab494f-4426-4539-8afc-e727d31b447f" />

### コミットメッセージを入力し、コミットボタンを押す

<img width="393" height="313" alt="スクリーンショット 2025-12-29 15 43 15" src="https://github.com/user-attachments/assets/f21cc877-1178-4d38-9e15-28d8148d72e8" />

## リモートの作業内容

### ブランチの発行を押す

<img width="390" height="146" alt="スクリーンショット 2025-12-29 15 44 28" src="https://github.com/user-attachments/assets/7cec2c8c-7a1d-4483-a2b7-8b7527645033" />

# プルリクエスト〜マージ

## GitHubでの作業内容（キャプチャは例）

### 緑の「Compare & pull request」を選択

<img width="929" height="754" alt="スクリーンショット 2025-12-30 23 33 43" src="https://github.com/user-attachments/assets/51e104ab-7ab3-4824-bbb0-d95033bfca72" />

### 「Add a description」を入力し、「Assignees」を選択　→　「Create pull request」を選択

<img width="943" height="846" alt="スクリーンショット 2025-12-30 23 41 03" src="https://github.com/user-attachments/assets/9af3a475-5cf9-4ed2-bf13-14cf859c8aa2" />

### 「Marge pull request」を選択

<img width="940" height="821" alt="スクリーンショット 2025-12-30 23 43 50" src="https://github.com/user-attachments/assets/b061b517-5cb0-4475-b7cb-ee4b54422cd5" />

### 「Confirm merge」を選択

<img width="599" height="430" alt="スクリーンショット 2025-12-30 23 46 10" src="https://github.com/user-attachments/assets/5c8cf63e-cac5-4947-86f6-da0c216aea7e" />

### 「Merged」になる

<img width="933" height="515" alt="スクリーンショット 2025-12-30 23 48 20" src="https://github.com/user-attachments/assets/78472541-2eae-45d0-be6f-a6d300803d54" />

# リモートとローカルで差分を解消しておく

## ターミナルで以下のコマンドを実施

git fetch
git pull




