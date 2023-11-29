import 'dart:developer';
import 'dart:io';

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

  // Use this setting if your integration used PCI
  // final sdk = PaymentezSDK(
  //   serverApplicationCode: Env.instance.appCodePCI,
  //   serverAppKey: Env.instance.appKeyPCI,
  //   isPCI: true,
  // );

  const userID = '5a9b9072-4d60-4846-be71-d533d3851901';

  log('========= GET CARDS =========');
  final (cardsResponse, paymentezError) = await sdk.getAllCards(userID);
  if (paymentezError != null) {
    log(paymentezError.toJson().toString());
    return;
  }

  log(cardsResponse!.toJson().toString());
  if (cardsResponse.resultSize == 0) {
    log('========= ADD CARD =========');
    final addCardRequest = AddCardRequest(
      user: UserCard(
        id: userID,
        email: 'test@example.com',
      ),
      card: NewCard(
        number: '4111111111111111',
        holderName: 'citlali calderon',
        expiryMonth: 9,
        expiryYear: 2025,
        cvc: '123',
      ),
    );

    final (addCardResponse, paymentezError) = await sdk.addCard(addCardRequest);
    if (paymentezError != null) {
      log(paymentezError.toJson().toString());
      return;
    } else {
      log(addCardResponse!.toJson().toString());
    }
  } else {
    log('========= DELECTE CARD =========');
    final deleteCardRequest = DeleteCardRequest(
      cardToken: cardsResponse.cards.first.token,
      userId: userID,
    );
    final (deleteCardResponse, paymentezError) =
        await sdk.deleteCard(deleteCardRequest);
    if (paymentezError != null) {
      log(paymentezError.toJson().toString());
      return;
    } else {
      log(deleteCardResponse!.toJson().toString());
    }
  }
  exit(0);
}
