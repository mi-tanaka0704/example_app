# Flutterのパッケージ導入（flutter_svg,flutter_gen）

## 導入背景
- これまで、以下のようなアイコン（メールやキーなど）を表示させるために、Flutter標準のアイコンであるIconData型のものを使用していた
- しかし、実務ではデザイナーが用意したsvgを使用するのが一般的とのこと
- 事前準備として、Fluter側で使用するsvgと必要となるパッケージを導入することになった
  
  ![alt text](<スクリーンショット 2026-01-22 22.56.38.png>)

## svgの準備
- svgを使用する前にデザインツール（今回はFigma）からsvgを取得する

1. Figmaでコマンド + 右クリックでアイコンを選択。
   
    ![alt text](<スクリーンショット 2026-01-22 23.06.45.png>)


2. 右下のエクスポート欄から「svg」を選択し、「vectorをエクスポート」を選択

    ![alt text](<スクリーンショット 2026-01-22 23.08.05.png>)

3. 保存する
   
    ![alt text](<スクリーンショット 2026-01-22 23.10.41.png>)

## svgをプロジェクト直下に配置する
- 以下キャプチャのようにassets配下にsvgを配置する
- pngとsvgは分けると管理や利便性が上がる
  - pngは画像
  - svgはアイコン 

    ![alt text](<スクリーンショット 2026-01-22 23.14.15.png>)

## Flutter_svgのパッケージを導入する
- 何のパッケージ？公式によると以下の記載（https://pub.dev/packages/flutter_svg）
  - アセット（assets）に置いたsvgを読み込む
  - それを画面に描画できるWidget（SVGレンダリングWidget）として表示する

## 導入手順
- 公式の「Installing」を選択
- flutter pub add flutter_svgをターミナルで実施（暗黙でflutter pub getが走っている）
    - 実行後、pubspec.yamlのdependenciesに追加されていることを確認。
- または、pubspec.yamlに以下を追加し、flutter pub getする

```yaml
dependencies:
  flutter_svg: ^2.2.3

# ここは手動で追加した気がする
flutter:
  assets:
    - assets/svg/
```

## 問題点
- これでsvgは使えるようにはなったが問題点がある
  - 文字列パス（'assets/.../foo.svg'）を手で書く必要がある（Stringなのでラーとならない）= ハードコーディング
  - パスの打ち間違い・存在しないファイル参照になる可能性あり

```Dart
// インポートする
import 'package:flutter_svg/flutter_svg.dart';

// https://zenn.dev/joo_hashi/articles/c6940c20ce06f7の完成品欄

// 省略
// SvgPicture.asset()で、assets内のSVGを表示
      body: Center(
        child: SvgPicture.asset(
          'assets/onion.svg',
        ),
```

## ここでflutter_genのパッケージが活躍する
- flutter_genがpubspec.yamlに書いたassetsを元に、Assets.svg.xxxみたいな型安全な参照コード（AssetsというDartコード）を自動生成してくれる
- これで、flutter_svgの問題点は解決する（補完できるし）
- 注意点としては、flutter_genはアセットの「参照（パスや型安全なアクセサ）」を生成するだけで、svgを表示する機能は持っていない

## まずは導入しよう（https://pub.dev/packages/flutter_gen）
- 公式の「Installing」を選択
- dart pub global activate flutter_genをターミナルで実施
    - 実行後、pubspec.yamlのdependenciesに追加されていることを確認。
- または、pubspec.yamlに以下を追加し、flutter pub getする

## flutter_genの仕組み
1. pubspec.yamlにassetsを書く
flutter_gen_runner（build_runner）が assets を読み取る

lib/gen/assets.gen.dart みたいなファイルを 自動生成する

アプリ側はその生成コードの Assets.svg.mailIcon を参照できる