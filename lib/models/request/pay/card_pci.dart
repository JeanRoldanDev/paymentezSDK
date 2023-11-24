class CardPCI {
  CardPCI({
    required this.number,
    required this.holderName,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cvc,
  });

  final String number;
  final String holderName;
  final int expiryMonth;
  final int expiryYear;
  final String cvc;

  Map<String, dynamic> toJson() => {
        'number': number,
        'holder_name': holderName,
        'expiry_month': expiryMonth,
        'expiry_year': expiryYear,
        'cvc': cvc,
      };
}
