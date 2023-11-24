class AddCardRequest {
  AddCardRequest({
    required this.user,
    required this.card,
  });

  UserCard user;
  NewCard card;

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'card': card.toJson(),
      };
}

class NewCard {
  NewCard({
    required this.number,
    required this.holderName,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cvc,
  });

  String number;
  String holderName;
  int expiryMonth;
  int expiryYear;
  String cvc;

  Map<String, dynamic> toJson() => {
        'number': number,
        'holder_name': holderName,
        'expiry_month': expiryMonth,
        'expiry_year': expiryYear,
        'cvc': cvc,
      };
}

class UserCard {
  UserCard({
    required this.id,
    required this.email,
  });

  String id;
  String email;

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
      };
}
