// ignore_for_file: avoid_dynamic_calls, lines_longer_than_80_chars

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:paymentez_sdk/models/models.dart';
import 'package:paymentez_sdk/utils/utils_browser.dart';

enum _TypePlugin { webView, inappwebview, none }

class PaymentezController {
  PaymentezController({required bool isProd})
      : _utils = UtilsBrowser(isProd: isProd);

  final UtilsBrowser _utils;
  final _streamCtrl = StreamController<FormCardResponse>();

  _TypePlugin _typePlugin = _TypePlugin.none;
  dynamic _ctrl;

  void _onMessageReceived(dynamic dat) {
    log('SDK_PAYMENTEZ: MESSGAGE RECEIVED $dat');
    switch (_typePlugin) {
      case _TypePlugin.inappwebview:
        final data = dat as List<dynamic>;
        final mapData =
            json.decode(data.first.toString()) as Map<String, dynamic>;
        _streamCtrl.add(FormCardResponse.fromJson(mapData));
      case _TypePlugin.webView:
        final data = dat.message as String;
        final mapData = json.decode(data) as Map<String, dynamic>;
        _streamCtrl.add(FormCardResponse.fromJson(mapData));
      case _TypePlugin.none:
        break;
    }
  }

  void setController(dynamic ctrl) {
    log('SDK_PAYMENTEZ: SET CONTROLLER => $ctrl');
    if (ctrl == null) return;
    switch (ctrl.runtimeType.toString()) {
      case 'InAppWebViewController':
        _ctrl = ctrl;
        _typePlugin = _TypePlugin.inappwebview;
        if (_existAddJavaScriptHandler) {
          _ctrl.addJavaScriptHandler(
            handlerName: 'SendDataSDK',
            callback: (dynamic data) {
              _onMessageReceived(data);
            },
          );
        }
      case 'WebViewController':
        _ctrl = ctrl;
        _typePlugin = _TypePlugin.webView;
        if (_existAddJavaScriptChannel) {
          _ctrl.addJavaScriptChannel(
            'SendDataSDK',
            onMessageReceived: (dynamic data) {
              _onMessageReceived(data);
            },
          );
        }
      default:
        return;
    }
  }

  void finishLoadPage() {
    switch (_typePlugin) {
      case _TypePlugin.inappwebview:
        log('SDK_PAYMENTEZ: FINISH LOADING PAGE USE INAPPWEBVIEW');
        if (_existEvaluateJavascript) {
          _ctrl.evaluateJavascript(source: _utils.onListenerResultSaveCard);
        }
      case _TypePlugin.webView:
        log('SDK_PAYMENTEZ: FINISH LOADING PAGE USE WEBVIEW');
        if (_existRunJavaScript) {
          _ctrl.runJavaScript(_utils.onListenerResultSaveCard);
        }
      case _TypePlugin.none:
        return;
    }
  }

  void onSaveCard() {
    switch (_typePlugin) {
      case _TypePlugin.inappwebview:
        if (_existEvaluateJavascript) {
          log('SDK_PAYMENTEZ: ON SAVE CARD USE INAPPWEBVIEW');
          _ctrl.evaluateJavascript(source: _utils.onCallbackSaveCard);
        }
      case _TypePlugin.webView:
        if (_existRunJavaScript) {
          log('SDK_PAYMENTEZ: ON SAVE CARD USE WEBVIEW');
          _ctrl.runJavaScript(_utils.onCallbackSaveCard);
        }
      case _TypePlugin.none:
        return;
    }
  }

  Stream<FormCardResponse> onResult() {
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
