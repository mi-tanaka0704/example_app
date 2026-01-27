#  Flutterのパッケージ導入（go_router）
- https://zenn.dev/channel/articles/af4ffd813b1424
- https://pub.dev/packages/go_router/install

## go_routerとは
- 画面遷移パッケージ。
- go_routerの機能を一言で説明すると「パスと画面の組み合わせを決める」。
- Navigator → Navigator2.0になった。だがNavigation2.0は複雑で扱いにくい。それを使いやすくしたのがgo_router。

## 依存関係の追加
- やり方その①
  - pubspec.yamlにgo_routerを追加
  - その後、コンソールでflutter pub getする
```yaml
dependencies:
  go_router: ^17.0.1
```
- やり方その②
  - コンソールでflutter pub add go_routerを行う。

- どちらの方法でも、追加後に導入を確認すること

## ルーティング定義ファイルを作成（例：lib/router/app_router.dart）

- ルーティング設定の定義を行う。
- 今回はapp.router.dartとして以下に作成。
  - lib/presentation/app.router.dart
```Dart

final router = GoRouter(            // GoRouterのインスタンスrouterを作成
  debugLogDiagnostics: true,
  initialLocation: '/loginPage',    //initialLocationに初期表示ページ（/loginPage）を指定
  routes: [                         //routesにGoRouteを追加して画面を登録
    //後ほど実装予定
    // GoRoute(
    //   name: RouteNames.splashPage,
    //   path: '/splash',
    //   builder: (context, state) => const SplashPage(),
    //   ),
    GoRoute(
      name: RouteNames.loginPage,   // RouteNamesクラスの定数を使用
      path: '/loginPage',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: RouteNames.homePage,
      path: '/homePage',
      builder: (context, state) => const HomePage(),
    ),
  ],
);

 // RouteNamesで名前付きルートを一元管理
 // 名前付きルートを使うと、pathを直書きせずにRouteNamesで統一できるので、保守が楽でミスも減る。
class RouteNames {
  static const splashPage = 'splashPage';
  static const loginPage = 'loginPage';
  static const homePage = 'homePage';
}
```
## 設定の説明
- GoRouter: ルーティング設定のルートオブジェクト
- debugLogDiagnostics: true: デバッグログを有効化
- initialLocation: アプリ起動時の初期パス
- routes: ルート定義のリスト
- GoRoute: 個別のルート
- name: ルート名（RouteNamesで管理）
- path: URLパス
- builder: そのルートで表示するウィジェットを返す関数

## main.dartでMaterialApp.routerを使用し起動
```Dart
import 'package:flutter/material.dart';
import 'package:hikaku_app/presentation/app.router.dart';
import 'package:hikaku_app/presentation/page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
    // MaterialApp.routerにrouterを渡して有効化
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      title: 'hikaku_app',
      theme: ThemeData(useMaterial3: false),
      
    );
  }
}
```

## 画面遷移の呼び出し（login_page.dartでの例）
- context.goNamed(RouteNames.homePage) で名前付き遷移

```Dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hikaku_app/presentation/app.router.dart';
import 'package:hikaku_app/presentation/style/my_color.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: InkWell(
            child: Container(
              width: 80,
              height: 20,
              color: MyColor.purple1,
              child: Text('ホーム画面に遷移'),
            ),
            // loginPage内のタップでhomePageに遷移
            onTap: () => context.goNamed(RouteNames.homePage),
          ),
        ),
      ),
    );
  }
}
```

## 画面遷移のパターンは他にもたくさんある
- https://qiita.com/tks_00/items/927b69e302377c5184f4

## MaterialApp.routerについて
- main.dartでMaterialApp.routerを使用し起動しているが何をしているのか

## 一言で「FlutterのRouter APIに go_routerを接続する」 
- 3つを渡すことで、go_routerが **URL ↔ 画面** の同期と画面構成を担い、以下ができるようになる
  - 「ディープリンク対応」
  - 「WebでのURL表示」
  - 「戻る/進む」
  - 「状態に応じた遷移」

## 各プロパティの役割とできること
- routerDelegate（画面遷移の実行と画面表示を担当）
  - 何をする: 画面のスタック（表示中のページ群）を構築・更新する責務を持つ。
  - 結果: ルート遷移時に「どの画面を表示するか」をgo_routerがコントロールできる。

- routeInformationParser（URLとルート情報の変換を担当）
  - 何をする: URL（/loginPage など）をアプリ内のルート状態に変換する。
  - 結果: ブラウザURLやディープリンクから正しい画面に到達できる。

- routeInformationProvider（現在のルート情報の提供と監視を担当）
  - 何をする: 現在のルート情報をOS/ブラウザ側へ提供する。
  - 結果: 画面遷移に合わせてURLが更新される、戻る/進むボタンが機能する。

## Flutter3系では一行で済むと聞いた
- Flutter3系（かつ go_router の新しめの版）ならMaterialApp.router にrouterConfigを1行渡すだけで済む
- 今の書き方（3つ渡す）は、旧API互換の書き方

## 「旧API互換」とは？
- MaterialApp.routerが最初に導入された頃の書き方に合わせた互換スタイルという意味
- FlutterのRouter APIは最初、3つのオブジェクトを手動で渡す設計だった
  - その後、Flutter 3系でrouterConfigという「まとめて渡せる入口」のようなものが追加され、シンプルになった
  - go_routerはどちらの書き方でも動くようにしているため、旧スタイルでもOK＝「互換」扱いとなっている

```Dart
MaterialApp.router(
  routerConfig: router,
)
```

## 条件
- routerConfigが使えるかどうかはFlutter SDKとgo_routerの組み合わせ次第

## 確認方法
- Flutter3系かどうかはFlutter SDKのバージョンで判断する
  - flutter --version
  - 出力の先頭がFlutter 3.x.xならFlutter3系

## 注意
- pubspec.yamlのenvironment.sdkはDartのバージョンなので注意
  - Flutterのバージョンそのものではない
  - ただしDart 3.x使っているならFlutter 3.10+の可能性が高い
  - けど、最終判断はflutter --versionでやった方がいい

