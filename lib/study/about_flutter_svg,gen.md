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
- 注意点としては、flutter_genはアセットの「参照（パスや型安全なアクセサ）」を生成するだけで、svgを表示する機能は持っていない（flutter_svgは必要）

## まずは導入しよう（https://pub.dev/packages/flutter_gen）
- 公式の「Installing」を選択
- dart pub global activate flutter_genをターミナルで実施→これではダメだった。
- flutter pub run build_runner build --delete-conflicting-outputs をターミナルで実施し以下を確認する
    - pubspec.yamlのdependencies・dev_dependenciesに追加されていること
    - lib/gen/assets.gen.dartファイルが自動生成されること。
- または、pubspec.yamlに以下を追加し、flutter pub getする

## pubspec.yaml
- https://zenn.dev/maropook/articles/ec52178cb7152a
- https://dev.classmethod.jp/articles/flutter-fluttergen-2025/
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_gen_runner: ^4.2.1
  build_runner: ^2.1.11
```
## lib/gen/assets.gen.dartファイル
```Dart
// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/lock_icon.svg
  String get lockIcon => 'assets/svg/lock_icon.svg';

  /// File path: assets/svg/mail_icon.svg
  String get mailIcon => 'assets/svg/mail_icon.svg';

  /// List of all assets
  List<String> get values => [lockIcon, mailIcon];
}

class Assets {
  const Assets._();

  static const $AssetsSvgGen svg = $AssetsSvgGen();
}
```
- Assets.svg
  - Assetsクラスのstatic constフィールド
  - 型は$AssetsSvgGen
- Assets.svg.mailIcon
  - mailIconはgetter（get）
  - getterの戻り値がStringと書いてあるので、Assets.svg.mailIconはString型（パス文字列）

## flutter_genの仕組み
前提：assetsを置く（assets/svg/mail_icon.svgみたいにファイルを配置する）
1. pubspec.yamlにassetsを書く
2. flutter_gen / build_runner を動かす → assetsを読み取る
3. lib/gen/assets.gen.dartみたいなファイルを自動生成（更新）する
4. アプリ側はその生成コードのAssets.svg.mailIconを参照できる

## 使い方
- Assets.svg.mailIconは「SVGを表示するWidget」ではなく、ただのパス文字列を返している。
```Dart
// lib/gen/assets.gen.dart
// 色々省略
String get mailIcon => 'assets/svg/mail_icon.svg';
```

```Dart
// なので表示するときは、flutter_svgのSvgPicture.asset()を使用する
SvgPicture.asset(Assets.svg.mailIcon);// Stringを渡してSVG表示
```

## png/jpgの場合
- png/jpg を置いて、flutter_genがAssetGenImage型として生成してくれたら.image()と.pathが使える
  - Assets.images.smilePicture.image(...) → Image（Widget）を返す
  - Assets.images.smilePicture.path → String（パス）を返す
- プロジェクト設定によっては、SVGもSvgGenImage型になって.svg()メソッドでWidgetを作れるらしい（未調査）
```Dart
// 例
AssetGenImage get smilePicture => const AssetGenImage('assets/images/a.png');
```

