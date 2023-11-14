import 'package:paymentez/models/request/pay/installments.dart';
import 'package:paymentez/models/request/pay/installments_type.dart';

class OrderPay {
  OrderPay({
    required this.taxPercentage,
    required this.taxableAmount,
    required this.vat,
    required this.amount,
    required this.description,
    required this.devReference,
    this.installments,
    this.installmentsType,
  });

  final int taxPercentage;
  final double taxableAmount;
  final double vat;
  final double amount;
  final String description;
  final Installments? installments;
  final InstallmentsType? installmentsType;
  final String devReference;

  Map<String, dynamic> toJson() => {
        'tax_percentage': taxPercentage,
        'taxable_amount': taxableAmount,
        'vat': vat,
        'amount': amount,
        'description': description,
        if (installments != null) 'installments': installments!.value,
        if (installmentsType != null)
          'installments_type': installmentsType!.value,
        'dev_reference': devReference,
      };
}
