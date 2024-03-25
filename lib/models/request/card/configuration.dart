import 'package:paymentez_sdk/utils/utils.dart';

class Configuration {
  Configuration({
    required this.defaultCountry,
    required this.requireBillingAddress,
  });

  factory Configuration.fromJson(Map<String, dynamic> json) => Configuration(
        defaultCountry: json['default_country'] as String,
        requireBillingAddress: json.getBool('require_billing_address'),
      );

  final String defaultCountry;
  final bool requireBillingAddress;

  Map<String, dynamic> toJson() => {
        'default_country': defaultCountry,
        'require_billing_address': requireBillingAddress,
      };
}
