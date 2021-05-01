import 'package:flutter/material.dart';
import 'package:paymentez/models/cardPay.dart';
import 'package:paymentez/utils/masked_textInput_formatter.dart';

class PaymentezValidate {
  ///============DOCUMENTACION DE PAYMENTEZ==================
  ///https://paymentez.github.io/api-doc/es/#metodos-de-pago-tarjetas-marcas-de-tarjetas
  ///========================================================
  ///=================INTERNACIONALES========================
  static const String _VISA = 'vi';
  static const String _MASTERCARD = 'mc';
  static const String _AMERICAN_EXPRESS = 'ax';
  static const String _DINNERS = 'di';
  static const String _DISCOVER = 'dc';
  static const String _MAESTRO = 'ms';

  ///=====================ECUADOR============================
  static const String _CREDISENSA = 'cs';
  static const String _SOLIDARIO = 'so';
  static const String _UNION_PAY = 'up';
  // https://iinbinlist.com/c/ecuador.html?hl=es
  ///=====================TARJETA NO SOPORTADA============================
  static const String _NO_SUPPORT = 'err';

  ///===============CODIGOS DE VALIDACION===============
  /// fuente oficial:https://en.wikipedia.org/wiki/Payment_card_number
  /// fuente oficial:https://es.wikipedia.org/wiki/N%C3%BAmero_de_tarjeta_bancaria
  /// fuente tercero:https://stackoverflow.com/questions/72768/how-do-you-detect-credit-card-type-based-on-number
  /// fuente tercero:https://www.creditcardvalidator.org/generator
  /// fuente tercero:https://baymard.com/checkout-usability/credit-card-patterns
  /// fuente oficial:https://www.mastercard.us/content/dam/mccom/global/documents/mastercard-rules.pdf Pag:79/403
  /// fuente tercero:https://www.bioem2020.org/images/pdfs/Can_I_actually_pay_with_my_Maestro_card.pdf
  /// fuente oficial:https://www.discoverglobalnetwork.com/downloads/IPP_VAR_Compliance.pdf
  static const Map<String, List<String>> _typesCardsCodes = {
    _VISA: ["4"],
    _AMERICAN_EXPRESS: ["34", "37"],
    _MAESTRO: ["50", "56", "69", "639000-639099", "670000-679999"],
    _MASTERCARD: ["510000-559999", "222100-272099"],
    _DINNERS: ["36", "38", "39", "300-305", "309"],
    _DISCOVER: ["65", "6011", "644", "645", "646", "647", "648", "649"],
    _UNION_PAY: ["62"],
    _CREDISENSA: [],
    _SOLIDARIO: []
  };

  /// para obtener informacion respecto a la tarjeta se debe colocar los
  /// 6 primeros digitos de la tarjeta caso contrario retorna null
  static CardInfo getCarInfo(String numCardLenth6) {
    CardInfo cardInfo;
    String name = _NO_SUPPORT;
    if (numCardLenth6.length < 6) {
      throw Exception('PaymentezValidate.getCarInfo, ERROR: numCardLenth6 debe contener 6 caracteres');
    }
    OUTER:
    for (var i = 0; i < _typesCardsCodes.keys.length; i++) {
      name = _typesCardsCodes.keys.elementAt(i);
      List<String> codes = _typesCardsCodes.values.elementAt(i);
      for (var cardCode in codes) {
        final listCode = cardCode.split("-");
        if (listCode.length > 1) {
          int inicio = int.parse(listCode[0].toString());
          int fin = int.parse(listCode[1].toString());
          for (var ii = inicio; ii <= fin; ii++) {
            String digitos = numCardLenth6.substring(0, ii.toString().length);
            if (digitos == ii.toString()) {
              cardInfo = CardInfo(
                type: name,
                typeCard: PaymentezValidate.getTypeCard(name),
                fullName: PaymentezValidate.getFullNameTypeCard(name),
                spacingPatterns: PaymentezValidate.getSpacingPatternsCard(name),
                cvvLength: PaymentezValidate.getCVVlenngth(name),
                icon: PaymentezValidate.getIconCard(name),
                color: PaymentezValidate.getColorCard(name),
                numCardFormated: null,
              );
              break OUTER;
            }
          }
        } else {
          String digitos = numCardLenth6.substring(0, cardCode.toString().length);
          if (digitos == cardCode.toString()) {
            cardInfo = CardInfo(
              type: name,
              typeCard: PaymentezValidate.getTypeCard(name),
              fullName: PaymentezValidate.getFullNameTypeCard(name),
              spacingPatterns: PaymentezValidate.getSpacingPatternsCard(name),
              cvvLength: PaymentezValidate.getCVVlenngth(name),
              icon: PaymentezValidate.getIconCard(name),
              color: PaymentezValidate.getColorCard(name),
              numCardFormated: null,
            );
            break OUTER;
          }
        }
      }
    }
    if (cardInfo == null) {
      return CardInfo(
        type: 'err',
        typeCard: PaymentezValidate.getTypeCard('err'),
        fullName: PaymentezValidate.getFullNameTypeCard('err'),
        spacingPatterns: PaymentezValidate.getSpacingPatternsCard('err'),
        cvvLength: PaymentezValidate.getCVVlenngth('err'),
        icon: PaymentezValidate.getIconCard('err'),
        color: PaymentezValidate.getColorCard('err'),
        numCardFormated: null,
      );
    } else {
      return cardInfo;
    }
  }

  /// contiene el tipo de tarjeta enum  el COD: es obtenido desde PaymentezValidate.getTypeCardPaymentez
  static TypeCard getTypeCard(String cod) {
    if (cod == 'vi') return TypeCard.Visa;
    if (cod == 'mc') return TypeCard.Mastercard;
    if (cod == 'ax') return TypeCard.AmericanExpress;
    if (cod == 'di') return TypeCard.Dinners;
    if (cod == 'dc') return TypeCard.Discover;
    if (cod == 'ms') return TypeCard.Maestro;
    if (cod == 'cs') return TypeCard.Credisensa;
    if (cod == 'so') return TypeCard.Solidario;
    if (cod == 'up') return TypeCard.UnionPay;
    if (cod == 'err')
      return TypeCard.NoSupport;
    else
      return TypeCard.NoSupport;
  }

  /// contiene el nombre completo de la marca de la tarjeta ejemplo del codigo (ax) se obtiene (American Express)
  static String getFullNameTypeCard(String cod) {
    if (cod == 'vi') return "Visa";
    if (cod == 'mc') return "Mastercard";
    if (cod == 'ax') return "American Express";
    if (cod == 'di') return "Dinners";
    if (cod == 'dc') return "Dinners Discover";
    if (cod == 'ms') return "Maestro";
    if (cod == 'cs') return "Credisensa";
    if (cod == 'so') return "Alias Solidario";
    if (cod == 'up') return "Union Pay";
    if (cod == 'err')
      return 'NO SUPORT';
    else
      return 'NO SUPORT';
  }

  static String getSpacingPatternsCard(String cod) {
    if (cod == 'vi') return "XXXX XXXX XXXX XXXX";
    if (cod == 'mc') return "XXXX XXXX XXXX XXXX";
    if (cod == 'ax') return "XXXX XXXXXX XXXXX";
    if (cod == 'di') return "XXXX XXXX XXXX XX";
    if (cod == 'dc') return "XXXX XXXX XXXX XXXX";
    if (cod == 'ms') return "XXXX XXXX XXXX XXXX";
    if (cod == 'cs') return "XXXX XXXX XXXX XXXX";
    if (cod == 'so') return "XXXX XXXX XXXX XXXX";
    if (cod == 'up') return "XXXX XXXX XXXX XXXX";
    if (cod == 'err')
      return "XXXX XXXX XXXX XXXX";
    else
      return "XXXX XXXX XXXX XXXX";
  }

  static int getCVVlenngth(String cod) {
    if (cod == 'vi') return 3;
    if (cod == 'mc') return 3;
    if (cod == 'ax') return 4;
    if (cod == 'di') return 3;
    if (cod == 'dc') return 3;
    if (cod == 'ms') return 3;
    if (cod == 'cs') return 3;
    if (cod == 'so') return 3;
    if (cod == 'up') return 3;
    if (cod == 'err')
      return 3;
    else
      return 3;
  }

  ///  contiene la ruta de la imagen de la marca de la tarjeta ejemplo del codigo (ax) se obtiene (assets/img/cards/amex.png)
  static String getIconCard(String cod) {
    if (cod == 'vi') return "assets/img/cards/visa.png";
    if (cod == 'mc') return "assets/img/cards/martercard.png";
    if (cod == 'ax') return "assets/img/cards/amex.png";
    if (cod == 'di') return "assets/img/cards/dinners.png";
    if (cod == 'dc') return "assets/img/cards/discovery.png";
    if (cod == 'ms') return "assets/img/cards/maestro.png";
    if (cod == 'cs') return "assets/img/cards/none.png";
    if (cod == 'so') return "assets/img/cards/none.png";
    if (cod == 'up') return "assets/img/cards/unionpay.png";
    if (cod == 'err')
      return "assets/img/cards/error.png";
    else
      return "assets/img/cards/none.png";
  }

  /// contiene el tipo de tarjeta enum  el COD: es obtenido desde PaymentezValidate.getTypeCardPaymentez
  static Color getColorCard(String cod) {
    if (cod == 'vi') return const Color(0xFF0061B2);
    if (cod == 'mc') return const Color(0xFFFF5F00);
    if (cod == 'ax') return const Color(0xFF2E77BB);
    if (cod == 'di') return const Color(0xFFA4AEB5);
    if (cod == 'dc') return const Color(0xFFFF6C01);
    if (cod == 'ms') return const Color(0xFF009DDC);
    if (cod == 'cs') return const Color(0xFFE74437);
    if (cod == 'so') return const Color(0xFF255836);
    if (cod == 'up') return const Color(0xFF007C85);
    if (cod == 'err')
      return const Color(0xFFFD0A0A);
    else
      return const Color(0xFF4D5051);
  }

  /// obtiene el nombre para mostrar al usuario segun el formato del spaccingPatterns
  static String getNumCardFormated(String cod, String bin, String number) {
    String spacingPatterns = getSpacingPatternsCard(cod);
    final pattern = spacingPatterns.replaceAll(" ", "");
    String txt1 = "";
    for (var i = 0; i <= pattern.length - 1; i++) {
      if (i < bin.length) {
        txt1 += bin[i];
      } else {
        txt1 += pattern[i];
      }
    }

    int cont = 0;
    String txt2 = "";
    for (var i = (txt1.length - 1); i >= 0; i--) {
      if (cont < number.length) {
        txt2 = number[cont] + txt2;
        cont++;
      } else {
        txt2 = txt1[i] + txt2;
      }
    }
    return MaskedTextInputFormatter.applyFormat(txt2, mask: spacingPatterns, separator: " ", force: true);
  }

  /// Obtiene el codigo de detalle para las transacciones puede encontrar mas informacion de los codigos en:
  ///
  /// https://paymentez.github.io/api-doc/#status-details
  ///
  static String geStatusDetailDescription(int statusDetail) {
    switch (statusDetail) {
      case 0:
        return 'A la espera del pago';
        break;
      case 1:
        return 'Se requiere verificación, consulte la sección Verificación';
        break;
      case 3:
        return 'Pagado';
        break;
      case 6:
        return 'Fraude';
        break;
      case 7:
        return 'Reembolso';
        break;
      case 8:
        return 'Contracargo';
        break;
      case 9:
        return 'Rechazado por el transportista';
        break;
      case 10:
        return 'Error del sistema';
        break;
      case 11:
        return 'Fraude de Paymentez';
        break;
      case 12:
        return 'Lista negra de Paymentez';
        break;
      case 13:
        return 'Tolerancia al tiempo';
        break;
      case 14:
        return 'Caducado por Paymentez';
        break;
      case 19:
        return 'Código de autorización no válido';
        break;
      case 20:
        return 'El código de autorización venció';
        break;
      case 21:
        return 'Fraude de Paymentez - Reembolso pendiente';
        break;
      case 22:
        return 'AuthCode no válido: reembolso pendiente';
        break;
      case 23:
        return 'AuthCode caducado: reembolso pendiente';
        break;
      case 24:
        return 'Fraude de Paymentez - Reembolso solicitado';
        break;
      case 25:
        return 'AuthCode no válido: reembolso solicitado';
        break;
      case 26:
        return 'AuthCode expired - Reembolso solicitado';
        break;
      case 27:
        return 'Comerciante: reembolso pendiente';
        break;
      case 28:
        return 'Comerciante: reembolso solicitado';
        break;
      case 29:
        return 'Anulado';
        break;
      case 30:
        return 'Transacción sentado (solo Ecuador)';
        break;
      case 31:
        return 'Esperando OTP';
        break;
      case 32:
        return 'OTP validado con éxito';
        break;
      case 33:
        return 'OTP no validado';
        break;
      case 34:
        return 'Reembolso parcial';
        break;
      case 35:
        return 'Se solicitó el método 3DS, esperando continuar';
        break;
      case 36:
        return 'Desafío 3DS solicitado, esperando CRES';
        break;
      case 37:
        return 'Rechazado por 3DS';
        break;
      default:
        return "NO RECONOCIDO";
        break;
    }
  }

  static List<dynamic> getInstallmentsType() {
    return [
      {"Type": 0, "Description": "Crédito Rotativo."},
      {"Type": 1, "Description": "Rotativo y diferido sin intereses (el banco pagará al comercio la cuota, mes a mes)."},
      {"Type": 2, "Description": "Diferido con intereses."},
      {"Type": 3, "Description": "Diferido sin intereses."},
      {"Type": 7, "Description": "Diferido con intereses y meses de gracia."},
      {"Type": 6, "Description": "Diferido sin intereses pago mes a mes. (*)"},
      {"Type": 9, "Description": "Diferido sin intereses y meses de gracia."},
      {"Type": 10, "Description": "Diferido sin intereses promoción bimensual. (*)"},
      {"Type": 21, "Description": "Exclusivo para Diners Club, diferido con y sin intereses."},
      {"Type": 22, "Description": "Exclusivo para Diners Club, diferido con y sin intereses."},
      {"Type": 30, "Description": "Diferido con intereses pago mes a mes. (*)"},
      {"Type": 50, "Description": "Diferido sin intereses promociones (Supermaxi). (*)"},
      {"Type": 51, "Description": "Diferido con intereses (Cuota fácil). (*)"},
      {"Type": 52, "Description": "Sin intereses (Rendecion Produmillas). (*)"},
      {"Type": 53, "Description": "Sin intereses venta con promociones. (*)"},
      {"Type": 70, "Description": "Diferido especial sin intereses (*)"},
      {"Type": 72, "Description": "Crédito sin intereses (cte smax). (*)"},
      {"Type": 73, "Description": "Crédito Especial sin intereses (smax). (*)"},
      {"Type": 74, "Description": "Prepago sin intereses (smax). (*)"},
      {"Type": 75, "Description": "Crédito diferido sin intereses (smax). (*)"},
      {"Type": 90, "Description": "Sin intereses con meses de gracia (Supermaxi). (*)"},
    ];
  }
}
