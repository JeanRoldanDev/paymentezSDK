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

  void _onWebViewCreated(InAppWebViewController controller) {
    ctrl = controller;
    widget.paymentezCtrl.setController(ctrl);
  }

  void _setController() {
    if (widget.url.isNotEmpty) {
      ctrl!.loadUrl(
        urlRequest: URLRequest(
          url: WebUri(widget.url),
        ),
      );
    }
  }

  @override
  void didUpdateWidget(covariant PageInappWebview oldWidget) {
    _setController();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: InAppWebView(
        onWebViewCreated: _onWebViewCreated,
        onLoadStop: (controller, url) {
          widget.paymentezCtrl.finishLoadPage();
        },
        onConsoleMessage: (ctrler, msg) {
          log('MESSAGE CONSOLE: ${msg.message}');
        },
      ),
    );
  }
}
