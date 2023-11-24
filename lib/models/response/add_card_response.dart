import 'package:paymentez/models/response/card_register.dart';
import 'package:paymentez/utils/utils.dart';

class AddCardResponse {
  AddCardResponse({
    required this.card,
  });

  factory AddCardResponse.fromJson(Map<String, dynamic> json) =>
      AddCardResponse(
        card: CardRegister.fromJson(json.getMap('card')),
      );

  CardRegister card;

  Map<String, dynamic> toJson() => {
        'card': card.toJson(),
      };
}
