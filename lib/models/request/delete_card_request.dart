class DeleteCardRequest {
  DeleteCardRequest({
    required this.cardToken,
    required this.userId,
  });

  String cardToken;
  String userId;

  Map<String, dynamic> toJson() => {
        'card': <String, dynamic>{
          'token': cardToken,
        },
        'user': <String, dynamic>{
          'id': userId,
        }
      };
}
