import 'dart:convert';
import 'package:paymentez/models/cardPay.dart';
import 'package:paymentez/models/transaction.dart';

enum StatusResp {
  success, //200
  not_found, //404
  conflict, // 409
  internalServerError, //500
  serviceUnavailable, //509

  /// ERRORES PROVOCADOS AL PROPOSITO:
  /// 429: while con true para verficar la alta disponibilidad
  /// y balanceo de carga transaccional 'ofrecido' :v
  /// EXPERIENCIAS:
  /// 451: tuvimos una 'LINDA' experiencia con una tarjeta de credito
  /// internacional proveniente de Africa (Ibhange laseGhana).
  /// Lugares que otras personas reportaron:
  /// Kabul de Afganistán, Duala de Carrmerun, Qingdao de China
  /// NO SABEMOS
  /// 410, 407, 503, 506, 408, 302, 416, 421
  stranger,
}

enum StatusRespPaymentez {
  /// HTTP CODE 200: success
  Valid,

  /// HTTP CODE 404: not_found
  NotFon,

  /// HTTP CODE 400: conflict
  ValidationError,

  /// HTTP CODE 401: conflict
  Invalid_Token,

  /// HTTP CODE 403: conflict
  Invalid_date_of_validity,
  Card_already_added,
  Card_invalid_number,
  VerificationError,
  TransactionExceededApp,

  /// HTTP CODE 500: internalServerError
  BadRequest,
  Not_Authorized,
  RejectedByKount,
  Internal_Server_Error,
  Cards_None,

  /// ERRORES NO REPORTADOS POR NINGUN LADO
  Stranger
}

class PaymentezResp {
  StatusResp status;
  String message;
  dynamic data;

  PaymentezResp({this.status, this.message, this.data});

  PaymentezResp.fromJson(dynamic dat) {
    Map<String, dynamic> map = json.decode(dat);

    if (map.containsKey('cards')) {
      List lista = map['cards'];
      if (lista.length == 0) {
        status = StatusResp.not_found;
        message = 'No tienen ninguna tarjeta registrada';
        data = [];
      } else {
        status = StatusResp.success;
        message = 'Datos encontrados';
        data = lista.map((element) => CardPay.fromJson(element)).toList();
      }
    }

    if (map.containsValue('card deleted') && map.containsKey('message')) {
      status = StatusResp.success;
      message = 'Tarjeta Eliminada con éxito';
      data = null;
    }

    if (map.containsKey('card')) {
      status = StatusResp.success;
      message = map['card']['message'].toString();
      data = CardPay.fromJson(map['card']);
    }

    if (map.containsKey('transaction') && map.containsKey('card')) {
      final transaction = Transaction.fromJson(map['transaction']);
      status = StatusResp.success;
      message = transaction.statusDetailDescription;
      data = [CardPay.fromJson(map['card']), transaction];
    }

    if (map.containsKey('error')) {
      StatusRespPaymentez myStatus = _getStatusError(map['error']);
      if (myStatus == StatusRespPaymentez.Card_already_added) {
        status = StatusResp.conflict;
        message = 'Si desea actualizar la tarjeta, primero elimínela.';
        data = null;
      }
      if (myStatus == StatusRespPaymentez.Invalid_date_of_validity) {
        status = StatusResp.conflict;
        message = 'Fecha de validez no válida.';
        data = null;
      }
      if (myStatus == StatusRespPaymentez.Card_invalid_number) {
        status = StatusResp.conflict;
        message = 'Escribe un número válido de tarjeta.';
        data = null;
      }
      if (myStatus == StatusRespPaymentez.BadRequest) {
        status = StatusResp.conflict;
        message = 'El tipo de tarjeta no es correcto o no es soportada';
        data = null;
      }

      if (myStatus == StatusRespPaymentez.ValidationError) {
        status = StatusResp.conflict;
        message = 'No coincide con: BY_AMOUNT, BY_AUTH_CODE, BY_OTP, BY_CRES, AUTHENTICATION_CONTINUE.';
        data = null;
      }

      if (myStatus == StatusRespPaymentez.Invalid_Token) {
        status = StatusResp.conflict;
        message = 'Token Invalido';
        data = null;
      }

      if (myStatus == StatusRespPaymentez.TransactionExceededApp) {
        status = StatusResp.conflict;
        message = 'Se superó el número de transacciones mostradas para esta aplicación';
        data = null;
      }

      if (myStatus == StatusRespPaymentez.VerificationError) {
        status = StatusResp.conflict;
        message = 'Error en la verificación';
        data = null;
      }

      if (myStatus == StatusRespPaymentez.Stranger) {
        status = StatusResp.conflict;
        message = 'Verifica el número de la tajeta';
        data = null;
      }
    }
  }

  StatusRespPaymentez _getStatusError(dynamic error) {
    String type = error['type'].toString().split(':')[0];
    String description = error['description'].toString();
    if (type == 'Card already added') {
      return StatusRespPaymentez.Card_already_added;
    }
    if (type == 'OperationNotAllowedError' && description == 'Invalid date of validity') {
      return StatusRespPaymentez.Invalid_date_of_validity;
    }
    if (type == 'Escribe un número válido de tarjeta.') {
      return StatusRespPaymentez.Card_invalid_number;
    }
    if (type == 'BadRequest') {
      return StatusRespPaymentez.BadRequest;
    }
    if (type == 'ValidationError') {
      return StatusRespPaymentez.ValidationError;
    }
    if (type == 'Invalid Token') {
      return StatusRespPaymentez.Invalid_Token;
    }
    if (type == 'Number of showed transaction exceeded for this application') {
      return StatusRespPaymentez.TransactionExceededApp;
    } else {
      final newType = error['type'].toString();
      final jsonData = Map.from(json.decode(newType.replaceAll("'", '"')));
      if (jsonData.containsKey('code') && jsonData.containsKey('description')) {
        if (jsonData['code'].toString() == '7' && jsonData['description'].toString() == 'VerificationError') {
          return StatusRespPaymentez.VerificationError;
        } else {
          return StatusRespPaymentez.Stranger;
        }
      } else {
        return StatusRespPaymentez.Stranger;
      }
    }
  }
}
