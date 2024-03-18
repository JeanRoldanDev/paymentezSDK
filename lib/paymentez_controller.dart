// ignore_for_file: avoid_dynamic_calls

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
      default:
        return;
    }
  }

  void onInit() {
    switch (_typePlugin) {
      case _TypePlugin.inappwebview:
        if (_existEvaluateJavascript) {
          log('SDK_PAYMENTEZ: ON LISTENER RESULT');
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
        break;
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
        break;
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
          // ignore: lines_longer_than_80_chars
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
          // ignore: lines_longer_than_80_chars
          '({required String handlerName, required (List<dynamic>) => dynamic callback}) => void';

      return status == key;
    } catch (e) {
      return false;
    }
  }
}
