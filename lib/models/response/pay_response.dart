import 'package:paymentez/utils/utils.dart';

class PayResponse {
  PayResponse({
    required this.transaction,
    required this.card,
  });

  factory PayResponse.fromJson(Map<String, dynamic> json) => PayResponse(
        transaction: Transaction.fromJson(json.getMap('transaction')),
        card: CardResp.fromJson(json.getMap('card')),
      );

  Transaction transaction;
  CardResp card;

  Map<String, dynamic> toJson() => {
        'transaction': transaction.toJson(),
        'card': card.toJson(),
      };
}

class CardResp {
  CardResp({
    required this.bin,
    required this.status,
    required this.token,
    required this.expiryYear,
    required this.expiryMonth,
    required this.transactionReference,
    required this.type,
    required this.number,
    required this.origin,
  });

  factory CardResp.fromJson(Map<String, dynamic> json) => CardResp(
        bin: json['bin'] as String,
        status: json['status'] as String,
        token: json['token'] as String,
        expiryYear: json['expiry_year'] as String,
        expiryMonth: json['expiry_month'] as String,
        transactionReference: json['transaction_reference'] as String,
        type: json['type'] as String,
        number: json['number'] as String,
        origin: json['origin'] as String,
      );

  final String bin;
  final String status;
  final String token;
  final String expiryYear;
  final String expiryMonth;
  final String transactionReference;
  final String type;
  final String number;
  final String origin;

  Map<String, dynamic> toJson() => {
        'bin': bin,
        'status': status,
        'token': token,
        'expiry_year': expiryYear,
        'expiry_month': expiryMonth,
        'transaction_reference': transactionReference,
        'type': type,
        'number': number,
        'origin': origin,
      };
}

class Transaction {
  Transaction({
    required this.status,
    required this.lotNumber,
    required this.authorizationCode,
    required this.statusDetail,
    required this.message,
    required this.id,
    required this.paymentDate,
    required this.paymentMethodType,
    required this.devReference,
    required this.carrierCode,
    required this.productDescription,
    required this.currentStatus,
    required this.amount,
    required this.carrier,
    required this.installments,
    required this.traceNumber,
    required this.installmentsType,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        status: json['status'] as String,
        lotNumber: json['lot_number'] as String,
        authorizationCode: json['authorization_code'] as String,
        statusDetail: json.getInt('status_detail'),
        message: json['message'] as String,
        id: json['id'] as String,
        paymentDate: json.getDateTime('payment_date'),
        paymentMethodType: json['payment_method_type'] as String,
        devReference: json['dev_reference'] as String,
        carrierCode: json['carrier_code'] as String,
        productDescription: json['product_description'] as String,
        currentStatus: json['current_status'] as String,
        amount: json.getInt('amount'),
        carrier: json['carrier'] as String,
        installments: json.getInt('installments'),
        traceNumber: json['trace_number'] as String,
        installmentsType: json['installments_type'] as String,
      );

  final String status;
  final String lotNumber;
  final String authorizationCode;
  final int statusDetail;
  final String message;
  final String id;
  final DateTime paymentDate;
  final String paymentMethodType;
  final String devReference;
  final String carrierCode;
  final String productDescription;
  final String currentStatus;
  final int amount;
  final String carrier;
  final int installments;
  final String traceNumber;
  final String installmentsType;

  Map<String, dynamic> toJson() => {
        'status': status,
        'lot_number': lotNumber,
        'authorization_code': authorizationCode,
        'status_detail': statusDetail,
        'message': message,
        'id': id,
        'payment_date': paymentDate.toIso8601String(),
        'payment_method_type': paymentMethodType,
        'dev_reference': devReference,
        'carrier_code': carrierCode,
        'product_description': productDescription,
        'current_status': currentStatus,
        'amount': amount,
        'carrier': carrier,
        'installments': installments,
        'trace_number': traceNumber,
        'installments_type': installmentsType,
      };
}
