library paymentez;

import 'dart:convert';
import 'dart:io';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/foundation.dart';
import 'package:paymentez/models/orderPay.dart';
import 'package:paymentez/models/paymentez_resp.dart';
import 'package:paymentez/models/userPay.dart';
import 'package:paymentez/repository/paymentez_repository_interface.dart';
import 'package:paymentez/utils/paymentez_security.dart';
import 'package:http/http.dart' as http;
import 'package:paymentez/models/cardPay.dart';
import 'package:paymentez/utils/validator.dart';
part 'services/paymentez_services.dart';

class Paymentez {
  Paymentez._();
  static final _instance = Paymentez._();
  static PaymentezRepositoryInterface _paymentezRepositoryInterface;

  static Paymentez instance({ConfigAuthorization configAuthorization}) {
    _paymentezRepositoryInterface = _PaymentezServices(configAuthorization);
    return _instance;
  }

  /// **[sessionId]**: Parámetro relacionado con el fraude.
  /// es un Hash numérico de 32 longitudes. y lo puedes generar con
  /// PaymentezSecurity.getSessionID()
  ///
  /// **[user]**: usa un modelos UserPay
  ///
  /// **[card]**: usa un modelos CardPay, para obtener el tipo debes usar
  ///
  /// final cardInfo = PaymentezValidate.getCarInfo(yourNumberCard);
  ///
  /// **Estos son los campos necesarios para poder agregar una tarjeta**
  /// ```dart
  /// final card = CardPay(
  ///   number: '123456xxxxxx1234',
  ///   holderName: 'Tarjetahabiente',
  ///   expiryMonth: 6,
  ///   expiryYear: 2025,
  ///   cvc: '123',
  ///   //type: cardInfo.type, ya no es obligatorio :) >:(
  /// );
  /// ```
  ///
  Future<PaymentezResp> addCard({
    @required String sessionId,
    @required UserPay user,
    @required CardPay card,
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

  Future<PaymentezResp> infoTransaction(
      String userId, String transactionId) async {
    return await _paymentezRepositoryInterface.infoTransaction(
      userId: userId,
      transactionId: transactionId,
    );
  }

  Future<PaymentezResp> verify({
    @required String userId,
    @required String transactionId,
    @required String type,
    @required String value,
    @required bool moreInfo,
  }) async {
    return await _paymentezRepositoryInterface.verify(
      userId: userId,
      transactionId: transactionId,
      type: type,
      value: value,
      moreInfo: moreInfo,
    );
  }

  /// **TODOS LOS COMERCIOS** deben implementar el MÉTODO REFUND para realizar
  /// los reembolsos de las transacciones, debido a que es una solicitud de los
  /// Bancos.
  ///
  ///
  /// También es necesario **ENVIAR UN CORREO DE CONFIRMACIÓN** después de cada
  /// transacción al cliente, notificándose el detalle de la compra,
  /// TRANSACTION_ID (DF) y AUTHORIZATION_CODE (número de autorización) Si los
  /// datos descritos no se encuentran implementados, el comercio no podrá
  /// avanzar en su integración.
  ///
  ///
  /// **[user]**: usa un modelos UserPay
  ///
  /// **[card]**: usa un modelos CardPay, para obtener el tipo debes usar
  ///
  /// final cardInfo = PaymentezValidate.getCarInfo(yourNumberCard);
  ///
  /// **Uso sin IVA**
  /// ```dart
  /// final order = OrderPay(
  ///   amount: 112.00,
  ///   description: 'pizzas',
  ///   devReference: 'token_orden_BT01',
  ///   vat: 0,
  ///   taxPercentage: 0, //Este valor por defecto es 0
  /// );
  /// ```
  ///
  ///
  /// **Uso declarando el IVA**
  /// ```dart
  /// final order = OrderPay(
  ///   amount: 112.00,
  ///   description: 'pizzas',
  ///   devReference: 'token_orden_BT01',
  ///   vat: 12.00,
  ///   taxPercentage: 12,
  ///   taxableAmount: 100.00,
  /// );
  /// ```
  ///
  ///
  /// **Uso para diferido a 3 meses sin intereses**
  /// ```dart
  /// final order = OrderPay(
  ///   amount: 112.00,
  ///   description: 'pizzas',
  ///   devReference: 'token_orden_BT01',
  ///   vat: 12.00,
  ///   taxPercentage: 12,
  ///   taxableAmount: 100.00,
  ///   installments: 3,
  ///   installmentsType: 1,
  /// );
  /// ```
  Future<PaymentezResp> debitToken({
    @required UserPay user,
    @required CardPay card,
    @required OrderPay orderPay,
  }) async {
    return await _paymentezRepositoryInterface.debitToken(
      user: user,
      card: card,
      orderPay: orderPay,
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
    this.enableTracking = false,
    this.urlLogServe,
    this.headers,
  });

  final bool production;
  final String appCode;
  final String appClientKey;
  final String appCodeSERVER;
  final String appClientKeySERVER;
  final bool isLogServe;
  final bool enableTracking;
  final String urlLogServe;
  final Map<String, String> headers;

  String getHost() {
    return production
        ? 'https://ccapi.paymentez.com'
        : 'https://ccapi-stg.paymentez.com';
  }
}
