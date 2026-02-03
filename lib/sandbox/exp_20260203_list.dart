import 'package:flutter/material.dart';

class ExpListPage extends StatefulWidget {
  const ExpListPage({super.key, required this.title});

  final String title;

  @override
  State<ExpListPage> createState() => _ExpListPageState();
}

class _ExpListPageState extends State<ExpListPage> {
  int _counter = 0;

  // listを使用してみる
  final List<int> _history = [];

  void _incrementCounter() {
    setState(() {
      _counter++;

      // カウントした数字をListに追加
      _history.add(_counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 24),

            const Text('history(Listの中身をそのまま表示)'),
            Text('$_history'),

            const SizedBox(height: 24),
            const Text('history(Listの中身をjoinメソッドを使用して表示)'),
            Text(_history.join(', ')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
