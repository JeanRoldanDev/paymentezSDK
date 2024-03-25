// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:paymentez_sdk/models/models.dart';
import 'package:paymentez_sdk/models/request/generate_tokenize_req.dart';
import 'package:paymentez_sdk/src/paymentez.inteface.dart';
import 'package:paymentez_sdk/utils/utils.dart';
import 'package:paymentez_sdk/utils/utils_browser.dart';

class PaymentezImpl implements IPaymentez {
  PaymentezImpl({
    required this.client,
    required this.serverApplicationCode,
    required this.serverAppKey,
    required this.clientApplicationCode,
    required this.clientAppKey,
    this.isProd = false,
    this.isPCI = false,
  });

  final String serverApplicationCode;
  final String serverAppKey;
  final String clientApplicationCode;
  final String clientAppKey;

  final bool isProd;
  final bool isPCI;

  final http.Client client;

  String get _host =>
      isProd ? 'ccapi.paymentez.com' : 'ccapi-stg.paymentez.com';

  String get _hostMicro =>
      isProd ? 'pg-micros.paymentez.com' : 'pg-micros-stg.paymentez.com';

  Map<String, String> _headers({bool isServer = false, int? unixtime}) {
    var appCode = isPCI ? serverApplicationCode : clientApplicationCode;
    var appKey = isPCI ? serverAppKey : clientAppKey;

    if (!isPCI && isServer) {
      appCode = serverApplicationCode;
      appKey = serverAppKey;
    }

    final authToken = PaymentezSecurity.getAuthToken(
      appCode: appCode,
      appKey: appKey,
      unixtime: unixtime,
    );
    return {'Auth-Token': authToken, 'Content-Type': 'application/json'};
  }

  @override
  Future<(AddCardResponse?, PaymentezError?)> addCardCC(
    CardPCIRequest card,
  ) async {
    final url = Uri.https(_host, '/v2/card/add');
    final response = await client.post(
      url,
      headers: _headers(),
      body: json.encode(card.toJson()),
    );

    final body = json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == HttpStatus.ok) {
      final result = AddCardResponse.fromJson(body);
      return (result, null);
    }

    return (null, PaymentezError.fromJson(body));
  }

  @override
  Future<(CardsResponse?, PaymentezError?)> getAllCards(
    String userID,
  ) async {
    final url = Uri.https(_host, '/v2/card/list', {'uid': userID});
    final response = await client.get(
      url,
      headers: _headers(isServer: true),
    );

    final body = json.decode(response.body) as Map<String, dynamic>;

    if (response.statusCode == HttpStatus.ok) {
      final result = CardsResponse.fromJson(body);
      return (result, null);
    }

    return (null, PaymentezError.fromJson(body));
  }

  @override
  Future<(AddCardResponse?, PaymentezError?)> addCard(
    CardRequest card,
  ) async {
    final (unixtimeResp, unixtimeErr) = await _getUnixtime();
    if (unixtimeErr != null) {
      return (null, unixtimeErr);
    }

    final model = GenerateTokenizeReq(
      locale: card.locale,
      user: card.user,
      configuration: Configuration(
        defaultCountry: 'ECU',
        requireBillingAddress: card.requireBillingAddress,
      ),
      origin: 'SDK_JS',
      antifraud: Antifraud(
        sessionId: PaymentezSecurity.getSessionId(),
        location: Uri.https(_host).toString(),
        userAgent: UtilsBrowser.getUserAgent(card.userAgent),
      ),
    );

    final url = Uri.https(_host, '/v3/card/generate_tokenize/');

    final response = await client.post(
      url,
      headers: _headers(isServer: true, unixtime: unixtimeResp!.unixtime),
      body: json.encode(model.toJson()),
    );

    final body = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == HttpStatus.ok) {
      final result = AddCardResponse.fromJson(body);
      return (result, null);
    }

    return (null, PaymentezError.fromJson(body));
  }

  Future<(UnixtimeResponse?, PaymentezError?)> _getUnixtime() async {
    final url = Uri.https(_hostMicro, '/v1/unixtime');

    final response = await client.get(
      url,
      headers: _headers(isServer: true),
    );

    final body = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == HttpStatus.ok) {
      final result = UnixtimeResponse.fromJson(body);
      return (result, null);
    }

    return (null, PaymentezError.fromJson(body));
  }

  @override
  Future<(DeleteCardResponse?, PaymentezError?)> deleteCard(
    DeleteCardRequest deleteCardRequest,
  ) async {
    final url = Uri.https(_host, '/v2/card/delete');

    final response = await client.post(
      url,
      headers: _headers(isServer: true),
      body: json.encode(deleteCardRequest.toJson()),
    );

    final body = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == HttpStatus.ok) {
      final result = DeleteCardResponse.fromJson(body);
      return (result, null);
    }

    return (null, PaymentezError.fromJson(body));
  }

  @override
  Future<(PayResponse?, PaymentezError?)> debit(PayRequest payRequest) async {
    final url = Uri.https(_host, '/v2/transaction/debit');

    final response = await client.post(
      url,
      headers: _headers(isServer: true),
      body: json.encode(payRequest.toJson()),
    );

    final body = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == HttpStatus.ok) {
      final result = PayResponse.fromJson(body);
      return (result, null);
    }

    return (null, PaymentezError.fromJson(body));
  }

  @override
  Future<(PayResponse?, PaymentezError?)> debitCC(
    PayPCIRequest payPCIRequest,
  ) async {
    final url = Uri.https(_host, '/v2/transaction/debit_cc');

    final response = await client.post(
      url,
      headers: _headers(),
      body: json.encode(payPCIRequest.toJson()),
    );

    final body = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == HttpStatus.ok) {
      final result = PayResponse.fromJson(body);
      return (result, null);
    }

    return (null, PaymentezError.fromJson(body));
  }

  @override
  Future<(RefundResponse?, PaymentezError?)> refund(
    RefundRequest payPCIRequest,
  ) async {
    final url = Uri.https(_host, '/v2/transaction/refund');

    final response = await client.post(
      url,
      headers: _headers(),
      body: json.encode(payPCIRequest.toJson()),
    );

    final body = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == HttpStatus.ok) {
      final result = RefundResponse.fromJson(body);
      return (result, null);
    }

    return (null, PaymentezError.fromJson(body));
  }
}
