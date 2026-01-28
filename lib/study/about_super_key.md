# const MyApp({super.key});を説明する

```Dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

//　以下省略
```

## const MyApp({super.key});は実は省略形。
- Dart2.17以降はsuper.keyとして省略記法となっている
- なので、何しているかぱっと見わからない
- 省略なしは以下
  
```Dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

//　以下省略
```

## ①{Key? key}とは何か
- {}の意味　→ 名前付き引数を表している
- dartには引数の書き方が2種類ある

```Dart
// 位置引数
MyApp(key? key);

// 名前付き引数
MyApp({key? key});
```
### 違い
- 位置引数 → 順番固定
- 名前付き引数　→ 名前で渡す（順番不要）

### 名前付き引数とは

```Dart
// 受け取る側（定義）

class CardNamed {
  final String title;
  final String subtitle;
// ここで宣言されている名前はtitleとsubtitle。
  CardNamed({required this.title, required this.subtitle});
}

// 呼ぶ側（呼び出し）

//呼ぶ側は、受け取る側で決まっている名前（title/subtitle）を指定して渡しているだけ。
final n = CardNamed(title: text1, subtitle: text2);
```
  
## 位置引数とは

```Dart
// 受け取る側（定義）

class CardPos {
  final String title;
  final String subtitle;

  CardPos(this.title, this.subtitle); // 位置で受け取る
}
// 呼ぶ側（呼び出し）

final p = CardPos(text1, text2); // 順番で渡す
// CardPos(title: text1, subtitle: text2); // 位置引数だからNG
```

### 話を戻して、Key?の意味
```Dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

//　以下省略
```

- Key → 型
- ? → null OK

### {Key? key}のまとめ
- 構文：{null許容のKey型 名前付き引数の名前} 
  - keyという名前の変数を引数として受け取る
  - 型はKey（?なので、null可）
  - この引数は省略可能（渡さなければデフォルトでnull）

## ②super(key: key)とは何か

```Dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

//　以下省略
```

- superの意味 → 親クラスのコンストラクタを呼ぶ
- 子クラスのコンストラクタは、必ず親クラスのコンストラクトを呼ぶ
  
### key: keyとは
```Dart
super(key: key)
```
- 左のkey:  → 親クラスの名前付き変数
  - 親クラスのコンストラクタが定義している引数名
  - 親クラス：StatelessWidget({Key? key}); 
- 右のkey   → MyApp（コンストラクタ）が受け取った引数
  - 名前付き引数で受け取った値が入っている、普通の変数key 
  
## ③:コロンの意味
- 初期化リスト
- 意味 → インスタンスが作られる前に行う処理
- ルール → 親クラスのコンストラクタ呼び出しはこの場所でしか書けない

## ここまでのまとめ
- MyAppが受け取ったkey(Key?型の名前付き引数)を、初期化リスト内で、
- そのまま親クラス（StatelessWidget）のコンストラクタのkeyに渡している

## その他
- 値を渡す場合
```Dart
void main() {
  // runApp(const MyApp());
  runApp(const MyApp(key: ValueKey('app')));
}

class MyApp extends StatelessWidget {
// const MyApp({Key? key}); : super(key: key);
  const MyApp({super.key});
```

## 不明点
- 呼び出し側で、名前付き引数(key:)を書いてないのに受け取り側で名前付き引数になっている？
  - 名前付き引数は「必須でなければ」呼び出し側で省略OK
  - 今回はKey? key なので必須じゃない → runApp(const MyApp()); でOK。
  - const MyApp({required Key key}) : super(key: key);
  - 上記だったら、呼び出し側で必ず指定が必要（requiredあり）