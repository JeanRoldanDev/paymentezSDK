import 'dart:developer';

import 'package:paymentez_sdk/paymentez_sdk.dart';

import 'env.dart';

Future<void> main(List<String> args) async {
  // Use this setting if your integration does not use PCI
  final sdk = PaymentezSDK(
    serverApplicationCode: Env.instance.serverApplicationCode,
    serverAppKey: Env.instance.serverAppKey,
    clientApplicationCode: Env.instance.clientApplicationCode,
    clientAppKey: Env.instance.clientAppKey,
  );

  const userID = '5a9b9072-4d60-4846-be71-d533d3851901';

  log('========= PAY WITHOUT PCI =========');
  final payRequest = PayRequest(
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
    card: CardToken(
      token: '14329172493919123772',
    ),
  );

  final (payResponse, paymentezError) = await sdk.debit(payRequest);
  if (paymentezError != null) {
    log(paymentezError.toJson().toString());
    return;
  }
  log(payResponse!.toJson().toString());
}
