import 'package:paymentez_sdk/models/response/card_register.dart';
import 'package:paymentez_sdk/utils/utils.dart';

class AddCardResponse {
  AddCardResponse({
    this.card,
    this.tokenizeURL,
  });

  factory AddCardResponse.fromJson(Map<String, dynamic> json) {
    CardRegister? card;
    String? tokenizeURL;

    if (json.containsKey('card')) {
      card = CardRegister.fromJson(json.getMap('card'));
    }

    if (json.containsKey('tokenize_url')) {
      tokenizeURL = json['tokenize_url'] as String;
    }

    return AddCardResponse(
      card: card,
      tokenizeURL: tokenizeURL,
    );
  }

  final CardRegister? card;
  final String? tokenizeURL;

  Map<String, dynamic> toJson() => {
        if (card != null) 'card': card!.toJson(),
        if (tokenizeURL != null) 'tokenize_url': tokenizeURL.toString(),
      };
}
