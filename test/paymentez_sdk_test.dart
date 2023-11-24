import 'package:paymentez/paymentez_sdk.dart';
import 'package:test/test.dart';

void main() {
  late PaymentezSDK sdk;

  setUp(() {
    sdk = PaymentezSDK();
  });
  test('SDK instance test call getAllCards', () async {
    final (resp, err) = await sdk.getAllCards('4');
    expect(resp, isNull);
    expect(err, isA<PaymentezError>());
  });

  test('SDK instance test call addCard', () async {
    final (resp, err) = await sdk.addCard(
      AddCardRequest(
        user: UserCard(id: 'mockData', email: 'mockData'),
        card: NewCard(
          number: 'mockData',
          holderName: 'mockData',
          expiryMonth: 09,
          expiryYear: 2025,
          cvc: 'mockData',
        ),
      ),
    );
    expect(resp, isNull);
    expect(err, isA<PaymentezError>());
  });

  test('SDK instance test call getAllCards', () async {
    final (resp, err) = await sdk.deleteCard(
      deleteCardRequest: DeleteCardRequest(
        cardToken: 'mockData',
        userId: 'mockData',
      ),
    );
    expect(resp, isNull);
    expect(err, isA<PaymentezError>());
  });
}
