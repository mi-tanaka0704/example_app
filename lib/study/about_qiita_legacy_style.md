# Flutterクラス間の値の受け渡し

- Qiita記事が古い書き方だった
- リンク：https://qiita.com/koizumiim/items/31607725f75f4e68a706

## 正しい書き方

```Dart
class _MyPageState extends State<MyPage> {

//省略

//受け渡したい変数
final String watashitai;

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return Card(
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        
       // 渡したい変数を引数に指定する
       // ImageUrlクラスのコンストラクタ呼び出し(ImageUrlという型を使って新しいWidgetを作ってるという状態)
        ImageUrl(imageUrl: watashitai) //引数名: 値 の形なので 名前付き引数

      ]),
    );
  }
}

class ImageUrl extends StatelessWidget {

//　受け取る値を代入する変数を定義
  final String imageUrl;

// コンストラクタで、受け取る値を上記の変数に代入
// ImageUrl({this.imageUrl}); ←古い書き方
  const ImageUrl({super.key, required this.imageUrl});　

  @override
  Widget build(BuildContext context) {
    return Text(imageUrl); // 例
  }
}
```

## 正しい書き方のポイント
- required：必須引数にする（渡し忘れを防ぐ）
- const：可能ならconst化（軽くなる/最適化されやすい）
- super.key：Widget特有の慣習（本ページの中盤で詳しく）

## 古い理由
- 今のDart（null safetyが入った）では、以下のどちらかにするか決めないといけない
  - required（非null必須）にするか
  - this.imageUrlをnullable扱い（null OK）にする

```Dart
// 値を必須にするなら
const ImageUrl({super.key, required this.imageUrl});
```

```Dart
// nullでもOKなら
final String? imageUrl;
const ImageUrl({super.key, this.imageUrl});
```

## 説明も誤解を生みやすい
- 記事の説明
  - _MyPageStateクラスで定義されている変数watashitaiをImageUrlクラスでも使えるようにしている。
  - これでimageUrlの中に別クラスにあったwatashitai変数が代入されて、別クラス間での値の受け渡しができた。

- 再構成してみる
  - _MyPageState側で用意した、変数watashitaiを、ImageUrlのコンストラクタの「名前付き引数　imageUrl」に渡して「ImageUrl」を生成している。
  - その結果、ImageUrlインスタンス内のフィールドimageUrlに値が保持され、ImageUrlクラス内（build など）でその値を利用できる。
  
- ポイント
  - 「別クラスでも使えるようにした」のではない
  - 「生成時に値を渡して、受け取った側のインスタンスが保持している」

## 不明点まとめ
- _MyPageStateクラスでImageUrlというWidgetを作って（インスタンス化）しているけど、  
  単にImageUrl(引数); でのコンストラクタの呼び出しでは、どこのやつ（どこのImageUrl）か分からなくなるのでは？
  - Dartは同じファイル内（もしくは import 済み）なら、ImageUrlというクラス名を解決できる  
  だから「どこにあるかわからない」という問題は起きない。
  - ちなみにメソッドなら「どのインスタンスのメソッド？」って話になる

- ImageUrl(imageUrl: watashitai) にconst付与できない理由は？
  - 変数watashitaiがfinalだから。(実行時に値が決まる)

- 値がわからないのに、なぜ constコンストラクタを付けられるの？
  - const ImageUrl({super.key, required this.imageUrl});

- 結論：呼び出し側（ImageUrl(imageUrl: watashitai)）がconstで作れる（constで書ける）可能性を残すため
  - 意味は以下。
  - 「このコンストラクタは、引数がコンパイル時定数(引数がconst)ならコンパイル時にインスタンスを作れます（constインスタンス）」
  - 「もし引数が定数じゃないなら、普通に実行時に作ります（＝constとしては作れない）」
  - 注意点：constコンストラクタが付いていても「引数が定数」という意味にはならない

- constコンストラクタは付けっぱなしでOK？
  - 時と場合による
  - 自分が混乱しやすい/チームで誤解が出ているなら → 外す
  - StatelessWidgetは「中身が不変」になりやすいので、定数で組めるところは定数で組めるようにしておくと、使う側がconstを付けられる場面が増える
  - 結果として無駄な再生成を減らせたり、ツリーの差分が効きやすくなったりするというメリットがあるので、基本はつけておいていいかも（判断もしてくれるし）

- super.keyはwidgetクラスのコンストラクタにはつけるのが慣習？
  - だいたいの理解としてはOK
  - ここでの話はWidget（特にStatelessWidget / StatefulWidget）のコンストラクタに  
  「Key」を渡せるようにしておく慣習のこと

- keyとはなんだ？
  - 今回の例で言うなら、ImageUrlインスタンス自身につく「識別札」

- super.keyとはなんだ？
  - 「その札（key）を親クラス（= StatelessWidget / StatefulWidget）側の keyフィールドに渡して保持させる」という意味 
  - ここで言う親は、Widgetツリー上の親Widgetではなく、継承（extends）の親クラスのこと。
  - このkeyはFlutterがWidgetを識別して、ツリー更新時に「同じWidgetかどうか」を判断するために使うらしい

- 今回の例で言うとメリットは？　const ImageUrl({super.key, required this.imageUrl});
  - 使う側が ImageUrl(key: ...) を渡せる
    - → ImageUrlにKey（識別子）を付けて生成できるようになる。  
     受け取ったkeyはsuper.key経由でStatelessWidget（継承元）が持つkeyとして保持され、  
     Flutterがツリー更新時の照合に使える
  - リストやアニメーション、並び替えなどで挙動が安定しやすい
    - → ListViewの挿入・削除・並び替えやAnimatedList / AnimatedSwitcherなどで、  
    Flutterが 「前にあったどのWidgetが、次のフレームのどれに対応するか」を追跡しやすくなり、  
    意図しない状態の入れ替わりやアニメーションのズレが起きにくくなる 

- super.keyは必ずつけるべきなのか？
  - 付けるのが標準（特に公開Widget / 再利用Widget）
    - さっきまとめたようにメリットばかりなので
  - でも、超ローカルで使い捨ての小Widgetなら、付けなくても実害はほぼないことも多いらしい
  - とりあえず、つけておいた方がいいな
  
- どのWidgetにsuper.keyは渡すのか？判断基準的なのは？  
  これまではStatelessWidget / StatefulWidgetだったから他が気になった
  - 結論：どのwidgetでも渡せる。また渡す経路が違う。  
  つまり渡す渡さないとか言う話ではなかった。

- keyを渡し方について：Flutterの既存Widget（TextとかContainerとかの標準）の場合
  - 多くの標準Widgetはそもそもkey:を引数に持っている
  - 以下の通り、自分でsuper.keyを書かなくても「keyを渡せない」わけじゃなく、  
    それぞれのWidgetのコンストラクタに直接 key:を渡す形になる
  - 例：Text('hi', key: const ValueKey('t'));
    - Text ウィジェットの コンストラクタ呼び出し
    - 第1引数に 'hi'
    - 名前付き引数 key: に const ValueKey('t')を渡して、  
      Text のインスタンス（Widget）を生成。
    - ValueKey('t') は「このWidgetは“t”という値で識別してね」という識別子（Key）を作って渡しているイメージ。
  - 例：Container(key: const ValueKey('c'));

- keyの渡し方について：自作Widgetの場合
  - 自作Widgetのコンストラクタにkey:を受け取れる引数として用意する  
（例：{super.key, ...}）
  - こうしておくと、呼び出し側（そのWidgetを作る側）がImageUrl(key: ...)のようにkeyを渡せる
  - 受け取ったkeyはsuper.keyによって、  
  継承元の StatelessWidget（さらに Widget）が持つkeyとして保持される
  
```Dart
class ImageUrl extends StatelessWidget {
// keyを受け取れるようにする（受け口）
  const ImageUrl({super.key, required this.imageUrl});
  final String imageUrl;
}

// 呼び出し側（ImageUrl を作る側）がkeyを渡せる
ImageUrl(key: const ValueKey('x'), imageUrl: url); 
```

- keyの渡し方の整理 
  - 標準Widget：それぞれがkey:を受けるので、必要なら普通に渡す
  - 自作Widget：再利用するなら基本super.keyを付けておく（渡せるようにする）
  - 完全に使い捨ての小Widgetなら、付けなくても困らないことは多いらしい