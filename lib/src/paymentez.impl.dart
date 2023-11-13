import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:paymentez/models/models.dart';
import 'package:paymentez/src/paymentez.inteface.dart';
import 'package:paymentez/utils/utils.dart';

class PaymentezImpl implements IPaymentez {
  PaymentezImpl({
    required this.client,
    this.serverApplicationCode = '',
    this.serverAppKey = '',
    this.clientApplicationCode = '',
    this.clientAppKey = '',
    this.isProd = false,
  });

  final String serverApplicationCode;
  final String serverAppKey;
  final String clientApplicationCode;
  final String clientAppKey;
  final bool isProd;

  final http.Client client;

  String get _host =>
      isProd ? 'ccapi.paymentez.com ' : 'ccapi-stg.paymentez.com';

  Map<String, String> _headers({bool isServer = false}) {
    final authToken = PaymentezSecurity.getAuthToken(
      isServer ? serverApplicationCode : clientApplicationCode,
      isServer ? serverAppKey : clientAppKey,
    );
    return {'Auth-Token': authToken, 'Content-Type': 'application/json'};
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
      final cardsResponse = CardsResponse.fromJson(body);
      return (cardsResponse, null);
    }

    return (null, PaymentezError.fromJson(body));
  }

  @override
  Future<(AddCardResponse?, PaymentezError?)> addCard(AddCardRequest newCard) {
    throw UnimplementedError();
  }
}
