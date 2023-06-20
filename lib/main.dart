import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(
    const MaterialApp(
      home: WebViewApp(),
    ),
  );
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;


  @override
  void initState() {
    super.initState();
    controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
        onProgress: (int progress) {

        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {

        },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('tel:')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://the-ranch-barber-co.square.site/'),
      );
  }

  @override
  Widget build(BuildContext context) {

    if (false) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('The Ranch Barber (WebView)'),
        ),
        body:
        WebViewWidget(
          controller: controller,
        ),
      );
    } else {
      return const Scaffold(
        body: Center(
          child: Text("Aw man! You got an error :("),
        ),
      );
    }

  }
}
