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

  static String getSessionId() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replaceAllMapped(
      RegExp('[xy]'),
      (match) {
        final r = DateTime.now().microsecondsSinceEpoch & 0xf;
        final v = match.group(0) == 'x' ? r : (r & 0x3 | 0x8);
        return v.toRadixString(16);
      },
    );
  }
}
