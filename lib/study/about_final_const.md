# 文法（Dartのfinalとconstについて）

## まず前提の確認

### 時間の流れとして**処理の順番**を整理しておく
整理する理由は、  
finalとconstで値の確定タイミングが違うため。  
事前に把握しておくと整理しやすい。

1. ビルド工程（実行前）
   -   依存解決、コード生成（必要なら）、コンパイルなど
2. アプリ起動（実行開始）
3. ランタイム（実行中）
   - main()が動く
   - runApp(...)が動く
   - 画面が出る
   - 状態変化のたびにWidgetのbuild()が呼ばれる
4.  アプリ終了（実行終了）

- Widgetのbuild()とは？
     -  UIを作り直す処理。状態変化で何度も呼ばれる

## finalとconstの違い
どちらも「再代入できない（= 値を変えられない）」点は同じ。  
値が確定するタイミングが違う。

## **final**
-   変数宣言に使う
-   代入は1回だけ  
-   値は実行時（ランタイム）に確定する
    - もっと簡単に言うと、アプリが動いてから、その行が実行された時に確定する

```Dart
// xが決まるのは、そのコード（その行）が実行された瞬間（ランタイム）
final x = DateTime.now();   // 実行して初めて値が決まるのでOK
final y = 1;                // もちろんこれもOK

// これもOK
void main() {
  final a = [1, 2, 3];

  a[0] = 4;

  print(a);

}
```

### ランタイムとは？
アプリが実際に動いていて、コードが実行されている時間帯（実行時）のこと。  
先ほどの例だと、ランタイム中に、final x = ...; の行が実行され、右辺（...）が評価された瞬間にxの値が確定する。

## **const**
-   コンパイル時に値が確定できるものに使える。
-   コンパイル時定数と呼ばれる。
    -   アプリを実行しなくても（実行前に）値が決め打ちできるものだけ、constにできる
- finalよりより厳しい制約

```Dart
// constにできるもの
const a = 1 + 2;        // 実行せずに3と確定できる（ビルド中（実行前）の段階で３とアプリの中に埋め込める）
const b = "hello";      // 文字列リテラルは確定できる
const c = [1, 2, 3];    // 中身もすべてconstならOK

// constにできないもの(実行してみないと決まらない値はダメ)（ビルド中には絶対決められない）
const x = DateTime.now();
const y = Random().nextInt(10);

// numは変数の値のため、実行時（ランタイム）に値が決まるのでconstにできない
final num = 10; 
const z = [1, num, 3];  

// これもだめ（finalではOK）
void main() {

  const b = [1, 2, 3];

  b[0] = 4;

  print(b);
}
```

### constが言う「コンパイル時に確定」とは何？
アプリを実行する前のビルド工程内、**コンパイルの段階**でコードを実行せずに  
「この値はこれ！」と確定できる値という意味。
（＝実行しなくても決め打ちできる値）

### Dart/Flutterでいうコンパイル時っていつ？　
コンパイル時とは、アプリを実行する前の「ビルド工程内」で、  
Dartのコードを機械が実行できる形に変換しているタイミング

## Flutterの「ビルド」と「build()」は別物
Flutterには「ビルド」という言葉が2つの意味で存在しているが、別物なので注意。

- ビルド工程（コンパイル）
    -   アプリ実行前に行う作業（依存解決・生成・コンパイルなど）のこと
    -   const の「コンパイル時に確定」はこっちの話
- build
    -   Widgetのbuild()メソッドのこと
    -   アプリ実行中（ランタイム）に呼ばれる
    -   状態変化などで実行中に何度も呼ばれる
    -   つまり、build()「実行時」の話で、constの「ビルド（ビルド工程内のコンパイル）」とは別

## build()内のconstの確定タイミング
constの置き場所はあまり関係ない。  
constはそもそも実行のタイミングに依存しないため。  
（build()前のコンパイルで、実行せずに確定できるかだけなので）  
だから build()の中で何回呼ばれても固定される。

```Dart
@override
Widget build(BuildContext context) {
  return const Text('Hello'); // buildが何回呼ばれても固定
}
```
## build()の中のローカルfinalの確定タイミング
確定タイミングはbuild()が呼ばれるたびに毎回。  
イメージとしては、再描画のたびに変わる。  

### finalなのに毎回変わる？
finalは「その変数に再代入できない」だけ。  
毎回buildが呼ばれるなら、毎回新しいfinalが作られるのはいたって普通のこと。

```Dart
@override
Widget build(BuildContext context) {
  final x = DateTime.now();
  return Text('$x');
}
```

## てか、そもそもrunApp(const MyApp())ではなく、runApp(MyApp());でも動くのでは？
結論：動いた

対象のプロジェクト：  
flutter createした後のカウンターアプリ  

runApp(const MyApp())としなくてもいい。  
文法的にはconstは必須じゃない。

## では、constをつける意味は？

### まずはconst MyApp()の意味からおさえる
「コンパイル時に作れる定数インスタンスとして生成する」という指定。

### constをつける意味は、結論から言うと「無駄が減る」から
runApp(const MyApp());としておくと、定数なので固定パーツ扱いできる。  
これは、FlutterがWidgetを何度も作り直すので、処理の無駄を減らしたいから（build()が何度も呼ばれるから）    
Flutterがというより、モバイルアプリでは再描画が頻繁なのは「当たり前」という宿命に対応するため。  
つまり、constで作れるWidgetは、中身が変わらないのが保証されているということ。  
- 同じ内容なら同一インスタンス扱いになりやすい（それ前と同じ固定パーツだね！的な）
- ということは、Widgetツリーで「これは変わらない」となるので、無駄な作り直しが減る

要は、再描画する時に使い回せるから処理が軽くなって得をする。

```Dart
// constなし（毎回 新しい部品に見えやすい）
Widget build(BuildContext context) {
  return Text('Hello'); // 毎回newしてる扱いになりやすい
}

// constあり（固定部品として扱える）
Widget build(BuildContext context) {
  return const Text('Hello'); // 常に同じ固定部品なのですぐに使い回せる
}
```

## でも、ふと思った。runApp(const MyApp())は実行しないと分からないのに、なぜconstにできるの？

対象のプロジェクト：  
flutter createした後のカウンターアプリ  

##  まず問題点を切り分けよう
- runAppの結果（画面がどうなるか）は、確かに実行してみないと分からない
- constが保証しているのは、const MyApp()の部分

つまり、前者は関係ない。  
MyApp()がconstという話。  
ということは、MyApp()の中身が「アプリを実行しなくても（アプリ実行前に）値が決め打ちできるもの」であればいいということでは？

## MyApp()の中身を見ればわかるはず

```Dart
void main() {
  runApp(const MyApp());
}

// MyAppの中身はここ
class MyApp extends StatelessWidget {
  const MyApp({super.key});

/*
  これより以下は関係ない。
  理由：build()は、「実行中に呼ばれてWidgetを返す関数」なので、
  const MyApp()を作れるかどうかの判定そのもの（=コンストラクタがconstで成立するか）には直接関係しないから。
*/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
```

## 結論から言うと、
runApp(const MyApp())でconstにできる理由は、  
MyAppのコンストラクタ（const MyApp({super.key});）が **「constコンストラクタ」** で、  
かつ **「MyAppのフィールド初期化に実行時の値が入っていない」** から。  

ちょっと何言っているかわからない。

### const MyApp()が成立する条件をもう少し詳しく

```Dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});
}
```

- そのコンストラクタがconstである
- そのクラスのフィールド初期化やsuper呼び出しが、コンパイル時定数で表現できる範囲に収まっている

## つまりconst MyApp({super.key}); の{super.key}は全部コンパイル時に確定できるということ？

## {super.key} の意味

これは「MyAppのコンストラクタが受け取ったkeyを、親クラス（StatelessWidget）のkeyに渡す」という引数転送。  
もっと簡単に言うと、{super.key}→引数を親に渡してるだけ。

```Dart
const MyApp({super.key});
// 上記は概念的には以下に近い
const MyApp({Key? key}) : super(key: key);
```

## ということは、keyは「コンパイル時に確定」してるの？
常に確定しているわけではない。  

constにできる条件は「引数が常にコンパイル時定数」ではなく、  
constで呼ぶ場合は、その呼び出しに渡す引数がconstである必要があるということ。

runApp(const MyApp());
この場合、keyは渡してないので、key == nullになる。  
nullはコンパイル時定数なのでOKということ。

## 具体例で学ぶ

```Dart
// OK（const呼び出しでconstな値を渡している）
runApp(const MyApp(key: ValueKey('app'))); // 'app' はconst、ValueKeyもconstで作れる

// NG（const呼び出しなのに実行時の値を渡している）
final k = GlobalKey();           // GlobalKey()は実行時
runApp(const MyApp(key: k));     // const呼び出しにfinalを渡せない
```

つまり {super.key} 自体が「中身は常にコンパイル時に確定」って意味ではなくて、  
constとしてMyAppを作るなら、keyに渡す値もconstでなければいけない。  
（今回は省略＝nullでOK）という話だった。  

## その他

以下の場合は、NGとなる。  

```Dart
void main() {
  
  runApp(const MyApp());  // ここで怒られる
}

class MyApp extends StatelessWidget {
  MyApp({super.key});　// ← constが付いてない

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
```

### やっていることを整理する
まずrunApp(const MyApp())で「constコンストラクタ呼び出し」をしている。  
しかし、呼び出される方を見ると、MyApp({super.key}); となっている。  
constを付けて呼び出しているのに、呼び出される側（コンストラクタ）がconstではない。  
なので、runApp(const MyApp())という呼び出し自体が成立しない。  
コンパイル時定数として作れないのでエラーということ。  

## まとめ
runApp(const MyApp());と書いた時点で、constとして作れるコンストラクタが必要という制約が発生するため。  

もう少し丁寧に言うと、  
const MyApp()は「constコンストラクタ」を呼ぶ書き方。  
ところが、MyAppのコンストラクタにconstが付いていないため、const MyApp()が作れずエラーになる。