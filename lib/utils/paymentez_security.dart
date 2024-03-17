import 'dart:convert';

import 'package:crypto/crypto.dart';

class PaymentezSecurity {
  const PaymentezSecurity._();

  static String getAuthToken({
    required String appCode,
    required String appKey,
    int? unixtime,
  }) {
    var authTimeStamp = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    if (unixtime != null) {
      authTimeStamp = unixtime;
    }
    final uniqTokenString = '$appKey$authTimeStamp';
    final uniqToken = sha256.convert(utf8.encode(uniqTokenString)).toString();
    final stringAuthToken = '$appCode;$authTimeStamp;$uniqToken';
    final authToken = base64Encode(utf8.encode(stringAuthToken));
    return authToken;
  }
}
