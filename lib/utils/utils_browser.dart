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
            console.log("SDK_PAYMENTEZ: incomplete_form " + msg.data);

            const dataErr = {
              type: "incomplete_form",
              data: null,
              message: msg.data,
            };

            if (window.flutter_inappwebview !== undefined) {
              window.flutter_inappwebview
                .callHandler("SendDataSDK", dataErr)
                .then(function (result) {
                  console.log(
                    "SDK_PAYMENTEZ: Data successfully sent to the SDK =>" +
                      result
                  );
                })
                .catch(function (error) {
                  console.log(
                    "SDK_PAYMENTEZ: Error getting data from WebView => " + error
                  );
                });
            }
            break;
          case "tokenize_response":
            console.log(
              "SDK_PAYMENTEZ: tokenize_response " + JSON.stringify(msg.data)
            );

            const data = {
              type: "tokenize_response",
              data: msg.data,
              message: msg.data.message,
            };

            if (window.flutter_inappwebview !== undefined) {
              window.flutter_inappwebview
                .callHandler("SendDataSDK", data)
                .then(function (result) {
                  console.log(
                    "SDK_PAYMENTEZ: Data successfully sent to the SDK =>" +
                      result
                  );
                })
                .catch(function (error) {
                  console.log(
                    "SDK_PAYMENTEZ: Error getting data from WebView => " + error
                  );
                });
            }
            break;
        }
      });
        ''';
  }
}
