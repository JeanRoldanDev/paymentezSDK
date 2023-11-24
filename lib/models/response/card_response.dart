import 'package:paymentez_sdk/models/response/card_register.dart';
import 'package:paymentez_sdk/utils/dynamic_ext.dart';

class CardsResponse {
  CardsResponse({required this.cards, required this.resultSize});

  factory CardsResponse.fromJson(Map<String, dynamic> json) {
    final data = json.getList('cards');

    final resp = <CardRegister>[];
    for (final el in data) {
      final itemJson = el as Map<String, dynamic>;
      final model = CardRegister.fromJson(itemJson);
      resp.add(model);
    }

    return CardsResponse(
      cards: resp,
      resultSize: json.getInt('result_size'),
    );
  }

  final List<CardRegister> cards;
  final int resultSize;
}
