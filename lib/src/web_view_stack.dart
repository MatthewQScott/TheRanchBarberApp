import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'dart:developer' as developer;

import 'no_wifi_screen.dart';

class WebViewStack extends StatefulWidget {
  const WebViewStack({super.key});

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  var loadingPercentage = 0;
  late final WebViewController controller;
  var webResourceError = false;
  static const websiteUri = 'https://the-ranch-barber-co.square.site/';

  bool pageLoaded = false;

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  void _retryInternetConnection() {
    initConnectivity();
  }


  @override
  void initState() {
    super.initState();
    initConnectivity();


    _connectivitySubscription =
      _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);


    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onWebResourceError: (WebResourceError error) {
          setState(() {
            if (error.errorType != WebResourceErrorType.unknown) {
              webResourceError = true;
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
            pageLoaded = true;
          });
        },
        onNavigationRequest: (navigation) {
          final url = navigation.url;
          pageLoaded = false;
          if (url.startsWith(websiteUri)) {
            return NavigationDecision.navigate;
          }
          else {
            _launchUrl(url);
            return NavigationDecision.prevent;
          }
        }
      ))
      ..loadRequest(
        Uri.parse(websiteUri),
      );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
      if (_connectionStatus != ConnectivityResult.none) {
        webResourceError = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (webResourceError == false)
          WebViewWidget(
            controller: controller,
          )
        else
          NoWifiScreen(
              onButtonPressed: _retryInternetConnection
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
