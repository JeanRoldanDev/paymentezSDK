import 'package:paymentez_sdk/models/request/card/user_card.dart';
import 'package:paymentez_sdk/utils/utils.dart';

class GenerateTokenizeReq {
  GenerateTokenizeReq({
    required this.locale,
    required this.user,
    required this.configuration,
    required this.origin,
    required this.antifraud,
  });

  factory GenerateTokenizeReq.fromJson(Map<String, dynamic> json) =>
      GenerateTokenizeReq(
        locale: json['locale'] as String,
        user: UserCard.fromJson(json.getMap('user')),
        configuration: Configuration.fromJson(json.getMap('configuration')),
        origin: json['origin'] as String,
        antifraud: Antifraud.fromJson(json.getMap('antifraud')),
      );

  final String locale;
  final UserCard user;
  final Configuration configuration;
  final String origin;
  final Antifraud antifraud;

  Map<String, dynamic> toJson() => {
        'locale': locale,
        'user': user.toJson(),
        'configuration': configuration.toJson(),
        'origin': origin,
        'antifraud': antifraud.toJson(),
      };
}

class Antifraud {
  Antifraud({
    required this.sessionId,
    required this.location,
    required this.userAgent,
  });

  factory Antifraud.fromJson(Map<String, dynamic> json) => Antifraud(
        sessionId: json['session_id'] as String,
        location: json['location'] as String,
        userAgent: json['user_agent'] as String,
      );

  final String sessionId;
  final String location;
  final String userAgent;

  Map<String, dynamic> toJson() => {
        'session_id': sessionId,
        'location': location,
        'user_agent': userAgent,
      };
}

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
