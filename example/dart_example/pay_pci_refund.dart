import 'dart:developer';

import 'package:paymentez_sdk/paymentez_sdk.dart';

import 'env.dart';

Future<void> main(List<String> args) async {
  // Use this setting if your integration used PCI
  final sdk = PaymentezSDK(
    serverApplicationCode: Env.instance.appCodePCI,
    serverAppKey: Env.instance.appKeyPCI,
    isPCI: true,
  );

  const userID = '5a9b9072-4d60-4846-be71-d533d3851901';

  log('========= PAY WITHOUT PCI =========');
  final payPCIRequest = PayPCIRequest(
    user: UserPay(
      id: userID,
      email: 'test@example.com',
      phone: '+593555555555',
    ),
    order: OrderPay(
      taxPercentage: 12,
      taxableAmount: 292.86,
      vat: 35.14,
      amount: 328,
      description: 'pozole',
      devReference: 'buy_test',
    ),
    card: CardPCI(
      number: '4111111111111111',
      holderName: 'citlali calderon',
      expiryMonth: 9,
      expiryYear: 2025,
      cvc: '123',
    ),
  );

  final (payResponse, paymentezError) = await sdk.debitCC(payPCIRequest);
  if (paymentezError != null) {
    log(paymentezError.toJson().toString());
    return;
  }
  log(payResponse!.toJson().toString());

  log('========= REFUND =========');
  final refundRequest = RefundRequest(
    transactionID: payResponse.transaction.id,
  );
  final (refundResponse, refundError) = await sdk.refund(refundRequest);
  if (refundError != null) {
    log(refundError.toJson().toString());
    return;
  }
  log(refundResponse!.toJson().toString());
}
