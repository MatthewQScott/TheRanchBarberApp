import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewStack extends StatefulWidget {
  const WebViewStack({super.key});

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0;
  late final WebViewController controller;
  var networkError = false;
  static const websiteUri = 'https://the-ranch-barber-co.square.site/';

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onWebResourceError: (error) {
          setState(() {
            if (error.errorType != WebResourceErrorType.unknown) {
              networkError = true;
            }
          });
        },
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
        onNavigationRequest: (navigation) {
          final url = navigation.url;
          if (url.startsWith(websiteUri)) {
            return NavigationDecision.navigate;
          }
          else if (url.startsWith('tel:')) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Debug: Navigation Blocked"),
            ));
            return NavigationDecision.prevent;
          }
          else if (url.startsWith('mailto:')) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Debug: Navigation Blocked"),
            ));
            return NavigationDecision.prevent;
          }
          else if (url.startsWith('fb.me:')) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Debug: Navigation Blocked"),
            ));
            return NavigationDecision.prevent;
          }
          else {
            return NavigationDecision.navigate;
          }
        }
      ))
      ..loadRequest(
        Uri.parse(websiteUri),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!networkError)
        WebViewWidget(
          controller: controller,
        ),
        if (networkError)
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("assets/Designer.png"),
                  width: 128,
                  height: 128,
                ),
                SizedBox(height: 16),
                Text("Aw man! You goot an error")
              ],
            ),
          ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
            minHeight: 20,
            color: Colors.yellow,
          ),
      ],
    );
  }
}
