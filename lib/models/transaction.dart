import 'package:paymentez/utils/paymentez_validate.dart';

class Transaction {
  String status;
  String paymentDate;
  double amount;
  String authorizationCode;
  int installments;
  String devReference;
  int statusDetail;
  String carrierCode;
  String message;
  String id;
  String statusDetailDescription;

  Transaction.fromJson(dynamic dat) {
    status = dat['status'];
    paymentDate = dat['payment_date'];
    amount = double.parse(dat['amount'].toString());
    authorizationCode = dat['authorization_code'];
    installments = int.parse(dat['installments'].toString());
    devReference = dat['dev_reference'];
    statusDetail = int.parse(dat['status_detail'].toString());
    carrierCode = dat['carrier_code'];
    message = dat['message'];
    id = dat['id'];
    statusDetailDescription = PaymentezValidate.geStatusDetailDescription(int.parse(dat['status_detail'].toString()));
  }

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
