library paymentez;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:paymentez/models/paymentez_resp.dart';
import 'package:paymentez/models/userPay.dart';
import 'package:paymentez/repository/paymentez_repository_interface.dart';
import 'package:paymentez/utils/paymentez_security.dart';
import 'package:http/http.dart' as http;
import 'package:paymentez/models/cardPay.dart';
part 'services/paymentez_services.dart';

/// A Calculator.
class Paymentez {
  // static ConfigAuthorization _configAuth;
  // Paymentez({this.configAuthorization});

  Paymentez._();
  static Paymentez _instance = Paymentez._();
  static PaymentezRepositoryInterface _paymentezRepositoryInterface;

  static Paymentez instance({ConfigAuthorization configAuthorization}) {
    _paymentezRepositoryInterface = _PaymentezServices(configAuthorization);
    return _instance;
  }

  Future<PaymentezResp> addCard({
    UserPay user,
    CardPay card,
    String sessionId,
  }) async {
    return await _paymentezRepositoryInterface.addCard(
      user: user,
      card: card,
      sessionId: sessionId,
    );
  }

  Future<PaymentezResp> getAllCards(String userId) async {
    return await _paymentezRepositoryInterface.getAllCards(userId);
  }

  Future<PaymentezResp> delCard(String userId, String tokenCard) async {
    return await _paymentezRepositoryInterface.delCard(
      userId: userId,
      tokenCard: tokenCard,
    );
  }

  Future<PaymentezResp> infoTransaction(String userId, String transactionId) async {
    return await _paymentezRepositoryInterface.infoTransaction(
      userId: userId,
      transactionId: transactionId,
    );
  }

  Future<PaymentezResp> verify(String userId, String transactionId, String type, String value, bool moreInfo) async {
    return await _paymentezRepositoryInterface.verify(
      userId: userId,
      transactionId: transactionId,
      type: type,
      value: value,
      moreInfo: moreInfo,
    );
  }
}

class ConfigAuthorization {
  ConfigAuthorization({
    this.production = false,
    @required this.appCode,
    @required this.appClientKey,
    @required this.appCodeSERVER,
    @required this.appClientKeySERVER,
    this.isLogServe = false,
    this.urlLogServe,
    this.headers,
  });

  final bool production;
  final String appCode;
  final String appClientKey;
  final String appCodeSERVER;
  final String appClientKeySERVER;
  final bool isLogServe;
  final String urlLogServe;
  final Map<String, String> headers;

  String getHost() {
    return production ? "https://ccapi.paymentez.com" : "https://ccapi-stg.paymentez.com";
  }
}
