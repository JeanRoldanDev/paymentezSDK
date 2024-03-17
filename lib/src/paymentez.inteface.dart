import 'package:paymentez_sdk/models/models.dart';

abstract class IPaymentez {
  // =====================================================================
  // =============================== Cards ===============================
  // =====================================================================
  Future<(CardsResponse?, PaymentezError?)> getAllCards(
    String userID,
  );

  Future<(AddCardResponse?, PaymentezError?)> addCard(
    CardRequest card,
  );

  Future<(AddCardResponse?, PaymentezError?)> addCardCC(
    CardPCIRequest card,
  );

  Future<(DeleteCardResponse?, PaymentezError?)> deleteCard(
    DeleteCardRequest deleteCard,
  );

  // =====================================================================
  // =============================== PAYMENT =============================
  // =====================================================================
  Future<(PayResponse?, PaymentezError?)> debit(
    PayRequest payRequest,
  );

  Future<(PayResponse?, PaymentezError?)> debitCC(
    PayPCIRequest payPCIRequest,
  );

  // =====================================================================
  // =============================== PROCESS =============================
  // =====================================================================
  Future<(RefundResponse?, PaymentezError?)> refund(
    RefundRequest refundRequest,
  );
}
