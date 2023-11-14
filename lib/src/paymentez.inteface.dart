import 'package:paymentez/models/models.dart';

abstract class IPaymentez {
  // Card
  Future<(CardsResponse?, PaymentezError?)> getAllCards(String userID);
  Future<(AddCardResponse?, PaymentezError?)> addCard(AddCardRequest newCard);
  Future<(DeleteCardResponse?, PaymentezError?)> deleteCard({
    required DeleteCardRequest deleteCardRequest,
  });
  // Payment
  Future<(PayResponse?, PaymentezError?)> debit(PayRequest payRequest);
  Future<(PayResponse?, PaymentezError?)> debitCC(PayPCIRequest payPCIRequest);

  // Transactional
  // Future<void> verify();
  // Future<void> refund();
  // Future<void> transactionInfo();
}
