import 'dart:io' show Platform;

class UtilsBrowser {
  UtilsBrowser({this.isProd = false});

  final bool isProd;

  String get _host =>
      isProd ? 'ccapi.paymentez.com' : 'ccapi-stg.paymentez.com';

  String get onCallbackSaveCard {
    final javascript = '''
        window.postMessage({type: "tokenize", data: null}, "https://$_host");
      ''';
    return javascript;
  }

  String get onListenerResultSaveCard {
    return '''
      window.addEventListener("message", (event) => {
        if (event.origin !== "https://$_host") {
          return;
        }

        const msg = event.data;
        switch (msg.type) {
          case "incomplete_form":
            console.log("SDK_PAYMENTEZ_JS: incomplete_form " + msg.data);

            const dataErr = {
              type: "incomplete_form",
              data: null,
              message: msg.data,
            };

            if (window.flutter_inappwebview !== undefined) {
              window.flutter_inappwebview.callHandler(
                "SendDataSDK", 
                JSON.stringify(dataErr)
              );
            }

            if (SendDataSDK !== undefined) {
              SendDataSDK.postMessage(JSON.stringify(dataErr));
            }
            break;
          case "tokenize_response":
            console.log(
              "SDK_PAYMENTEZ_JS: tokenize_response " + JSON.stringify(msg.data)
            );

            const data = {
              type: "tokenize_response",
              data: msg.data,
              message: msg.data.message,
            };

            if (window.flutter_inappwebview !== undefined) {
              window.flutter_inappwebview.callHandler(
                "SendDataSDK", 
                JSON.stringify(data)
              );
            }

            if (SendDataSDK !== undefined) {
              SendDataSDK.postMessage(JSON.stringify(data));
            }
            break;
        }
      });
        ''';
  }

  static String getUserAgent(String? value) {
    var userAgent = '';
    if (Platform.isAndroid) {
      userAgent =
          'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.40 Mobile Safari/537.36';
    }

    if (Platform.isIOS) {
      userAgent =
          'Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/123.0.6312.52 Mobile/15E148 Safari/604.1';
    }

    if (Platform.isMacOS) {
      userAgent =
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36';
    }

    return value ?? userAgent;
  }
}
