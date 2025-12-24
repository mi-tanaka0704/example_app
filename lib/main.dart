import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, String> languages = {
    'Python': 'Guido van Rossum',
    'Ruby': 'Matumoto Yukihiro',
    'PHP': 'Rasmus Lerdorf'
  };

  void _removeLanguage(String key) {
    setState(() {
      languages.remove(key);
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
        child: languages.isEmpty
            ? const Text(
          'No languages available',
          style: TextStyle(fontSize: 18),
        )
            : ListView.builder(
          itemCount: languages.length,
          itemBuilder: (context, index) {
            String language = languages.keys.elementAt(index);
            String creator = languages[language]!;

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(language[0]),
                ),
                title: Text(
                  language,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(creator),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _removeLanguage(language);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}