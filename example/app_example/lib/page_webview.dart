import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PageWebView extends StatefulWidget {
  const PageWebView({
    required this.url,
    super.key,
  });

  final String url;

  @override
  State<PageWebView> createState() => _PageWebViewState();
}

class _PageWebViewState extends State<PageWebView> {
  late WebViewController _ctrl = WebViewController();

  @override
  void initState() {
    _ctrl = WebViewController();
    _ctrl.loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      key: Key('${widget.url}${DateTime.now().millisecondsSinceEpoch}'),
      controller: _ctrl,
    );
  }
}
