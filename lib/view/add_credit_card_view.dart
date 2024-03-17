import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:paymentez_sdk/paymentez_sdk.dart';
import 'package:paymentez_sdk/src/paymentez.inteface.dart';

class AddCreditCardView extends StatefulWidget {
  const AddCreditCardView({
    required this.paymentez,
    required this.userId,
    required this.userEmail,
    required this.country,
    super.key,
  });
  final IPaymentez paymentez;
  final String userId;
  final String userEmail;
  final String country;

  @override
  State<AddCreditCardView> createState() => _AddCreditCardViewState();
}

class _AddCreditCardViewState extends State<AddCreditCardView> {
  late Future<void> initServer;

  @override
  void initState() {
    if (!localhostServer.isRunning()) {
      initServer = localhostServer.start();
    } else {
      initServer = Future.value();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (localhostServer.isRunning()) localhostServer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initServer,
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : InAppWebView(
                initialSettings: InAppWebViewSettings(
                  isInspectable: kDebugMode,
                ),
                initialUrlRequest: URLRequest(
                  url: WebUri('http://localhost:8080/add_card_form.html'),
                ),
                onLoadStop: (controller, url) {
                  final jsCode = jsInitCode(
                    enviroment: widget.paymentez.environment,
                    appCode: widget.paymentez.clientAppCode,
                    appKey: widget.paymentez.clientAppKey,
                    userId: widget.userId,
                    userEmail: widget.userEmail,
                    country: widget.country, //'ECU'
                  );

                  controller.evaluateJavascript(source: jsCode);
                },
                onWebViewCreated: (controller) async {
                  if (defaultTargetPlatform != TargetPlatform.android ||
                      await WebViewFeature.isFeatureSupported(
                        WebViewFeature.WEB_MESSAGE_LISTENER,
                      )) {
                    await controller.addWebMessageListener(
                      WebMessageListener(
                        jsObjectName: 'CardAdded',
                        onPostMessage: (
                          message,
                          sourceOrigin,
                          isMainFrame,
                          replyProxy,
                        ) {
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  }
                },
              );
      },
    );
  }

  String jsInitCode({
    required String enviroment,
    required String appCode,
    required String appKey,
    required String userId,
    required String userEmail,
    required String country,
  }) =>
      '''
    initFormPaymentez('$enviroment', '$appCode', '$appKey', '$userId', '$userEmail', '$country');
    ''';
}
