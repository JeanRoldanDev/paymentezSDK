import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:paymentez_sdk/models/browser_info.dart';
import 'package:paymentez_sdk/paymentez_sdk.dart';

class WebViewInfoGatherer extends StatefulWidget {
  const WebViewInfoGatherer({required this.onBrowserInfo, super.key});
  final void Function(BrowserInfo) onBrowserInfo;

  @override
  State<WebViewInfoGatherer> createState() => _WebViewInfoGathererState();
}

class _WebViewInfoGathererState extends State<WebViewInfoGatherer> {
  late Future<void> _initServer;

  @override
  void initState() {
    _initServer = Future(() async {
      if (!kIsWeb) {
        // start the localhost server
        if (!localhostServer.isRunning()) await localhostServer.start();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    localhostServer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0,
      height: 0,
      child: FutureBuilder(
        future: _initServer,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox();
          }
          return InAppWebView(
            initialSettings: InAppWebViewSettings(
              isInspectable: kDebugMode,
            ),
            initialUrlRequest: URLRequest(
              url: WebUri('http://localhost:8080/browser_info.html'),
            ),
            onLoadStop: (controller, url) {},
            onWebViewCreated: (controller) async {
              if (defaultTargetPlatform != TargetPlatform.android ||
                  await WebViewFeature.isFeatureSupported(
                    WebViewFeature.WEB_MESSAGE_LISTENER,
                  )) {
                await controller.addWebMessageListener(
                  WebMessageListener(
                    jsObjectName: 'BrowserInfo',
                    onPostMessage:
                        (message, sourceOrigin, isMainFrame, replyProxy) {
                      final browserInfo = BrowserInfo.fromJson(
                        message?.data as String,
                      );

                      widget.onBrowserInfo(browserInfo);
                    },
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
