# Flutter便利集

## Wrap with Widget（親を足す）
https://qiita.com/nakamura_slj/items/fcda79c723860ef01fc5 

- どういう時に使う？ 
  - ここだけpadding入れたいな〜とか
  - ちょっと余白足したい
  - タップできるようにしたい
  - 画面幅いっぱいにしたいって時
  - 要はレイアウト調整や装飾を足したいときに使う  
 （Padding / Center / Expanded / GestureDetector などを後付けしたい）

- 使うとどうなる？
  - 今あるWidgetを「包む（親を追加する）」だけ
  - 新しいクラスは作らない

### 例

```Dart
// 元（ここでWrap with Paddingする）
Text('Hello')
``` 

```Dart
// Wrap with Padding後

// 元のWidgetはそのまま  
// 外側に1枚（または複数）ラッパーを追加するだけ
Padding(
  padding: const EdgeInsets.all(8),
  child: Text('Hello'),
)
``` 

## Extract Widget（別Widgetに切り出す）
https://qiita.com/nakamura_slj/items/fe76141e96edee068319
https://zenn.dev/amuro/articles/7665fa263ed177

- どういう時に使う？
  - buildが長すぎて読みにくい（分割したい）
  - 同じUIを何回も使う（再利用）
  - 責務を分けたい（Widget単位で分割したい）

- 使うとどうなる？
  - 今あるWidgetツリーの一部を「別Widgetとして切り出して部品化」できる
  - 新しいクラスが作られる（StatelessWidget / StatefulWidget）

### 例

```Dart
// 元（ColumnでExtract Widgetを選択）＝切り出したいWidget全体を選択する

Column(
  children: [
    Text('Title'),
    Text('Body'),
  ],
)
```

```Dart
// Extract Widget後（クラス名入力で「_TitleBody」とする）

Column(
  children: [
    _TitleBody(),
  ],
)

// 下にクラス化して切り出してくれる
class _TitleBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Title'),
        Text('Body'),
      ],
    );
  }
}


```

## Extract Methodでメソッド化して切り出し
https://qiita.com/nakamura_slj/items/2cb1f4b9dcb62ea77c65 

- どういう時に使う？
  - とにかくbuildを短くして読みやすくしたい
  - その画面（そのState/Widget）内でしか使わない
  - 状態（フィールド）やcontextをそのまま使いたい

- 使うとどうなる？(buildが長いので一部を切り出した場合)
  - 同じクラス内にprivateなメソッドができる（_buildXxx みたいな）
  - 必要なら引数が増える（_buildItem(User user) みたいに）
  
- その画面（そのState/Widget）内でしか使わない　とは？
  - 他の画面でも同じUIを使い回す予定がないってこと
  - 例えば、 「プロフィール画面」にだけある注意文とか  
  → こういうのは、別画面で再利用しないなら わざわざ別クラス（Extract Widget）にするメリットがない
  - なので、同じクラス内に_buildHeader()みたいなメソッドとして整理（Extract Method）で充分という意味

- 「状態（フィールド）や contextをそのまま使いたい」 とは?
  - 切り出したい部分が、今のStateの中の変数や関数にベタ依存してるときの話
  
### 例A:Stateのフィールドを使用
- countもsetStateもそのまま参照できる
- 引数で渡す必要がない（=ラク）と言う意味

```Dart
// ColumnでExtract Methodする

class _PageState extends State<Page> {
// Stateのフィールド（フィールド＝クラス直下に定義している変数（プロパティ））
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count'),
        ElevatedButton(
          onPressed: () => setState(() => count++), //Stateのフィールドを使ってる
          child: const Text('plus'),
        ),
      ],
    );
  }
}

```Dart
// Extract Method後

class _PageState extends State<Page> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return _buildCounter();
  }

/*
    _buildCounter()は同じクラス内なので以下はそのまま使える（引数で渡す必要なし）
    ・countがそのまま使える（同じ_PageStateクラスのフィールドだから）
    ・setStateもそのまま使える（Stateのメソッドだから）
    ・つまり、引数を渡さなくて住むので手軽に整理できる
*/
  Widget _buildCounter() {
    return Column(
      children: [
        Text('$count'),
        ElevatedButton(
          onPressed: () => setState(() => count++),
          child: const Text('plus'),
        ),
      ],
    );
  }
}
```

### 例B：context が必要（Theme, Navigator, MediaQuery など）
- これも Extract Methodなら同じ build/contextの流れで扱いやすい

```Dart
Text(
  Theme.of(context).textTheme.titleLarge?.toString() ?? '',
)
```

### memo
- Extract Widget（別クラス）にすると色々と面倒かもしれない
 - 必要な値を引数で渡す
 - またはそのWidgetのbuild内で改めてTheme.of(context) 等を呼ぶ  
 - さらにonPressedの中身（setState等）をコールバックで渡すみたいな受け渡し設計が必要になる

### もっと詳しく知っておきたい、Extract Widget にすると何が「面倒」なのか

- 今回の例で言うと、_buildCounter を別クラス（Extract Widget） にするした瞬間に「見えなくなる」ものが出てくるから。
  - 例えば、以下のような受け渡しが必要になりやすい
  - countを引数で渡す
  - sonPressed（=setStateする処理）をコールバックで渡す

- つまり上記を使いたいなら、Extract Widget側に渡す必要がある
  - 渡すのは先ほどの例。引数で渡す（値）とかコールバックで渡す（操作）とか
  - これが難しい
  
- よくわからなくなってきたので、忘れないうちに簡単にまとめよう
  - Extract Method：同じクラス内にしまう → 今あるものをそのまま使えて楽だよ
  - Extract Widget：別クラスにする → 引数やコールバックで受け渡しが必要になりやすくて大変だよ

### ベタ依存とは？（密結合 / 依存が深い / 依存が強いとも言う）
- その場の変数・状態・仕組みに密着しすぎていて、切り離しにくい依存
  - そのWidget（または処理）が、親のStateにあるものを直接使いまくってる状態（countみたいな、フィールドを直参照）
- こうなると（ベタ依存）、別クラス（Extract Widget）に切り出した瞬間に「見えなくなる」
  - 別クラスに切り出す場合、引数やコールバックで渡す設計が必要になる。
  - これが「ベタ依存してると切り出しが重い」と言う意味

### 例

```Dart
// メソッド化したいWidget（今回はColumn）でExtract Methodを選択
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      Text('Title'),
      SizedBox(height: 8),
      Text('Body'),
    ],
  );
}
```

```Dart
// Extract Method後
@override
Widget build(BuildContext context) {
  return _buildTitleBody();
}

Widget _buildTitleBody() {
  return Column(
    children: [
      Text('Title'),
      SizedBox(height: 8),
      Text('Body'),
    ],
  );
}
```

## Extract WidgetとExtract Methodの違い
- Extract Widget：Widgetを別Widgetクラスに切り出す
  - 部品化・再利用向き

- Extract Method：Widgetツリーの一部をメソッド（関数）に切り出す   
  - buildの整理向き

- 判断基準（Extract WidgetとExtract Method）
  - まずは手軽にbuildを整理するExtract Methodでいいかも
  - このUIほかでも使うかも？部品化で独立したいならExtract Widgetにする  
  （またはExtract MethodにしたものをExtract Widgetにする。昇格的な？）

## 「シンボルの名前変更」で変数名を安全に変更
https://shiftb.dev/blog/fTjj8C3QTED2

- 変数 / 関数 / クラス名などを安全にリネームできる
