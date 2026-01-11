# 文法（List）

## List

### ① 書き方は人によって違うことがある

```Dart
// 6パターンどれも同じ

// 両辺でconstを指定
const list = const [1, 2, 3];

// 両辺でconstを指定
const List<int> list = const [1, 2, 3];　//こっちは要素の型を左辺で明示

// 両辺でconstを指定
const list = const <int>[1, 2, 3];　//こっちは要素の型を右辺で明示

// Dartにはconstの暗黙付与があるので右辺もconstになる（一般的な書き方）
const list = [1, 2, 3];

// constの暗黙付与（一般的な書き方）
const List<int> list = [1, 2, 3];　//こっちは要素の型を左辺で明示

// constの暗黙付与（一般的な書き方）
const list = <int>[1, 2, 3]; //こっちは要素の型を右辺で明示
```
---

### ② finalとconstのListについて

#### Point
- finalは、変数への再代入を不可とするだけ(変数の参照を固定するだけ)
- つまり、Listが可変長（add/removedで中身の変更ができる）かどうかはfinalでは決まらない
- つまり、finalにListの中身の変更可否の決定権はないので、右辺次第になる
- 右辺がconstならListは中身の変更は不可となる

#### final list = [..]; → 再代入× / 中身変更○

```Dart
// finalのリストは中身は変更できる（再代入だけ不可）
final list = [1,2,3];

// OK（右辺のリストは通常の可変Listなので中身は変更できる）
list.add(4);
 
// NG（再代入は不可）
list = [9,9];
```

#### final list = const [..]; → 再代入× / 中身変更×

```Dart
// finalのListでも、右辺がconstなら変更不可
final list = const [1, 2, 3];

// NG（const Listなので変更不可）
list.add(4);
```

#### const list = [..]; → 再代入× / 中身変更×

```Dart
// constのリストは中身も変えられない
const list = [1,2,3];

// NG
list.add(4);   

// NG
list[0] = 9;
```
---

### ③ふと思った、以下２つはやっていることは同じでは？　
#### どこかの場面で使い分ける時とかあるの？
-   A：　const list = [..]; → 再代入× / 中身変更×
-   B：　final list = const [..]; → 再代入× / 中身変更×

#### 違いとしては以下くらい
-   コンパイル時（ビルド）にlistが決まればいいか  
-   実行時にlistが決まればいいか

#### 仮説
-   完全に値が決まっている時はAでいい
-   実行時に値が決められれない値の時にBが必要では？
Bはインスタンス化する時のフィールドで使うくらいしか思いつかない。  
インスタンス化は実行時に値が決まるので、左辺にconstの付与はできないが、右辺がconstのリストの中身は変更不可（不変）にできる。

#### 先に結論
- A：const list = [..]; は「その変数自体も定数として置ける場所」のとき
  - 例：ファイル直下（トップレベル）、static const、const コンストラクタ内で使う定数など
  - → 「これは定数です」を明確にしたい・定数置き場に置く用途。

- B：final list = const [..]; は「変数はconstにできない場所だけど、中身は不変にしたい」とき
  - 例：クラスのインスタンスフィールド（StatelessWidget/Stateのフィールドなど）、関数内のローカル変数でconstにする必然がない・できない文脈
  - → 参照は固定しつつ、リスト自体も絶対に変更されないようにしたい用途。

---

#### Aの例を具体的に確認する（const list = [..]; → 再代入× / 中身変更×）

#### **Aでいい例　1. トップレベル定数（ファイル直下）**
```Dart
// constants.dart みたいなファイルに置く
const List<String> prefectures = ['Tokyo', 'Kanagawa', 'Chiba']; // 都道府県

void main() {
  print(prefectures[0]); // Tokyo
}
```
- 用途イメージ（アプリ全体で使い回す固定データに向いている）
  -   ドロップダウンの候補
  -   画面のタブ名一覧
  -   固定のラベル一覧

---

#### **Aでいい例　2. static const（クラスに紐づけて名前空間として持たせる）**
```Dart
class AppLabels {
  static const List<String> tabs = ['Home', 'Search', 'Settings'];
  static const List<int> retryIntervalsSec = [1, 2, 5, 10]; // 再試行間隔秒
}

void main() {
  print(AppLabels.tabs); // [Home, Search, Settings]
}
```
-   用途イメージ
    -   「定数をまとめる場所」を作りたい（散らばらない）
    -   AppLabels.tabs みたいに意味を付けて呼びたい

---
#### 補足

#### 「static const」の役割とは
-   const：コンパイル時定数、値そのものは不変
-   static：インスタンスを作らなくてもAppLabels.tabsでアクセスできる（AppLabels()が不要）
-   このstaticによって、「クラス（AppLabels）を入れ物（箱）として使える」ようになる

#### ここでいう名前空間とは？なぜ名前空間にclassを使うのか
-   Dartはnamespace（名前空間）が弱いから、class + static const を名前空間っぽく使うことがある
- もしくはファイルを分けてimportで名前空間にするみたいな設計をする

#### 例えば・・・

```Dart
const tabs = ['Home', 'Search', 'Settings'];
const tabs = ['A', 'B', 'C']; // 別ファイルとかで同名が出ると混乱しがち
```

例えば、tabsという名前の定数がプロジェクト内に散らばってたら、どのtabs？ってなりやすい。  
importの都合で衝突することもある。  
そこで、箱に入れて呼ぶと（AppLabels.tabs）意味がはっきりする。  
このAppLabelsが「名前の前につく接頭辞」になっていて、  
tabsという一般的な名前でも「AppLabels」の「tabs」と区別できる。  
これがここで言う「名前空間」のような使い方。  
AppLabelsは、関連定数をまとめる置き場、呼び出すときの接頭辞として動かすことができる。

#### もっと具体的な例が欲しい・・・

```Dart
// retryIntervalsSec = 再試行間隔秒

class NetworkConstants {
  static const retryIntervalsSec = [1, 2, 5, 10];
}　

class UiConstants {
  static const retryIntervalsSec = [1, 1, 1]; // UI用（仮）
}
```

同じ「retryIntervalsSec」でも、目的ごとに分けたいとき、
以下であれば呼ぶ側で一発で意味が分かる。
- NetworkConstants.retryIntervalsSec
- UiConstants.retryIntervalsSec

「どっちのretryIntervalsSec？」  
のような問題をNetworkConstants / UiConstantsで解決できる。  
これが名前空間的なメリット。

#### importの都合で衝突するとは何か

```Dart
// app_labels.dart
const tabs = ['Home', 'Search', 'Settings'];

// admin_labels.dart
const tabs = ['Users', 'Roles', 'Logs'];

// main.dart
import 'app_labels.dart';
import 'admin_labels.dart';

void main() {
  print(tabs);
}
```
この時、tabsはどっちのtabs？となって、Dartはエラーとする（曖昧だから）  
これが「importの都合で衝突」という意味。

#### ちなみにimport都合の衝突を避ける方法がある
- import に別名をつける（これがファイルで名前空間）
  - Dartではasが名前空間（プレフィックス）になる
  - この app.やadmin.が名前空間の役をしてる

```Dart
import 'app_labels.dart' as app;
import 'admin_labels.dart' as admin;

void main() {
  print(app.tabs);    // ['Home', ...]
  print(admin.tabs);  // ['Users', ...]
}
```
- show / hide で持ち込む名前を制限

```Dart
import 'app_labels.dart' show tabs;
import 'admin_labels.dart' hide tabs; // tabsを持ち込まない
```

#### 「class + static const」は何が嬉しいのか
色々と掘り下げながら例を挙げながらまとめてたが、結局何がいいのか。。  
それは、トップレベルにtabsを置かず、最初から「箱付き」で定義できるから。

```Dart
class AppLabels {
  static const tabs = ['Home', 'Search', 'Settings'];
}
```
こうしておけば、他でtabsがあっても関係なく「AppLabels.tabs
」と必ず区別できる。  
import 衝突というより、命名の曖昧さ・散らばりも減らせる。

ちなみに「class + static const」は一般的には「別ファイル」に分けることが多い。  

#### 「class + static const」 定数クラスは別ファイルに分けるパターン
- 散らばらない／依存を減らす／見通しを良くするため

```Dart
// lib/constants/app_labels.dart

class AppLabels {
  static const tabs = ['Home', 'Search', 'Settings'];
}

// lib/pages/example.dart（使う側）
import 'package:your_app/constants/app_labels.dart';

class Example {
  void foo() {
    print(AppLabels.tabs);
  }
}
```

#### 「class + static const」 その画面だけのローカル定数なら、同じファイルに置くパターン
- スコープ（影響範囲）を狭くする、「この画面以外では絶対使わない」なら、わざわざ共通化しない時
- クラス名を 「_」で始めると そのファイル内限定（ライブラリ内限定） にできるので
外に漏れない定数置き場として便利

```Dart
// lib/pages/example.dart

import 'package:flutter/material.dart';

class _ExampleLabels {
  static const tabs = ['Home', 'Search', 'Settings'];
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(_ExampleLabels.tabs.join(', '));
  }
}
```

#### 「定数クラス」を作らず、トップレベルconstを別ファイルで管理する派も多いらしい

```Dart
// app_labels.dart

const tabs = ['Home', 'Search', 'Settings'];
```

#### トップレベルconstとは
-   クラスの中じゃなくて、ファイルの一番外側にconstを置くやり方

```Dart
// app_labels.dart
// この時点で「tabs は app_labels.dart が提供する定数」になる

const tabs = ['Home', 'Search', 'Settings'];
```

#### 上記をimportすると「tabs」がそのまま使える。

```Dart
// example.dart
// importしたファイルの公開名が、そのまま今のファイルに入ってくるイメージ

import 'app_labels.dart' as labels; // 衝突することがあるので別名（接頭辞）をつける

void main() {
  print(tabs); // 使える
}
```

#### よくわからなくなってきたので「class + static const」との違いを一言でまとめておく
-   AppLabels.tabs：クラスを箱にする
-   labels.tabs：ファイルを箱にする（import as で箱名を付ける）

---
#### Bがいい例：　final list = const [..]; → 再代入× / 中身変更×

```Dart
// list自体は実行時に決まるけど、どちらも中身は不変

final list = isDebug ? const [1, 2, 3] : const [4, 5, 6];
```

```Dart
// インスタンスフィールドは const を付けられない

class MyWidget extends StatelessWidget {
  // const List<String> labels = ['A', 'B']; // 書けない（インスタンスフィールドにconst不可）
  final List<String> labels = const ['A', 'B']; // これはOK

  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(labels.join(', '));
  }
}


```


```Dart
```

イテレーター

アロー関数

Enumはよく使う
switch

論理演算子

三項演算子

try-catch-finally文

クラス（他のサイトも参照）

static

クラス内でのメソッド

テスト


