part of paymentez;

class _PaymentezServices extends PaymentezRepositoryInterface {
  _PaymentezServices(this.configAuthorization);
  final ConfigAuthorization configAuthorization;

  @override
  Future<PaymentezResp> getAllCards(String userId) async {
    try {
      final tokenAuth = PaymentezSecurity.getAuthToken(
        configAuthorization.appCodeSERVER,
        configAuthorization.appClientKeySERVER,
      );
      final response = await http.get(
        '${configAuthorization.getHost()}/v2/card/list?uid=$userId',
        headers: {'Auth-Token': tokenAuth.toString()},
      );
      debugPrint('**********************************************> GetAllCards');
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      return _prepareReturn(
        response: response,
        userId: userId,
        nameFunction: 'GetAllCards',
      );
    } catch (e) {
      if (configAuthorization.isLogServe) {
        _log(userId, 'GetAllCards', 500, e.toString());
      }
      return PaymentezResp(
        status: StatusResp.internalServerError,
        message: 'Servicio no disponible, inténtelo más tarde',
        data: null,
      );
    }
  }

  @override
  Future<PaymentezResp> delCard({String userId, String tokenCard}) async {
    try {
      final tokenAuth = PaymentezSecurity.getAuthToken(
        configAuthorization.appCodeSERVER,
        configAuthorization.appClientKeySERVER,
      );
      final dat = {
        'card': {'token': tokenCard},
        'user': {'id': userId}
      };
      final response = await http.post(
        '${configAuthorization.getHost()}/v2/card/delete/',
        headers: {'Auth-Token': tokenAuth.toString()},
        body: json.encode(dat),
      );
      debugPrint('************************************************> DelCard');
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      return _prepareReturn(
        response: response,
        userId: userId,
        nameFunction: 'DelCard',
      );
    } catch (e) {
      if (configAuthorization.isLogServe) {
        _log(userId, 'DelCard', 500, e.toString());
      }
      return PaymentezResp(
        status: StatusResp.internalServerError,
        message: 'Servicio no disponible, inténtelo más tarde',
        data: null,
      );
    }
  }

  @override
  Future<PaymentezResp> addCard({
    UserPay user,
    CardPay card,
    String sessionId,
  }) async {
    // try {
    final tokenAuth = PaymentezSecurity.getAuthToken(
      configAuthorization.appCode,
      configAuthorization.appClientKey,
    );
    final dat = {
      'session_id': sessionId,
      'user': {
        'id': user.id,
        'email': user.email,
        'phone': user.phone,
      },
      'card': {
        'number': card.number,
        'holder_name': card.holderName,
        'expiry_month': card.expiryMonth,
        'expiry_year': card.expiryYear,
        'cvc': card.cvc,
        // 'type': card.type,
      },
      'extra_params': {
        'date': DateTime.now().formatDate,
        'hour': DateTime.now().formatHour,
      }
    };
    final response = await http.post(
      '${configAuthorization.getHost()}/v2/card/add',
      headers: {'Auth-Token': tokenAuth.toString()},
      body: json.encode(dat),
    );
    debugPrint('***PAYMENTES==> AddCard');
    debugPrint(response.statusCode.toString());
    debugPrint(response.body);
    return _prepareReturn(
      response: response,
      userId: user.id,
      nameFunction: 'AddCard',
    );
    // } catch (e) {
    //   if (configAuthorization.isLogServe) {
    //     _log(user.id, 'AddCard', 500, e.toString());
    //   }
    //   return PaymentezResp(
    //     status: StatusResp.internalServerError,
    //     message: 'Servicio no disponible, inténtelo más tarde',
    //     data: null,
    //   );
    // }
  }

  @override
  Future<PaymentezResp> infoTransaction(
      {String userId, String transactionId}) async {
    try {
      final tokenAuth = PaymentezSecurity.getAuthToken(
        configAuthorization.appCodeSERVER,
        configAuthorization.appClientKeySERVER,
      );
      final response = await http.get(
        '${configAuthorization.getHost()}/v2/transaction/$transactionId',
        headers: {'Auth-Token': tokenAuth.toString()},
      );
      debugPrint(
          '************************************************> InfoTransaction');
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      return _prepareReturn(
        response: response,
        userId: userId,
        nameFunction: 'InfoTransaction',
      );
    } catch (e) {
      if (configAuthorization.isLogServe) {
        _log(userId, 'InfoTransaction', 500, e.toString());
      }
      return PaymentezResp(
        status: StatusResp.internalServerError,
        message: 'Servicio no disponible, inténtelo más tarde',
        data: null,
      );
    }
  }

  @override
  Future<PaymentezResp> verify(
      {String userId,
      String transactionId,
      String type,
      String value,
      bool moreInfo = true}) async {
    try {
      final tokenAuth = PaymentezSecurity.getAuthToken(
        configAuthorization.appCodeSERVER,
        configAuthorization.appClientKeySERVER,
      );
      final dat = {
        'user': {'id': userId},
        'transaction': {'id': transactionId},
        'type': type,
        'value': value,
        'more_info': moreInfo
      };
      final response = await http.post(
        '${configAuthorization.getHost()}/v2/transaction/verify',
        headers: {'Auth-Token': tokenAuth.toString()},
        body: json.encode(dat),
      );

      debugPrint('*******************************************> Verify_$type');
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      return _prepareReturn(
        response: response,
        userId: userId,
        nameFunction: 'Verify_$type',
      );
    } catch (e) {
      if (configAuthorization.isLogServe) {
        _log(userId, 'Verify_$type', 500, e.toString());
      }
      return PaymentezResp(
        status: StatusResp.internalServerError,
        message: 'Servicio no disponible, inténtelo más tarde',
        data: null,
      );
    }
  }

  @override
  Future<PaymentezResp> debitToken(
      {UserPay user, CardPay card, OrderPay orderPay}) async {
    try {
      final tokenAuth = PaymentezSecurity.getAuthToken(
        configAuthorization.appCodeSERVER,
        configAuthorization.appClientKeySERVER,
      );
      final dat = {
        'card': {'token': card.token},
        'user': {'id': user.id, 'email': user.email},
        'order': {
          'amount': orderPay.amount,
          'description': orderPay.description,
          'dev_reference': orderPay.devReference,
          'vat': orderPay.vat,
          orderPay.installments == null ? '' : 'installments':
              orderPay.installments,
          orderPay.installmentsType == null ? '' : 'installments_type':
              orderPay.installmentsType,
          orderPay.taxableAmount == null ? '' : 'taxable_amount':
              orderPay.taxableAmount,
          orderPay.taxPercentage == null ? '' : 'tax_percentage':
              orderPay.taxPercentage
        },
      };
      final response = await http.post(
        '${configAuthorization.getHost()}/v2/transaction/debit/',
        headers: {'Auth-Token': tokenAuth.toString()},
        body: json.encode(dat),
      );
      debugPrint(
          '************************************************> DebitToken');
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      return _prepareReturn(
        response: response,
        userId: user.id,
        nameFunction: 'DebitToken',
      );
    } catch (e) {
      if (configAuthorization.isLogServe) {
        _log(user.id, 'DebitToken', 500, e.toString());
      }
      return PaymentezResp(
        status: StatusResp.internalServerError,
        message: 'Servicio no disponible, inténtelo más tarde',
        data: null,
      );
    }
  }

  //=================================================
  PaymentezResp _prepareReturn(
      {@required http.Response response,
      @required String userId,
      @required String nameFunction}) {
    if (response.statusCode == 200) {
      if (configAuthorization.isLogServe) {
        _log(userId, nameFunction, 200, response.body);
      }
      return PaymentezResp.fromJson(response.body);
    }

    if (response.statusCode == 400 ||
        response.statusCode == 401 ||
        response.statusCode == 403) {
      if (configAuthorization.isLogServe) {
        _log(userId, nameFunction, response.statusCode, response.body);
      }
      return PaymentezResp.fromJson(response.body);
    }

    if (response.statusCode == 500 || response.statusCode == 509) {
      if (configAuthorization.isLogServe) {
        _log(userId, nameFunction, 500, response.body);
      }
      return PaymentezResp(
        status: StatusResp.internalServerError,
        message: 'Algo paso, vuelve a intentarlo',
        data: null,
      );
    }

    if (response.statusCode == 503) {
      if (configAuthorization.isLogServe) {
        _log(userId, nameFunction, 503, response.body);
      }
      return PaymentezResp(
        status: StatusResp.serviceUnavailable,
        message: 'Estamos temporalmente fuera de línea por mantenimiento',
        data: null,
      );
    } else {
      if (configAuthorization.isLogServe) {
        _log(userId, nameFunction, response.statusCode, response.body);
      }
      return PaymentezResp(
        status: StatusResp.stranger,
        message: 'Algo paso, vuelve a intentarlo',
        data: null,
      );
    }
  }

  void _log(String userId, String nameFunction, int status, String response) {
    final data = Map<String, dynamic>.from({
      'userId': userId,
      'typeFun': nameFunction,
      'status': status,
      'data': response,
      'urlLogServe': configAuthorization.urlLogServe,
      'headers': configAuthorization.headers,
      'enableTracking': configAuthorization.enableTracking,
    });
    compute(_sendLogErrors, data);
  }

  static Future<void> _sendLogErrors(Map<String, dynamic> params) async {
    debugPrint('==============================log===========================');
    try {
      var ipv4 = '-';
      var ipv6 = '-';
      if (params['enableTracking']) {
        ipv4 = await Ipify.ipv4(format: Format.JSON);
        ipv6 = await Ipify.ipv64(format: Format.JSON);
      }
      final dat = {
        'user_fk': params['userId'].toString(),
        'typeFun': params['typeFun'].toString(),
        'status': params['status'],
        'data': params['data'],
        'info': {
          'so': Platform.isAndroid ? 'ANDROID' : 'IOS',
          'numberOfProcessors': Platform.numberOfProcessors,
          'packageConfig': Platform.packageConfig,
          'operatingSystem': Platform.operatingSystem,
          'operatingSystemVersion': Platform.operatingSystemVersion,
          'version': Platform.version,
          'ipv4': ipv4,
          'ipv6': ipv6,
        }
      };
      final response = await http.post(
        params['urlLogServe'],
        headers: params['headers'],
        body: json.encode(dat),
      );
      debugPrint(response.statusCode.toString());
    } catch (e) {
      debugPrint('ERROR LOG: $e');
    }
  }
}
