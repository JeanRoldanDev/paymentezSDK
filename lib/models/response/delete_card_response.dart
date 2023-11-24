class DeleteCardResponse {
  DeleteCardResponse({
    required this.message,
  });

  factory DeleteCardResponse.fromJson(Map<String, dynamic> json) =>
      DeleteCardResponse(
        message: json['message'] as String,
      );

  final String message;

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
