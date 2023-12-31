import 'package:flutter/material.dart';
import 'src/web_view_stack.dart';


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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body:
        Column(
          children: [
            Container(
              color: Colors.black,
              height: 25,
            ),
            const Expanded(
              child: WebViewStack(),
            )

          ]
        ),
      );


  }
}
