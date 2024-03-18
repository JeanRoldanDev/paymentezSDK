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

  void _onLoadFinish(InAppWebViewController controller, WebUri? uri) {
    if (widget.url.isNotEmpty) {
      widget.paymentezCtrl.onInit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: InAppWebView(
        key: Key('${widget.url}${DateTime.now().millisecondsSinceEpoch}'),
        initialUrlRequest: URLRequest(
          url: WebUri(widget.url),
        ),
        onWebViewCreated: _onWebViewCreated,
        onLoadStop: _onLoadFinish,
        onConsoleMessage: (ctrler, consoleMessage) {
          print('CONSOLE ==>');
          print(consoleMessage.message);
        },
      ),
    );
  }
}
