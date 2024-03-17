import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PageInappWebview extends StatefulWidget {
  const PageInappWebview({required this.url, super.key});

  final String url;

  @override
  State<PageInappWebview> createState() => _PageInappWebviewState();
}

class _PageInappWebviewState extends State<PageInappWebview> {
  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      onConsoleMessage: (ctrler, consoleMessage) {
        log(consoleMessage.message);
        // print('=========RECIVE CONSOLE');
        // print(ctrler);
        // print(consoleMessage.message);
        // print(consoleMessage.toJson());
        // print(consoleMessage.toMap());
        // print(consoleMessage);
      },
      initialUrlRequest: URLRequest(
        url: WebUri(widget.url),
      ),
      onWebViewCreated: (controller) async {
        print('onWebViewCreated');
        // ctrl = controller;
      },
      onLoadStart: (controller, url) async {
        // print('onLoadStart');
      },
      onProgressChanged: (controller, progress) {
        // print('progress $progress');
      },
    );
  }
}
