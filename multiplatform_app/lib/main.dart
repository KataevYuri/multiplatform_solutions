import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:html/parser.dart' as htmlparser;
import 'package:webview_flutter/webview_flutter.dart';

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
  final _wvcontroller = WebViewController();

  @override
  void initState() {
    _controller.text = 'https://flutter.dev';

    _wvcontroller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint("Loading: $progress%");
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(_controller.text));

    super.initState();
  }

  Future<(String, String, String)> _loadHtmlPage() async {
    final response = await Dio().get(_controller.text);
    final htmldoc = htmlparser.parse(response.data);
    return (
      response.data.toString(),
      htmldoc.body!.getElementsByTagName('h1')[0].innerHtml,
      response.headers.toString()
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(defaultTargetPlatform.toString(),
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text(siteHeader,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text(siteResponseHeader,
                style: const TextStyle(color: Colors.red, fontSize: 16)),
            Expanded(
              child: SingleChildScrollView(
                  child: WebViewWidget(
                controller: _wvcontroller,
              )),
            ),
            Row(children: [
              Expanded(
                child: SizedBox(
                  width: 200,
                  child: TextFormField(
                    controller: _controller,
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    final response = await _loadHtmlPage();
                    setState(() {
                      siteHTML = response.$1;
                      siteHeader = response.$2;
                      siteResponseHeader = response.$3;
                    });
                  },
                  child: const Text('Загрузить сайт'))
            ])
          ],
        ),
      ),
    );
  }
}
