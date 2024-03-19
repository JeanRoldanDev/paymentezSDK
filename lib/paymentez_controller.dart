// ignore_for_file: avoid_dynamic_calls, lines_longer_than_80_chars

import 'dart:async';
import 'dart:developer';

import 'package:paymentez_sdk/models/models.dart';
import 'package:paymentez_sdk/utils/utils_browser.dart';

enum _TypePlugin { webView, inappwebview, none }

class PaymentezController {
  PaymentezController({required bool isProd})
      : _utils = UtilsBrowser(isProd: isProd);

  final UtilsBrowser _utils;
  final _streamCtrl = StreamController<(AddCardResponse?, PaymentezError?)>();

  _TypePlugin _typePlugin = _TypePlugin.none;
  dynamic _ctrl;

  void setController(dynamic ctrl) {
    log('SDK_PAYMENTEZ: SET CONTROLLER => $ctrl');
    if (ctrl == null) return;
    switch (ctrl.runtimeType.toString()) {
      case 'InAppWebViewController':
        _ctrl = ctrl;
        _typePlugin = _TypePlugin.inappwebview;
      case 'WebViewController':
        _ctrl = ctrl;
        _typePlugin = _TypePlugin.webView;
      default:
        return;
    }
  }

  void onInit() {
    switch (_typePlugin) {
      case _TypePlugin.inappwebview:
        log('SDK_PAYMENTEZ:  EMISOR OF Inappwebview');
        if (_existEvaluateJavascript) {
          _ctrl.evaluateJavascript(source: _utils.onListenerResultSaveCard);
        }

        if (_existAddJavaScriptHandler) {
          _ctrl.addJavaScriptHandler(
            handlerName: 'SendDataSDK',
            callback: (dynamic dat) {
              print('LLEGO ALGO DESDE JS: $dat');
            },
          );
        }
      case _TypePlugin.webView:
        if (_existRunJavaScript) {
          _ctrl.runJavaScript(_utils.onListenerResultSaveCard);
        }

        if (_existAddJavaScriptChannel) {
          _ctrl.addJavaScriptChannel(
            'SendDataSDK',
            onMessageReceived: (dynamic dat) {
              final data = dat.message as String;
              print('LLEGO ALGO DESDE JS 22: $data');
            },
          );
        }
      case _TypePlugin.none:
        return;
    }
  }

  void onSaveCard() {
    switch (_typePlugin) {
      case _TypePlugin.inappwebview:
        if (_existEvaluateJavascript) {
          log('SDK_PAYMENTEZ: ON SAVE CARD');
          _ctrl.evaluateJavascript(source: _utils.onCallbackSaveCard);
        }
      case _TypePlugin.webView:
        if (_existRunJavaScript) {
          log('SDK_PAYMENTEZ: ON SAVE CARD');
          _ctrl.runJavaScript(_utils.onCallbackSaveCard);
        }
      case _TypePlugin.none:
        return;
    }
  }

  Stream<(AddCardResponse?, PaymentezError?)> onResult() {
    return _streamCtrl.stream;
  }

  // ==================================================================
  // =====================  PRIVATE FUNCTION   ========================
  // ==================================================================
  bool get _existEvaluateJavascript {
    if (_ctrl == null) return false;
    try {
      final status = _ctrl.evaluateJavascript.runtimeType.toString();
      const key =
          '({required String source, ContentWorld? contentWorld}) => Future<dynamic>';

      return status == key;
    } catch (e) {
      return false;
    }
  }

  bool get _existAddJavaScriptHandler {
    if (_ctrl == null) return false;
    try {
      final status = _ctrl.addJavaScriptHandler.runtimeType.toString();
      const key =
          '({required String handlerName, required (List<dynamic>) => dynamic callback}) => void';

      return status == key;
    } catch (e) {
      return false;
    }
  }

  bool get _existRunJavaScript {
    if (_ctrl == null) return false;
    try {
      final status = _ctrl.runJavaScript.runtimeType.toString();
      const key = '(String) => Future<void>';
      return status == key;
    } catch (e) {
      return false;
    }
  }

  bool get _existAddJavaScriptChannel {
    if (_ctrl == null) return false;
    try {
      final status = _ctrl.addJavaScriptChannel.runtimeType.toString();
      const key =
          '(String, {required (JavaScriptMessage) => void onMessageReceived}) => Future<void>';
      return status == key;
    } catch (e) {
      return false;
    }
  }
}
