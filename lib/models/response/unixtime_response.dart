import 'package:paymentez_sdk/utils/utils.dart';

class UnixtimeResponse {
  UnixtimeResponse({
    required this.unixtime,
    required this.timezone,
  });

  factory UnixtimeResponse.fromJson(Map<String, dynamic> json) =>
      UnixtimeResponse(
        unixtime: json.getInt('unixtime'),
        timezone: json['timezone'] as String,
      );

  final int unixtime;
  final String timezone;

  Map<String, dynamic> toJson() => {
        'unixtime': unixtime,
        'timezone': timezone,
      };
}
