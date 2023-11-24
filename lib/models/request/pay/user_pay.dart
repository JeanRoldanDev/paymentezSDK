class UserPay {
  UserPay({
    required this.id,
    required this.email,
    required this.phone,
  });

  final String id;
  final String email;
  final String phone;

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'phone': phone,
      };
}
