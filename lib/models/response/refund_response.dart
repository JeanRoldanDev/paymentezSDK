class RefundResponse {
  RefundResponse({
    required this.status,
    required this.detail,
  });

  factory RefundResponse.fromJson(Map<String, dynamic> json) => RefundResponse(
        status: json['status'] as String,
        detail: json['detail'] as String,
      );

  final String status;
  final String detail;

  Map<String, dynamic> toJson() => {
        'status': status,
        'detail': detail,
      };
}
