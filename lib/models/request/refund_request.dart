class RefundRequest {
  RefundRequest({
    required this.transactionID,
  });

  String transactionID;

  Map<String, dynamic> toJson() => {
        'transaction': <String, dynamic>{
          'id': transactionID,
        },
      };
}
