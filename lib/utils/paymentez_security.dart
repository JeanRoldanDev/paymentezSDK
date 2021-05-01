import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class PaymentezSecurity {
  /// ============ALGORITMO DE PAYMENTEZ==============
  /// https://paymentez.github.io/api-doc/#authentication
  /// Todas las solicitudes deben tener el encabezado Auth-Token
  static String getAuthToken(String paymentezAppCode, String paymentezAppClientKey) {
    /// genera el UNIXTIMESTAMP: Esta debe ser creada al mismo tiempo que la solicitud,
    /// tenga en cuenta que la hora está en UTC y en SEGUNDOS , tendrá 15 segundos antes
    /// de que necesite crear una nueva , o su solicitud será rechazada (error.type: Invalid timestamp).
    String authTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();

    /// genera el UNIQ-TOKEN: Es la representación hexadecimal de un hash que sha256 genera a partir
    /// de la cadena "clave-secreta" + "marca de tiempo", la clave secreta la proporciona el equipo de Paymentez.
    String uniqTokenString = paymentezAppClientKey + authTimeStamp;
    String uniqToken = sha256.convert(utf8.encode(uniqTokenString)).toString();

    /// Todas las solicitudes deben tener el encabezado Auth-Token:Esta es una cadena codificada en base64,
    /// la cadena debe crearse de la siguiente manera (considere el; entre cada uno): APPLICATION-CODE;UNIXTIMESTAMP;UNIQ-TOKE
    String stringAuthToken = paymentezAppCode + ";" + authTimeStamp + ";" + uniqToken;
    String authToken = base64Encode(utf8.encode(stringAuthToken));

    return authToken;
  }

  /// ============ALGORITMO DE LUHN==============///
  /// https://en.wikipedia.org/wiki/Luhn_algorithm
  /// https://www.discoverglobalnetwork.com/downloads/IPP_VAR_Compliance.pdf
  /// https://en.wikipedia.org/wiki/Payment_card_number
  ///
  /// Necesita el numero de tarjeta sin espacios ni guion
  static bool validCard(String numCard) {
    int sum = 0;
    int length = numCard.length;
    for (var i = 0; i < length; i++) {
      int digit = int.parse(numCard[length - i - 1]);
      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }
    return (sum % 10 == 0);
  }

  /// ============ID DE SESSION==============///
  /// SE NECESITARA PARA CREAR SESSIONES DE TRANFERENCIAS
  static String getSessionID(int len) {
    var rng = new Random();
    String resp = "";
    for (var i = 0; i < len; i++) {
      resp += rng.nextInt(10).toString();
    }
    return resp;
  }

  static String formatDate(DateTime now) {
    String day = (now.day < 10) ? "0" + now.day.toString() : now.day.toString();
    String month = (now.month < 10) ? "0" + now.month.toString() : now.month.toString();
    String year = now.year.toString();
    String result = day + "/" + month + "/" + year;
    return result;
  }

  static String formatHour(DateTime now) {
    String hour = (now.hour < 10) ? "0" + now.hour.toString() : now.hour.toString();
    String minute = (now.minute < 10) ? "0" + now.minute.toString() : now.minute.toString();
    String second = (now.second < 10) ? "0" + now.second.toString() : now.second.toString();
    String result = hour + ":" + minute + ":" + second;
    return result;
  }
}
