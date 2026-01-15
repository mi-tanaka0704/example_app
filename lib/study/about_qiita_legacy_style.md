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
- super.key：Widgetのお作法

## 古い理由
- 今のDartだと「this.imageUrl」はnullable扱いにするか、requiredにするかを決めないといけない

```Dart
// 必須にするなら
ImageUrl({required this.imageUrl});
```

```Dart
// nullでもいいなら
final String? imageUrl;
ImageUrl({this.imageUrl});
```

## 説明も誤解を生みやすい
- 記事の説明
  - _MyPageStateクラスで定義されている変数watashitaiをImageUrlクラスでも使えるようにしている。
  - これでimageUrlの中に別クラスにあったwatashitai変数が代入されて、別クラス間での値の受け渡しができた。

- 再構成してみる
  - _MyPageState側で用意した、watashitaiを、ImageUrlのコンストラクタの「名前付き引数　imageUrl」に渡して「ImageUrl」を生成している。
  - その結果、ImageUrlインスタンス内のフィールドimageUrlに値が保持され、ImageUrlクラス内（build など）でその値を利用できる。
  
- ポイント
  - 「別クラスでも使えるようにした」のではない
  - 「生成時に値を渡して、受け取った側のインスタンスが保持している」

## 不明点まとめ
- _MyPageStateクラスでImageUrlというWidgetを作って（インスタンス化）しているけど、単にImageUrl(引数);でのコンストラクタの呼び出しではどこのやつか分からな無くなるのでは？
  - Dartは同じファイル内（もしくは import 済み）なら、ImageUrlというクラス名を解決できる。だから「どこにあるかわからない」という問題は起きない
  - ちなみにメソッドなら「どのインスタンスのメソッド？」って話になる

- ImageUrl(imageUrl: watashitai) にconst付与できない理由は？
  - 変数watashitaiがfinalだから。(実行時に値が決まる)

- 「値がわからないのに、なぜ constコンストラクタを付けられるの？」
```Dart
const ImageUrl({super.key, required this.imageUrl});
```
  - 結論：呼び出し側（ImageUrl(imageUrl: watashitai)）がconstで作れる（constで書ける）可能性を残すため
    - 意味は以下。
    - 「このコンストラクタは、引数がコンパイル時定数ならコンパイル時にインスタンスを作れます（const）」
    - 「もし引数が定数じゃないなら、普通に実行時に作ります（＝constとしては作れない）」
    - constコンストラクタが付いていても「引数が定数」という意味にはならないので注意！

- constコンストラクタは付けっぱなしでOK？
  - 時と場合による
  - 自分が混乱しやすい/チームで誤解が出ているなら → 外す
  - StatelessWidgetは「中身が不変」になりやすいので、定数で組めるところは定数で組めるようにしておくと、使う側がconstを付けられる場面が増える
  - 結果として無駄な再生成を減らせたり、ツリーの差分が効きやすくなったりするというメリットがあるので、基本はつけておいていいかも

- super.key はwidgetクラスのコンストラクタにはつけるのが慣習？
  -  