import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class PaymentezSecurity {
  /// ============ALGORITMO DE PAYMENTEZ==============
  /// https://paymentez.github.io/api-doc/#authentication
  /// Todas las solicitudes deben tener el encabezado Auth-Token
  /// puede usar el hilo del cliente o del servidor
  static String getAuthToken(String appCode, String appKey) {
    /// genera el UNIXTIMESTAMP: Esta debe ser creada al mismo tiempo
    /// que la solicitud,tenga en cuenta que la hora está en UTC y en SEGUNDOS,
    /// tendrá 15 segundos antes de que necesite crear una nueva ,o su
    /// solicitud será rechazada (error.type: Invalid timestamp).
    final authTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();

    /// Genera el UNIQ-TOKEN: Es la representación hexadecimal de un hash que
    /// sha256 genera a partir de la cadena 'clave-secreta' + 'marca de tiempo',
    /// la clave secreta la proporciona el equipo de Paymentez.
    final uniqTokenString = '$appKey$authTimeStamp';
    final uniqToken = sha256.convert(utf8.encode(uniqTokenString)).toString();

    /// Todas las solicitudes deben tener el encabezado Auth-Token:Esta es una
    /// cadena codificada en base64, la cadena debe crearse de la siguiente
    /// manera (considere el; entre cada uno):
    /// APPLICATION-CODE;UNIXTIMESTAMP;UNIQ-TOKE
    final stringAuthToken = '$appCode;$authTimeStamp;$uniqToken';
    final authToken = base64Encode(utf8.encode(stringAuthToken));
    return authToken;
  }

  /// ============ALGORITMO DE LUHN==============///
  /// https://en.wikipedia.org/wiki/Luhn_algorithm
  /// https://www.discoverglobalnetwork.com/downloads/IPP_VAR_Compliance.pdf
  /// https://en.wikipedia.org/wiki/Payment_card_number
  ///
  /// Necesita el numero de tarjeta sin espacios ni guion
  static bool validCard(String numCard) {
    var sum = 0;
    final length = numCard.length;
    for (var i = 0; i < length; i++) {
      var digit = int.parse(numCard[length - i - 1]);
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
    final rng = Random();
    var resp = '';
    for (var i = 0; i < len; i++) {
      resp += rng.nextInt(10).toString();
    }
    return resp;
  }

  static String formatDate(DateTime now) {
    final day = (now.day < 10) ? '0${now.day.toString()}' : now.day.toString();
    final month =
        (now.month < 10) ? '0${now.month.toString()}' : now.month.toString();
    final year = now.year.toString();
    return '$day/$month/$year';
  }

  static String formatHour(DateTime now) {
    final hour =
        (now.hour < 10) ? '0${now.hour.toString()}' : now.hour.toString();
    final minute =
        (now.minute < 10) ? '0${now.minute.toString()}' : now.minute.toString();
    final second =
        (now.second < 10) ? '0${now.second.toString()}' : now.second.toString();
    return '$hour:$minute:$second';
  }
}
