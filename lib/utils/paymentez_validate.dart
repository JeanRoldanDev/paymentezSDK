import 'package:paymentez/models/cardPay.dart';
import 'package:paymentez/utils/masked_textInput_formatter.dart';

class PaymentezValidate {
  ///============DOCUMENTACION DE PAYMENTEZ==================
  ///https://paymentez.github.io/api-doc/es/#metodos-de-pago-tarjetas-marcas-de-tarjetas
  ///========================================================
  ///=================INTERNACIONALES========================
  static const String _visa = 'vi';
  static const String _mastercar = 'mc';
  static const String _americanExpress = 'ax';
  static const String _dinners = 'di';
  static const String _discover = 'dc';
  static const String _maestro = 'ms';

  ///=====================ECUADOR============================
  static const String _credisensa = 'cs';
  static const String _solidario = 'so';
  static const String _unionPay = 'up';
  // https://iinbinlist.com/c/ecuador.html?hl=es
  ///=====================TARJETA NO SOPORTADA============================
  static const String _noSupport = 'err';

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
    _visa: ['4'],
    _americanExpress: ['34', '37'],
    _maestro: ['50', '56', '69', '639000-639099', '670000-679999'],
    _mastercar: ['510000-559999', '222100-272099'],
    _dinners: ['36', '38', '39', '300-305', '309'],
    _discover: ['65', '6011', '644', '645', '646', '647', '648', '649'],
    _unionPay: ['62'],
    _credisensa: [],
    _solidario: []
  };

  /// para obtener informacion respecto a la tarjeta se debe colocar los
  /// 6 primeros digitos de la tarjeta caso contrario retorna null
  static CardInfo getCarInfo(String numCardLenth6) {
    CardInfo cardInfo;
    var name = _noSupport;
    if (numCardLenth6.length < 6) {
      throw Exception('''PaymentezValidate.getCarInfo, ERROR: 
                         numCardLenth6 debe contener 6 caracteres''');
    }
    OUTER:
    for (var i = 0; i < _typesCardsCodes.keys.length; i++) {
      name = _typesCardsCodes.keys.elementAt(i);
      final codes = List<String>.from(_typesCardsCodes.values.elementAt(i));
      for (final cardCode in codes) {
        final listCode = cardCode.split('-');
        if (listCode.length > 1) {
          final inicio = int.parse(listCode[0].toString());
          final fin = int.parse(listCode[1].toString());
          for (var ii = inicio; ii <= fin; ii++) {
            final digitos = numCardLenth6.substring(0, ii.toString().length);
            if (digitos == ii.toString()) {
              cardInfo = CardInfo(
                type: name,
                typeCard: PaymentezValidate.getTypeCard(name),
                fullName: PaymentezValidate.getFullNameTypeCard(name),
                spacingPatterns: PaymentezValidate.getSpacingPatternsCard(name),
                cvvLength: PaymentezValidate.getCVVlenngth(name),
                colorHex: PaymentezValidate.getColorCard(name),
                numCardFormated: PaymentezValidate.getNumCardFormated(
                  name,
                  numCardLenth6,
                  'xxxx',
                ),
              );
              break OUTER;
            }
          }
        } else {
          final digitos = numCardLenth6.substring(
            0,
            cardCode.toString().length,
          );
          if (digitos == cardCode.toString()) {
            cardInfo = CardInfo(
              type: name,
              typeCard: PaymentezValidate.getTypeCard(name),
              fullName: PaymentezValidate.getFullNameTypeCard(name),
              spacingPatterns: PaymentezValidate.getSpacingPatternsCard(name),
              cvvLength: PaymentezValidate.getCVVlenngth(name),
              colorHex: PaymentezValidate.getColorCard(name),
              numCardFormated: PaymentezValidate.getNumCardFormated(
                name,
                numCardLenth6,
                'xxxx',
              ),
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
        colorHex: PaymentezValidate.getColorCard('err'),
        numCardFormated: PaymentezValidate.getNumCardFormated(
          name,
          numCardLenth6,
          'xxxx',
        ),
      );
    } else {
      return cardInfo;
    }
  }

  /// contiene el tipo de tarjeta enum  el COD:
  /// es obtenido desde PaymentezValidate.getTypeCardPaymentez
  static TypeCard getTypeCard(String cod) {
    switch (cod) {
      case 'vi':
        return TypeCard.visa;
      case 'mc':
        return TypeCard.mastercard;
      case 'ax':
        return TypeCard.americanExpress;
      case 'di':
        return TypeCard.dinners;
      case 'dc':
        return TypeCard.discover;
      case 'ms':
        return TypeCard.maestro;
      case 'cs':
        return TypeCard.credisensa;
      case 'so':
        return TypeCard.solidario;
      case 'up':
        return TypeCard.unionPay;
      case 'err':
        return TypeCard.noSupport;
      default:
        return TypeCard.noSupport;
    }
  }

  /// contiene el nombre completo de la marca de la tarjeta ejemplo:
  /// del codigo (ax) se obtiene (American Express)
  static String getFullNameTypeCard(String cod) {
    switch (cod) {
      case 'vi':
        return 'Visa';
      case 'mc':
        return 'Mastercard';
      case 'ax':
        return 'American Express';
      case 'di':
        return 'Dinners';
      case 'dc':
        return 'Dinners Discover';
      case 'ms':
        return 'Maestro';
      case 'cs':
        return 'Credisensa';
      case 'so':
        return 'Alias Solidario';
      case 'up':
        return 'Union Pay';
      case 'err':
        return 'NO SUPORT';
      default:
        return 'NO SUPORT';
    }
  }

  static String getSpacingPatternsCard(String cod) {
    switch (cod) {
      case 'vi':
        return 'XXXX XXXX XXXX XXXX';
      case 'mc':
        return 'XXXX XXXX XXXX XXXX';
      case 'ax':
        return 'XXXX XXXXXX XXXXX';
      case 'di':
        return 'XXXX XXXX XXXX XX';
      case 'dc':
        return 'XXXX XXXX XXXX XXXX';
      case 'ms':
        return 'XXXX XXXX XXXX XXXX';
      case 'cs':
        return 'XXXX XXXX XXXX XXXX';
      case 'so':
        return 'XXXX XXXX XXXX XXXX';
      case 'up':
        return 'XXXX XXXX XXXX XXXX';
      case 'err':
        return 'XXXX XXXX XXXX XXXX';
      default:
        return 'XXXX XXXX XXXX XXXX';
    }
  }

  static int getCVVlenngth(String cod) {
    switch (cod) {
      case 'vi':
        return 3;
      case 'mc':
        return 3;
      case 'ax':
        return 4;
      case 'di':
        return 3;
      case 'dc':
        return 3;
      case 'ms':
        return 3;
      case 'cs':
        return 3;
      case 'so':
        return 3;
      case 'up':
        return 3;
      case 'err':
        return 3;
      default:
        return 3;
    }
  }

  static int getColorCard(String cod) {
    switch (cod) {
      case 'vi':
        return 0xFF0061B2;
      case 'mc':
        return 0xFFFF5F00;
      case 'ax':
        return 0xFF2E77BB;
      case 'di':
        return 0xFFA4AEB5;
      case 'dc':
        return 0xFFFF6C01;
      case 'ms':
        return 0xFF009DDC;
      case 'cs':
        return 0xFFE74437;
      case 'so':
        return 0xFF255836;
      case 'up':
        return 0xFF007C85;
      case 'err':
        return 0xFFFD0A0A;
      default:
        return 0xFF4D5051;
    }
  }

  /// obtiene el nombre para mostrar al usuario segun el formato del
  /// spaccingPatterns
  static String getNumCardFormated(String cod, String bin, String number) {
    final spacingPatterns = getSpacingPatternsCard(cod);
    final pattern = spacingPatterns.replaceAll(' ', '');
    var txt1 = '';
    for (var i = 0; i <= pattern.length - 1; i++) {
      if (i < bin.length)
        txt1 += bin[i];
      else
        txt1 += pattern[i];
    }

    var cont = 0;
    var txt2 = '';
    for (var i = (txt1.length - 1); i >= 0; i--) {
      if (cont < number.length) {
        txt2 = number[cont] + txt2;
        cont++;
      } else {
        txt2 = txt1[i] + txt2;
      }
    }
    return MaskedTextInputFormatter.applyFormat(
      txt2,
      mask: spacingPatterns,
      separator: ' ',
      force: true,
    );
  }

  /// Obtiene el codigo de detalle para las transacciones puede encontrar mas
  ///  informacion de los codigos en:
  /// https://paymentez.github.io/api-doc/#status-details
  static String geStatusDetailDescription(int statusDetail) {
    switch (statusDetail) {
      case 0:
        return 'A la espera del pago';
      case 1:
        return 'Se requiere verificación, consulte la sección Verificación';
      case 3:
        return 'Pagado';
      case 6:
        return 'Fraude';
      case 7:
        return 'Reembolso';
      case 8:
        return 'Contracargo';
      case 9:
        return 'Rechazado por el transportista';
      case 10:
        return 'Error del sistema';
      case 11:
        return 'Fraude de Paymentez';
      case 12:
        return 'Lista negra de Paymentez';
      case 13:
        return 'Tolerancia al tiempo';
      case 14:
        return 'Caducado por Paymentez';
      case 19:
        return 'Código de autorización no válido';
      case 20:
        return 'El código de autorización venció';
      case 21:
        return 'Fraude de Paymentez - Reembolso pendiente';
      case 22:
        return 'AuthCode no válido: reembolso pendiente';
      case 23:
        return 'AuthCode caducado: reembolso pendiente';
      case 24:
        return 'Fraude de Paymentez - Reembolso solicitado';
      case 25:
        return 'AuthCode no válido: reembolso solicitado';
      case 26:
        return 'AuthCode expired - Reembolso solicitado';
      case 27:
        return 'Comerciante: reembolso pendiente';
      case 28:
        return 'Comerciante: reembolso solicitado';
      case 29:
        return 'Anulado';
      case 30:
        return 'Transacción sentado (solo Ecuador)';
      case 31:
        return 'Esperando OTP';
      case 32:
        return 'OTP validado con éxito';
      case 33:
        return 'OTP no validado';
      case 34:
        return 'Reembolso parcial';
      case 35:
        return 'Se solicitó el método 3DS, esperando continuar';
      case 36:
        return 'Desafío 3DS solicitado, esperando CRES';
      case 37:
        return 'Rechazado por 3DS';
      default:
        return 'NO RECONOCIDO';
    }
  }

  /// =====================Tipo de cuotas=====================
  ///El tipo de cuotas solo están disponibles para Ecuador y México.
  ///Los valores válidos son:
  static List<dynamic> getInstallmentsType() {
    return [
      {
        'Type': 0,
        'Description': 'Crédito Rotativo.',
      },
      {
        'Type': 1,
        'Description':
            'Rotativo y diferido sin intereses (el banco pagará al comercio la cuota, mes a mes).',
      },
      {
        'Type': 2,
        'Description': 'Diferido con intereses.',
      },
      {
        'Type': 3,
        'Description': 'Diferido sin intereses.',
      },
      {
        'Type': 7,
        'Description': 'Diferido con intereses y meses de gracia.',
      },
      {
        'Type': 6,
        'Description': 'Diferido sin intereses pago mes a mes. (*)',
      },
      {
        'Type': 9,
        'Description': 'Diferido sin intereses y meses de gracia.',
      },
      {
        'Type': 10,
        'Description': 'Diferido sin intereses promoción bimensual. (*)',
      },
      {
        'Type': 21,
        'Description':
            'Exclusivo para Diners Club, diferido con y sin intereses.',
      },
      {
        'Type': 22,
        'Description':
            'Exclusivo para Diners Club, diferido con y sin intereses.',
      },
      {
        'Type': 30,
        'Description': 'Diferido con intereses pago mes a mes. (*)',
      },
      {
        'Type': 50,
        'Description': 'Diferido sin intereses promociones (Supermaxi). (*)',
      },
      {
        'Type': 51,
        'Description': 'Diferido con intereses (Cuota fácil). (*)',
      },
      {
        'Type': 52,
        'Description': 'Sin intereses (Rendecion Produmillas). (*)',
      },
      {
        'Type': 53,
        'Description': 'Sin intereses venta con promociones. (*)',
      },
      {
        'Type': 70,
        'Description': 'Diferido especial sin intereses (*)',
      },
      {
        'Type': 72,
        'Description': 'Crédito sin intereses (cte smax). (*)',
      },
      {
        'Type': 73,
        'Description': 'Crédito Especial sin intereses (smax). (*)',
      },
      {
        'Type': 74,
        'Description': 'Prepago sin intereses (smax). (*)',
      },
      {
        'Type': 75,
        'Description': 'Crédito diferido sin intereses (smax). (*)',
      },
      {
        'Type': 90,
        'Description': 'Sin intereses con meses de gracia (Supermaxi). (*)',
      },
    ];
  }
}
