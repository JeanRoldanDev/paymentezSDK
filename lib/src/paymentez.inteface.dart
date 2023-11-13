import 'package:paymentez/models/models.dart';

abstract class IPaymentez {
  Future<(CardsResponse?, PaymentezError?)> getAllCards(String userID);
  Future<(AddCardResponse?, PaymentezError?)> addCard(AddCardRequest newCard);
  Future<(DeleteCardResponse?, PaymentezError?)> deleteCard({
    required DeleteCardRequest deleteCardRequest,
  });

  // Future<void> debitCC();
  // Future<void> debit();
  // Future<void> verify();
  // Future<void> refund();
  // Future<void> transactionInfo();
}