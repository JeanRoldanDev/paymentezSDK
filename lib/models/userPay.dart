class UserPay {
  UserPay({
    this.id,
    this.email,
    this.phone,
  });

  /// ### ===============ES===============
  ///
  /// **[id]** Es el identificador que usa dentro de su aplicación.
  /// es recomendable *NO* usar la llave primaria de tu tabla USERS
  /// si no más bien agregar una nueva columna o tabla dentro de tu modelo
  /// entidad relación (Base de datos).
  /// nosotros recomendamos usar como identificador un token de
  /// 15 a 20 caracteres alfanuméricos.
  final String id;

  /// ### ===============ES===============
  /// **[email]** Correo electrónico del comprador, con formato de correo
  /// electrónico válido.
  /// para validar el correo implemente puede implementar nuestra validacion
  /// de esta forma:
  ///
  /// import 'package:paymentez/utils/validator.dart';
  /// 'example@gmail.com'.isEmailFull; retorna un bool
  ///
  /// NOTA: la responsabilidad de esta validación es responsabilidad suya
  /// dado que este correo tiene que ser validado dentro del registro del
  /// usuario u otro método del mismo.
  final String email;

  /// ### ===============ES===============
  /// **[phone]** Teléfono del comprador. dado que este módulo fue hecho con el
  /// objetivo de dar soporte para Paymentez Ecuador en lo posible queda en
  /// responsabilidad suya dar un formato correcto ejemplo +593xxxxxxxxx
  final String phone;
}
