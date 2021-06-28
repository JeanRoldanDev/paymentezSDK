import 'package:paymentez/utils/paymentez_validate.dart';

enum TypeCard {
  none,
  noSupport,
  visa,
  mastercard,
  americanExpress,
  dinners,
  discover,
  maestro,
  credisensa,
  solidario,
  unionPay,
}

class CardPay {
  CardPay({
    this.bin,
    this.status,
    this.token,
    this.holderName,
    this.expiryMonth,
    this.expiryYear,
    this.transactionReference,
    this.type,
    this.number,
    this.origin,
    this.cardInfo,
    this.cvc,
    this.statusEs,
    this.message,
  });

  factory CardPay.fromJson(dynamic dat) {
    return CardPay(
      bin: dat['bin'],
      status: dat['status'],
      token: dat['token'],
      holderName: dat['holder_name'].toString(),
      expiryMonth: int.parse(dat['expiry_month'].toString()),
      expiryYear: int.parse(dat['expiry_year'].toString()),
      transactionReference: dat['transaction_reference'],
      type: dat['type'],
      number: dat['number'].toString(),
      origin: dat['origin'],
      cardInfo: CardInfo.toModel(dat),
      cvc: '',
      statusEs: getStatusEs(dat['status'].toString()),
      message: dat['message'].toString(),
    );
  }

  /// propertys Paymentez
  final String bin;
  final String status;
  final String token;
  final String holderName;
  final int expiryMonth;
  final int expiryYear;
  final String transactionReference;
  final String type;
  final String number;
  final String origin;

  /// propertys View
  final CardInfo cardInfo;

  /// for use model
  final String cvc;
  final String statusEs;
  final String message;

  List<CardPay> getList(dynamic cards) {
    List listCards;
    for (final item in cards) listCards.add(CardPay.fromJson(item));
    return listCards;
  }

  static String getStatusEs(String status) {
    switch (status) {
      case 'valid':
        return 'Aprobada';
        break;
      case 'review':
        return 'En revisión';
        break;
      case 'rejected':
        return 'Rechazada';
        break;
      case 'pending':
        return 'Pendiente';
        break;
      case 'WAITING_OTP':
        return 'Pendiente de validar por OPT';
        break;
      default:
        return 'otra $status';
        break;
    }
  }

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
        'cardInfo': cardInfo.toJson(),
        'cvc': cvc,
        'statusEs': statusEs,
        'message': message,
      };
}

class CardInfo {
  CardInfo({
    this.type,
    this.typeCard,
    this.fullName,
    this.spacingPatterns,
    this.cvvLength,
    this.colorHex,
    this.numCardFormated,
  });

  factory CardInfo.toModel(dynamic dat) {
    return CardInfo(
      type: dat['type'].toString(),
      typeCard: PaymentezValidate.getTypeCard(dat['type'].toString()),
      fullName: PaymentezValidate.getFullNameTypeCard(dat['type'].toString()),
      spacingPatterns: PaymentezValidate.getSpacingPatternsCard(
        dat['type'].toString(),
      ),
      cvvLength: PaymentezValidate.getCVVlenngth(dat['type'].toString()),
      colorHex: PaymentezValidate.getColorCard(dat['type'].toString()),
      numCardFormated: PaymentezValidate.getNumCardFormated(
        dat['type'].toString(),
        dat['bin'].toString(),
        dat['number'].toString(),
      ),
    );
  }

  final String type;
  final TypeCard typeCard;
  final String fullName;
  final String spacingPatterns;
  final int cvvLength;
  final int colorHex;
  final String numCardFormated;

  Map<String, dynamic> toJson() => {
        'type': type,
        'typeCard': typeCard.toString(),
        'fullName': fullName,
        'spacingPatterns': spacingPatterns,
        'cvvLength': cvvLength,
        'color': colorHex.toString(),
        'numCardFormated': numCardFormated,
      };
}
