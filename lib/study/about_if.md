# 三項演算子

## 式
- 条件式 ? 式1 : 式2
    - 条件式がtureなら式1が評価され戻り値になる
    - falseなら式2が評価され戻り値になる

## 例
```Dart
int a = 128;
int b = 256;
  
final max = a > b ? a : b;
print(max);
```

## どんな時に使える？
- 文が書けず、値しか書けない時
  - ifは文なので値が必要な場所には置けない

## 具体的には？
- コレクション（List/Map/Set）を作る途中で分岐
```Dart
final isAdmin = false;
  
final homeTabs = ['Home', isAdmin ? 'Admin': 'Profile'];
  
print(homeTabs);
```

- returnで値を返す（1行で返したい時）
```Dart
String greet(String? name){
  return name == null ? 'こんにちは、ゲストさん' : 'こんにちは、$nameさん';
}

void main() {
  print(greet(null));
  print(greet('田中'));
}
```

- 文字列補間
```Dart
void main() { 
final score = 68; 
// ${}は、文字列の中に「式の結果」を埋め込む仕組み
print('判定: ${score >= 70 ? "合格" : "不合格"}'); 
print('score+1=${score + 1}');
print('合格？=${score >= 70}');//false
}
```
- 文字列補間なしver
```Dart
void main() {
  final score = 72;

  final result = (score >= 70) ? "合格" : "不合格";
  print('判定: ' + result);
}
```
## その他
- widgetの初期値
- ボタン無効化
  - 等で使われる
