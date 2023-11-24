import 'package:http/http.dart' as http;
import 'package:paymentez_sdk/models/models.dart';
import 'package:paymentez_sdk/src/paymentez.impl.dart';
import 'package:paymentez_sdk/src/paymentez.inteface.dart';

export 'models/models.dart';

class PaymentezSDK implements IPaymentez {
  PaymentezSDK({
    String serverApplicationCode = '',
    String serverAppKey = '',
    String clientApplicationCode = '',
    String clientAppKey = '',
    bool isProd = false,
  }) : _svc = PaymentezImpl(
          client: http.Client(),
          serverApplicationCode: serverApplicationCode,
          serverAppKey: serverAppKey,
          clientAppKey: clientAppKey,
          clientApplicationCode: clientApplicationCode,
          isProd: isProd,
        );

  final PaymentezImpl _svc;

  @override
  Future<(CardsResponse?, PaymentezError?)> getAllCards(String userID) =>
      _svc.getAllCards(userID);

  @override
  Future<(AddCardResponse?, PaymentezError?)> addCard(AddCardRequest newCard) =>
      _svc.addCard(newCard);

  @override
  Future<(DeleteCardResponse?, PaymentezError?)> deleteCard({
    required DeleteCardRequest deleteCardRequest,
  }) =>
      _svc.deleteCard(deleteCardRequest: deleteCardRequest);

  @override
  Future<(PayResponse?, PaymentezError?)> debit(PayRequest payRequest) =>
      _svc.debit(payRequest);

  @override
  Future<(PayResponse?, PaymentezError?)> debitCC(
    PayPCIRequest payPCIRequest,
  ) =>
      _svc.debitCC(payPCIRequest);
}
