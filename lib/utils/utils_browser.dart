import 'dart:developer';

class UtilsBrowser {
  UtilsBrowser({this.isProd = false});

  final bool isProd;

  String get _host =>
      isProd ? 'ccapi.paymentez.com' : 'ccapi-stg.paymentez.com';

  String get onCallbackSaveCard {
    log('get onCallballSaveCard');
    final javascript = '''
        let message = { type: "tokenize", data: null };
        window.postMessage(message, "https://$_host");
      ''';
    return javascript;
  }
}
