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

## ターミナルでの作業内容

### 以下のコマンドを実施

git fetch  
git switch develop  
git pull  

適宜 Git Graphを参照する

# その他(プロジェクトの立ち上げ方)

## GitHubでの作業内容

### 「New」 を選択

<img width="952" height="354" alt="スクリーンショット 2025-12-31 11 35 39" src="https://github.com/user-attachments/assets/c95f3daf-3e64-4b0a-a79a-93c814f2d205" />

### 各種入力をし「Create repository」を選択

- 今回の入力
  - Repository name  
  - Description
  - Choose visibility  

<img width="929" height="848" alt="スクリーンショット 2025-12-31 11 42 25" src="https://github.com/user-attachments/assets/9a77c372-bb94-4468-be7c-edb7afa79f96" />

### 以下の画面に遷移するので閉じずにVSCodeでの作業を行う

<img width="927" height="868" alt="スクリーンショット 2025-12-31 11 44 16" src="https://github.com/user-attachments/assets/daedf890-3128-4700-82dc-e9a63c1dd622" />

## VSCordでの操作

### 新しいウィンドウ

<img width="208" height="464" alt="スクリーンショット 2025-12-31 11 46 37" src="https://github.com/user-attachments/assets/18b42e9e-ac1e-4bcf-9855-c7ef6b2304f7" />

### フォルダを開く

<img width="351" height="395" alt="スクリーンショット 2025-12-31 11 51 15" src="https://github.com/user-attachments/assets/9277ce4a-cf96-43b7-aa87-71171daa0944" />

<img width="877" height="445" alt="スクリーンショット 2025-12-31 11 51 43" src="https://github.com/user-attachments/assets/096f1c99-03b7-459c-bdfe-718fd6a8ecc3" />

### コマンド + Shift + P → Flutter New Project

<img width="622" height="365" alt="スクリーンショット 2025-12-31 11 53 21" src="https://github.com/user-attachments/assets/d03b8f3d-b74e-41f0-809b-ed4aa0705c8d" />

### Applications

<img width="696" height="267" alt="スクリーンショット 2025-12-31 11 54 42" src="https://github.com/user-attachments/assets/b42992d1-0a19-4181-85ac-e7e4885ed22a" />

### 作成したいフォルダを選択し 「Select a folder...」を選択

<img width="879" height="448" alt="スクリーンショット 2025-12-31 11 55 31" src="https://github.com/user-attachments/assets/6026a6a9-d5f1-4182-9fdc-ece0b6bc72d0" />

### プロジェクト名を入力
キャプチャは-を使用しているのでNGとなっている。  
_ならOK
<img width="615" height="98" alt="スクリーンショット 2025-12-31 11 56 41" src="https://github.com/user-attachments/assets/3cf43509-caba-4890-9ac0-fe71a12175d9" />

### 下からターミナルを出す

<img width="1197" height="794" alt="スクリーンショット 2025-12-31 12 00 41" src="https://github.com/user-attachments/assets/7aba6f37-4004-4c0f-bf5b-436da282db16" />

### 先ほどのGitHub上のコマンドをターミナル上で実行する

<img width="688" height="213" alt="スクリーンショット 2025-12-31 12 02 29" src="https://github.com/user-attachments/assets/ede7fff3-ef1f-4280-9c94-baa82805fef0" />

### ターミナルでの実行後

<img width="958" height="959" alt="スクリーンショット 2025-12-31 12 04 45" src="https://github.com/user-attachments/assets/bb4e7a25-7da8-4631-bdea-313fe6ddb85c" />

### ステージングにあげる（変更横+マークを押す）


### コミットする

flutter project first commit

<img width="347" height="527" alt="スクリーンショット 2025-12-31 12 09 27" src="https://github.com/user-attachments/assets/e4fb821a-4e45-432a-b613-a495ec99edf7" />

### developブランチを作成する

手順割愛  

最初は以下なので注意  

<img width="602" height="138" alt="スクリーンショット 2025-12-31 12 22 30" src="https://github.com/user-attachments/assets/5645f8a9-632e-4a31-a658-ceca77047e04" />

ステージングにあげてコミット  
<img width="957" height="956" alt="スクリーンショット 2025-12-31 12 25 22" src="https://github.com/user-attachments/assets/7fa3f310-9bbd-4b56-887b-441eaf4b7a3b" />



## GitHubでの作業内容

### Default branch を変更する

Settings→Default branch内の鉛筆の右隣を選択

<img width="937" height="562" alt="スクリーンショット 2025-12-31 12 26 20" src="https://github.com/user-attachments/assets/d0389cf7-5637-4816-8166-ad93e90b14b0" />

### developに選択してupdateを選択

<img width="482" height="177" alt="スクリーンショット 2025-12-31 12 26 45" src="https://github.com/user-attachments/assets/d4c39910-ed9f-4cb9-a969-be54f0192084" />

### i understand...を選択

<img width="447" height="193" alt="スクリーンショット 2025-12-31 12 27 17" src="https://github.com/user-attachments/assets/b6f90465-5dd2-47f6-a0d3-b3086acafc66" />

## projectの初期でdevelopとなる

<img width="948" height="662" alt="スクリーンショット 2025-12-31 12 28 25" src="https://github.com/user-attachments/assets/e15ebc93-efdc-468b-9f18-164f0cf2a14e" />

![Uploading スクリーンショット 2025-12-31 12.33.24.png…]()

