class UserCard {
  UserCard({
    required this.id,
    required this.email,
  });

  factory UserCard.fromJson(Map<String, dynamic> json) => UserCard(
        id: json['id'] as String,
        email: json['email'] as String,
      );

  final String id;
  final String email;

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
      };
}
