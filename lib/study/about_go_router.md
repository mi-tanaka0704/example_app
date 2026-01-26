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
## MaterialApp.routerについて
```Dart
// todo
```