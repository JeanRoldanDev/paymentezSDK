// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:paymentez_sdk/models/models.dart';
import 'package:paymentez_sdk/models/request/card/user_card.dart';
import 'package:paymentez_sdk/models/request/generate_tokenize_req.dart';
import 'package:paymentez_sdk/src/paymentez.inteface.dart';
import 'package:paymentez_sdk/utils/utils.dart';

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

  String getIdUser() {
    final currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    final currentTimeInSeconds = (currentTimeMillis / 1000).floor();
    return currentTimeInSeconds.toString();
  }

  String getSessionId() {
    // UUID
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replaceAllMapped(
      RegExp('[xy]'),
      (match) {
        final r = DateTime.now().microsecondsSinceEpoch & 0xf;
        final v = match.group(0) == 'x' ? r : (r & 0x3 | 0x8);
        return v.toRadixString(16);
      },
    );
  }

  @override
  Future<(AddCardResponse?, PaymentezError?)> addCard(
    CardRequest card,
  ) async {
    final (unixtimeResp, unixtimeErr) = await _getUnixtime();
    print(unixtimeResp);
    print(unixtimeErr);

    if (unixtimeErr != null) {
      return (null, unixtimeErr);
    }

    print('generate_tokenize');

    final model = GenerateTokenizeReq(
      locale: 'es',
      user: UserCard(id: getIdUser(), email: 'jhon@doe.com'),
      configuration: Configuration(
        defaultCountry: 'COL',
        requireBillingAddress: false,
      ),
      origin: 'SDK_JS',
      antifraud: Antifraud(
        sessionId: getSessionId(),
        // location: 'https://developers.paymentez.com',
        location: 'https://ccapi-stg.paymentez.com',

        userAgent:
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
      ),
    );

    final url = Uri.https(_host, '/v3/card/generate_tokenize/');

    print(url);
    final response = await client.post(
      url,
      headers: _headers(isServer: true, unixtime: unixtimeResp!.unixtime),
      body: json.encode(model.toJson()),
    );

    print(response);
    print(response.statusCode);
    print(response.body);
    print('fin');

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
