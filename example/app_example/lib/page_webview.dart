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

class _PageWebViewState extends State<PageWebView> {
  late WebViewController _ctrl;

  @override
  void initState() {
    _ctrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.blue)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (widget.url.isNotEmpty) {
              widget.paymentezCtrl.onInit();
            }
          },
        ),
      )
      ..setOnConsoleMessage((message) {
        print('MESAJE CONSOLE');
        print(message.message);
      });
    widget.paymentezCtrl.setController(_ctrl);
    super.initState();
  }

  //  _ctrl.runJavaScript(widget.paymentezCtrl.utils.onCallbackSaveCard);

  @override
  Widget build(BuildContext context) {
    if (widget.url.isNotEmpty) {
      _ctrl.loadRequest(Uri.parse(widget.url));
    }
    return SizedBox.expand(
      child: WebViewWidget(
        key: Key('${widget.url}${DateTime.now().millisecondsSinceEpoch}'),
        controller: _ctrl,
      ),
    );
  }
}
