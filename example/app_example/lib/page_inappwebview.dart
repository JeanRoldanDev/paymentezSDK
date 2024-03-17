import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:paymentez_sdk/paymentez_controller.dart';

class PageInappWebview extends StatefulWidget {
  const PageInappWebview({
    required this.url,
    required this.paymentezCtrl,
    super.key,
  });

  final String url;
  final PaymentezController paymentezCtrl;

  @override
  State<PageInappWebview> createState() => _PageInappWebviewState();
}

class _PageInappWebviewState extends State<PageInappWebview> {
  InAppWebViewController? ctrl;

  @override
  void initState() {
    widget.paymentezCtrl.addListeners(
      onSave: enviar,
    );
    super.initState();
  }

  void enviar() {
    ctrl!.evaluateJavascript(
      source: widget.paymentezCtrl.utils.onCallbackSaveCard,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.red,
      child: InAppWebView(
        key: Key('${widget.url}${DateTime.now().millisecondsSinceEpoch}'),
        onConsoleMessage: (ctrler, consoleMessage) {
          log(consoleMessage.message);
        },
        initialUrlRequest: URLRequest(
          url: WebUri(widget.url),
        ),
        onWebViewCreated: (controller) async {
          ctrl = controller;
        },
      ),
    );
  }
}
