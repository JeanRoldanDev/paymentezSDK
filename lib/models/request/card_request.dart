import 'package:paymentez_sdk/models/request/card/user_card.dart';

class CardRequest {
  CardRequest({
    required this.user,
    required this.locale,
    required this.requireBillingAddress,
    this.userAgent,
  });

  final UserCard user;
  final String locale;
  final bool requireBillingAddress;
  final String? userAgent;

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
      };
}
