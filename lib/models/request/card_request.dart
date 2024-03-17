import 'package:paymentez_sdk/models/request/card/user_card.dart';

class CardRequest {
  CardRequest({
    required this.user,
  });

  UserCard user;

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
      };
}
