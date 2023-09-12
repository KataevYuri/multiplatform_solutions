import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String siteHeader = "";

  String siteResponseHeader = "";

  String siteHTML = "";

  final _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = 'https://flutter.dev';
    super.initState();
  }

  Future<void> _loadHtmlPage() async {
    final result = await http.get(Uri.parse(_controller.text));
    setState(() {
      siteHTML = result.body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Text(siteHeader),
            Text(siteResponseHeader),
            Expanded(child: Text(siteHTML)),
            Expanded(
              child: Row(children: [
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    controller: _controller,
                  ),
                ),
                ElevatedButton(
                    onPressed: _loadHtmlPage,
                    child: const Text('Загрузить сайт'))
              ]),
            )
          ],
        ),
      ),
    );
  }
}
