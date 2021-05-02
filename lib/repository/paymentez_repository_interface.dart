import 'package:paymentez/models/cardPay.dart';
import 'package:paymentez/models/orderPay.dart';
import 'package:paymentez/models/paymentez_resp.dart';
import 'package:paymentez/models/userPay.dart';

abstract class PaymentezRepositoryInterface {
  Future<PaymentezResp> getAllCards(String userId);
  Future<PaymentezResp> addCard({UserPay user, CardPay card, String sessionId});
  Future<PaymentezResp> delCard({String userId, String tokenCard});
  Future<PaymentezResp> infoTransaction({String userId, String transactionId});
  Future<PaymentezResp> verify({String userId, String transactionId, String type, String value, bool moreInfo = true});
  Future<PaymentezResp> debitToken({UserPay user, CardPay card, OrderPay orderPay});

  // Future<PaymentezResp> authorize(Usuario user, Tarjeta card, OrderPay orderPay);
  // Future<PaymentezResp> verifyOrder(String codigoUsuario, String transactionId, String type, String value);
  // Future<PaymentezResp> cardBin(String codigoUsuario, String bin);
  //
}
