import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:paymentez_sdk/paymentez_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PageWebView extends StatefulWidget {
  const PageWebView({
    required this.url,
    required this.paymentezCtrl,
    super.key,
  });

  final String url;
  final PaymentezController paymentezCtrl;

  @override
  State<PageWebView> createState() => _PageWebViewState();
}

class _PageWebViewState extends State<PageWebView> with WidgetsBindingObserver {
  var _ctrl = WebViewController();

  void _setController() {
    if (widget.url.isNotEmpty) {
      _ctrl = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.blue)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (url) {
              widget.paymentezCtrl.finishLoadPage();
            },
          ),
        )
        ..setOnConsoleMessage((msg) {
          log('MESSAGE CONSOLE: ${msg.message}');
        });

      widget.paymentezCtrl.setController(_ctrl);
      _ctrl.loadRequest(Uri.parse(widget.url));
    }
  }

  @override
  void didUpdateWidget(covariant PageWebView oldWidget) {
    _setController();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Package webview_flutter'),
        Expanded(
          child: WebViewWidget(
            controller: _ctrl,
          ),
        ),
      ],
    );
  }
}
