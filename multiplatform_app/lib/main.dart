import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String siteHeader = "siteHeader";

  String siteResponseHeader = "siteResponseHeader";

  String siteHTML = "siteHTML";

  bool isLoaded = false;

  final _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = 'https://flutter.dev';
    super.initState();
  }

  Future<Response> _loadHtmlPage() async {
    return await Dio().get(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    onPressed: () async {
                      Response response = await _loadHtmlPage();
                      setState(() {
                        siteHTML = response.body;
                      });
                    },
                    child: const Text('Загрузить сайт'))
              ]),
            )
          ],
        ),
      ),
    );
  }
}
