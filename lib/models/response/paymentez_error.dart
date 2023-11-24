import 'package:paymentez_sdk/utils/dynamic_ext.dart';

class PaymentezError {
  PaymentezError({
    required this.error,
  });

  factory PaymentezError.fromJson(Map<String, dynamic> json) => PaymentezError(
        error: Error.fromJson(json.getMap('error')),
      );

  final Error error;

  Map<String, dynamic> toJson() => {
        'error': error.toJson(),
      };
}

class Error {
  Error({
    required this.type,
    required this.help,
    required this.description,
  });

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        type: json['type'] as String,
        help: json['help'] as String,
        description: json['description'],
      );

  final String type;
  final String help;
  final dynamic description;

  Map<String, dynamic> toJson() => {
        'type': type,
        'help': help,
        'description': description,
      };
}
