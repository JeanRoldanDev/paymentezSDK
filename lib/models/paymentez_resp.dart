import 'dart:convert';
import 'package:paymentez/models/cardPay.dart';
import 'package:paymentez/models/transaction.dart';

enum StatusResp {
  ///200 Solicitud fue ejecutada con éxito
  success,

  ///404: Solicitud incorrecta: por ejemplo, json no está bien formateado,
  ///falta el tipo de datos o los parámetros.
  notFound,

  /// si recibe un StatusResp puede estar dentro de los errores documentados
  /// en paymentez entre ellos:
  /// 400	Solicitud incorrecta: por ejemplo, json no está bien formateado,
  /// falta el tipo de datos o los parámetros.
  /// 401	No autorizado: su auth_token es incorrecto o está caducado.
  /// 403	Prohibido: por varias razones, por ejemplo, tarjeta no válida,
  /// tarjeta ya agregada, operador no configurado o operación no permitida.
  conflict,

  /// 500	Error interno del servidor: tuvimos un problema con nuestro servidor.
  internalServerError,

  /// 503	Servicio no disponible: estamos temporalmente fuera de línea por
  /// mantenimiento. Por favor, inténtelo de nuevo más tarde.
  serviceUnavailable,

  /// ERRORES PROVOCADOS AL PROPOSITO:
  /// 429: while con true para verficar la alta disponibilidad
  /// y balanceo de carga transaccional 'ofrecido' :
  /// EXPERIENCIAS:
  /// 451: tuvimos una 'LINDA' experiencia con una tarjeta de credito
  /// internacional proveniente de Africa (Ibhange laseGhana).
  /// Lugares que otras personas reportaron:
  /// Kabul de Afganistán, Duala de Carrmerun, Qingdao de China
  /// NO SABEMOS
  /// 410, 407, 503, 506, 408, 302, 416, 421
  stranger,
}

class PaymentezResp {
  PaymentezResp({this.status, this.message, this.data});

  factory PaymentezResp.fromJson(dynamic dat) {
    final map = Map<String, dynamic>.from(json.decode(dat));
    StatusResp status;
    String message;
    dynamic data;

    if (map.containsKey('cards')) {
      final lista = List.from(map['cards']);
      if (lista.isEmpty) {
        status = StatusResp.notFound;
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
      final myStatus = _getStatusError(map['error']);
      switch (myStatus) {
        case StatusRespPaymentez.cardAlreadyAdded:
          status = StatusResp.conflict;
          message = 'Si desea actualizar la tarjeta, primero elimínela.';
          data = null;
          break;
        case StatusRespPaymentez.invalidDateOfValidity:
          status = StatusResp.conflict;
          message = 'Fecha de validez no válida.';
          data = null;
          break;
        case StatusRespPaymentez.cardInvalidNumber:
          status = StatusResp.conflict;
          message = 'Escribe un número válido de tarjeta.';
          data = null;
          break;
        case StatusRespPaymentez.badRequest:
          status = StatusResp.conflict;
          message = 'El tipo de tarjeta no es correcto o no es soportada';
          data = null;
          break;
        case StatusRespPaymentez.validationError:
          status = StatusResp.conflict;
          message = 'Escribe un número válido de tarjeta.';
          data = null;
          break;
        case StatusRespPaymentez.invalidToken:
          status = StatusResp.conflict;
          message = 'Token Invalido';
          data = null;
          break;
        case StatusRespPaymentez.transactionExceededApp:
          status = StatusResp.conflict;
          message =
              '''Se superó el número de transacciones mostradas para esta aplicación''';
          data = null;
          break;
        case StatusRespPaymentez.verificationError:
          status = StatusResp.conflict;
          message = 'Error en la verificación';
          data = null;
          break;
        case StatusRespPaymentez.stranger:
          status = StatusResp.conflict;
          message = 'Verifica el número de la tajeta';
          data = null;
          break;
        default:
          status = StatusResp.conflict;
          message = 'Vuelve a intentarlo';
          data = null;
      }
    }

    return PaymentezResp(
      status: status,
      message: message,
      data: data,
    );
  }

  final StatusResp status;
  final String message;
  final dynamic data;

  static StatusRespPaymentez _getStatusError(dynamic error) {
    final type = error['type'].toString().split(':')[0].toString();
    final description = error['description'].toString();
    if (type == 'Card already added') {
      return StatusRespPaymentez.cardAlreadyAdded;
    }
    if (type == 'OperationNotAllowedError' &&
        description == 'Invalid date of validity') {
      return StatusRespPaymentez.invalidDateOfValidity;
    }
    if (type == 'Escribe un número válido de tarjeta.') {
      return StatusRespPaymentez.cardInvalidNumber;
    }
    if (type == 'BadRequest') {
      return StatusRespPaymentez.badRequest;
    }
    if (type == 'ValidationError') {
      return StatusRespPaymentez.validationError;
    }
    if (type == 'Invalid Token') {
      return StatusRespPaymentez.invalidToken;
    }
    if (type == 'Number of showed transaction exceeded for this application') {
      return StatusRespPaymentez.transactionExceededApp;
    } else {
      final newType = error['type'].toString();
      final jsonData = Map.from(json.decode(newType.replaceAll("'", '"')));
      if (jsonData.containsKey('code') && jsonData.containsKey('description')) {
        if (jsonData['code'].toString() == '7' &&
            jsonData['description'].toString() == 'VerificationError') {
          return StatusRespPaymentez.verificationError;
        } else {
          return StatusRespPaymentez.stranger;
        }
      } else {
        return StatusRespPaymentez.stranger;
      }
    }
  }
}

enum StatusRespPaymentez {
  /// HTTP CODE 200: success
  valid,

  /// HTTP CODE 404: not_found
  notFound,

  /// HTTP CODE 400: conflict
  validationError,

  /// HTTP CODE 401: conflict
  invalidToken,

  /// HTTP CODE 403: conflict
  invalidDateOfValidity,
  cardAlreadyAdded,
  cardInvalidNumber,
  verificationError,
  transactionExceededApp,

  /// HTTP CODE 500: internalServerError
  badRequest,
  notAuthorized,
  rejectedByKount,
  internalServerError,
  cardsNone,

  /// ERRORES NO REPORTADOS POR NINGUN LADO
  stranger
}
