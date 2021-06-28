import 'package:flutter/foundation.dart';

class OrderPay {
  OrderPay({
    @required this.devReference,
    @required this.amount,
    @required this.description,
    @required this.vat,
    this.installments,
    this.installmentsType,
    this.taxableAmount,
    this.taxPercentage,
  });

  /// Referencia de la orden en el comercio. Usted identificará esta compra
  /// utilizando esta referencia, puede ser el Primary Key o algun codigo que
  /// se refleje como identificador de la orden o compra.
  final String devReference;

  /// Monto a cobrar. Formato: decimal con dos dígitos de fracción. ejemplo 0.00
  final double amount;

  /// Descripción de la orden a ser comprada. Validar: (Longitud Maxima 250)
  final String description;

  /// Importe del impuesto sobre las ventas, incluido en el costo del producto.
  /// Formato: decimal con dos dígitos de fracción. (0.00)
  final double vat;

  /// Solo disponible para Ecuador y México. Ver los valores válidos
  /// si es al contado(debit) colocal 0
  /// si es al corriente(credito) colocar 0 para corriente directo
  /// o numero de cuotas 3, 6, 12, 15, 18.
  final int installments;

  /// colocar el tipo segundo el listado, obtenga el listado con
  /// PaymentezValidate.geStatusDetailDescription()
  final int installmentsType;

  /// Solo disponible para Ecuador. El importe imponible es el total de todos
  /// los items imponibles o gravables excluyendo el iva. Si no se envía, se
  /// calcula sobre el total. Formato: decimal con dos dígitos de fracción.
  final double taxableAmount;

  /// Solo disponible para Ecuador. La tasa de impuesto que se aplicará a este
  /// pedido. Debe de ser 0 o 12.
  final int taxPercentage;
}
