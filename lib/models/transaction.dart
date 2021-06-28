import 'package:paymentez/utils/paymentez_validate.dart';

class Transaction {
  Transaction({
    this.status,
    this.paymentDate,
    this.amount,
    this.authorizationCode,
    this.installments,
    this.devReference,
    this.statusDetail,
    this.carrierCode,
    this.message,
    this.id,
    this.statusDetailDescription,
  });

  factory Transaction.fromJson(dynamic dat) {
    return Transaction(
      status: dat['status'],
      paymentDate: dat['payment_date'],
      amount: double.parse(dat['amount'].toString()),
      authorizationCode: dat['authorization_code'],
      installments: int.parse(dat['installments'].toString()),
      devReference: dat['dev_reference'],
      statusDetail: int.parse(dat['status_detail'].toString()),
      carrierCode: dat['carrier_code'],
      message: dat['message'],
      id: dat['id'],
      statusDetailDescription: PaymentezValidate.geStatusDetailDescription(
        int.parse(dat['status_detail'].toString()),
      ),
    );
  }

  final String status;
  final String paymentDate;
  final double amount;
  final String authorizationCode;
  final int installments;
  final String devReference;
  final int statusDetail;
  final String carrierCode;
  final String message;
  final String id;
  final String statusDetailDescription;

  Map<String, dynamic> toJson() => {
        'status': status,
        'payment_date': paymentDate,
        'amount': amount,
        'authorization_code': authorizationCode,
        'installments': installments,
        'dev_reference': devReference,
        'status_detail': statusDetail,
        'carrier_code': carrierCode,
        'message': message,
        'id': id,
        'statusDetailDescription': statusDetailDescription,
      };
}
