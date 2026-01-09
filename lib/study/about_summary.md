# 文法（List）

## List

### ①書き方は人によって違うことがある

```Dart
// 5パターンどれも同じ

// 両辺でconstを指定
const list = const [1, 2, 3];

// 両辺でconstを指定
const List<int> list = const [1, 2, 3];　//こっちは要素の型を左辺で明示

// 両辺でconstを指定
const list = const <int>[1, 2, 3];　//こっちは要素の型を右辺で明示

// Dartにはconstの暗黙付与があるので右辺もconstになる（一般的な書き方）
const list = [1, 2, 3];

// Dartにはconstの暗黙付与があるので右辺もconstになる（一般的な書き方）
const List<int> list = [1, 2, 3];　//こっちは要素の型を左辺で明示

//Dartにはconstの暗黙付与があるので右辺もconstになる（一般的な書き方）
const list = <int>[1, 2, 3]; //こっちは要素の型を右辺で明示
```

### ②finalとconstのListについて

#### Point
- finalは、変数への再代入を不可とするだけ(変数の参照を固定する)
- つまり、Listが可変長（add/removedで中身の変更ができる）かどうかはfinalでは決まらないということ
- つまり、finalにListの中身の変更可否の決定権はないので、右辺次第になる
- 右辺がconstならListは中身の変更は不可となる

---

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

// const Listなので変更不可
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

### ③ふと思った、以下２つはやっていることは同じでは？
#### どこかの場面で使い分ける時とかあるの？
-   const list = [..]; → 再代入× / 中身変更×
-   final list = const [..]; → 再代入× / 中身変更×


#### 違いとしては以下くらい
    コンパイル時（ビルド）にlistが決まればいいか、  
    実行時にlistが決まればいいか、






```Dart
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


