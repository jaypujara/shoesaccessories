import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewLinkOpnning extends StatefulWidget {
  String title;

  String url;

  WebViewLinkOpnning({super.key, required this.title, required this.url});

  @override
  State<WebViewLinkOpnning> createState() => _WebViewLinkOpnningState();
}

class _WebViewLinkOpnningState extends State<WebViewLinkOpnning> {
  bool isLoading = false;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            debuggingEnabled: false,
            initialUrl: widget.url,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onWebResourceError: (WebResourceError error) {},

            onProgress: (int progress) {
              log('WebView is loading (progress : $progress%)');
            },
            onPageStarted: (String url) {
              setState(() {
                isLoading = true;
              });
              log('Page started loading: $url');
            },
            onPageFinished: (String url) {
              setState(() {
                isLoading = false;
              });
              log('Page finished loading: $url');
            },
            gestureNavigationEnabled: true,
            backgroundColor: const Color(0x00000000),
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
