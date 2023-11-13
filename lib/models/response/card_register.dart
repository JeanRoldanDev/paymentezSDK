class CardRegister {
  CardRegister({
    required this.bin,
    required this.status,
    required this.token,
    required this.holderName,
    required this.expiryYear,
    required this.expiryMonth,
    required this.type,
    required this.number,
    this.transactionReference,
  });

  factory CardRegister.fromJson(Map<String, dynamic> json) {
    final transactionReference = json['transaction_reference'] == null
        ? null
        : json['transaction_reference'] as String;

    return CardRegister(
      bin: json['bin'] as String,
      status: json['status'] as String,
      token: json['token'] as String,
      holderName: json['holder_name'] as String,
      expiryYear: json['expiry_year'] as String,
      expiryMonth: json['expiry_month'] as String,
      transactionReference: transactionReference,
      type: json['type'] as String,
      number: json['number'] as String,
    );
  }

  final String bin;
  final String status;
  final String token;
  final String holderName;
  final String expiryYear;
  final String expiryMonth;
  final String? transactionReference;
  final String type;
  final String number;

  Map<String, dynamic> toJson() => {
        'bin': bin,
        'status': status,
        'token': token,
        'holder_name': holderName,
        'expiry_year': expiryYear,
        'expiry_month': expiryMonth,
        'transaction_reference': transactionReference,
        'type': type,
        'number': number,
      };
}
