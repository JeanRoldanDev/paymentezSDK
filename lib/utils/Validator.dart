import 'package:flutter/foundation.dart';

//http://hg.openjdk.java.net/jdk7u/jdk7u6/jdk/file/8c2c5d63a17e/src/share/classes/java/lang/String.java
extension Validator on String {
  bool get cgzIsText => ValidatorUtils.isTextPro(this);
  bool get cgzIsEMail => ValidatorUtils.isEmailPro(this);
  bool get cgzIsPass => ValidatorUtils.isPass(this);
  bool get cgzHaveContinuousSpaces => ValidatorUtils.haveContinuousSpaces(this);
  bool cgzIsMaxlength(int b) => ValidatorUtils.maxlength(this, b);
  bool get cgzIsCedula => ValidatorUtils.validarCedula(this);
  bool get cgzIsRuc => ValidatorUtils.validarRuc(this);
  bool get cgzIsPhoneNumber => ValidatorUtils.validarTelefono(this);
}

extension DateFormat on DateTime {
  String get cgzGetFech => ValidatorUtils.formatFech(this);
  String get cgzGetHour => ValidatorUtils.formatHour(this);
}

class ValidatorUtils {
  ValidatorUtils._();

  static String formatFech(DateTime now) {
    final day = (now.day < 10) ? '0{$now.day.toString()}' : now.day.toString();
    final month =
        (now.month < 10) ? '0{$now.month.toString()}' : now.month.toString();
    final year = now.year.toString();
    final result = '$day/$month/$year';
    return result;
  }

  static String formatHour(DateTime now) {
    final hour =
        (now.hour < 10) ? '0{$now.hour.toString()}' : now.hour.toString();
    final minute =
        (now.minute < 10) ? '0{$now.minute.toString()}' : now.minute.toString();
    final second =
        (now.second < 10) ? '0{$now.second.toString()}' : now.second.toString();
    final result = '$hour:$minute:$second';
    return result;
  }

  static bool isEmailPro(String string) {
    final regExp = RegExp(
        r'^([a-zA-Z0-9._-]{2,})@((\[[0–9]{1,3}\.[0–9]{1,3}\.[0–9]{1,3}\.[0–9]{1,3}])|(([a-zA-Z\-0–9]{2,}\.)+[a-zA-Z]{2,}))$');
    return regExp.hasMatch(string);
  }

  static bool isPass(String string) {
    final regExp =
        RegExp(r'(?=\w*[0-9]{1,})(?=\w*[A-Z]{1,})(?=\w*[a-z]{1,})\S{8,15}');
    return regExp.hasMatch(string);
  }

  static bool isTextPro(String string) {
    //VALIDA SI SOLO ES TEXTO
    final regExp = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚ ]{2,200}$');
    return regExp.hasMatch(string);
  }

  static bool haveContinuousSpaces(String string) {
    //VALIDA QUE NO TENGA NOS ESPACIOS SEGIDOS
    final regExp = RegExp(r'\s{2,}');
    return regExp.hasMatch(string);
  }

  static bool maxlength(String string, int max) => (string.length > max);

  static bool validarTelefono(String string) {
    final regExp = RegExp(r'^[0-9 ]{12,12}$');
    return regExp.hasMatch(string);
  }

  static bool validarCedula(String string) {
    try {
      validarInicial(string, 10);
      validarCodigoProvincia(string.substring(0, 2));
      validarTercerDigito(string.substring(2, 3), TypeDocument.cedula);
      algoritmoModulo10(
        string.substring(0, 9),
        int.parse(string.substring(9, 10)),
      );
    } catch (e) {
      return false;
    }
    return true;
  }

  static bool validarRuc(String string) {
    try {
      validarInicial(string, 13);
      validarCodigoProvincia(string.substring(0, 2));
      validarTercerDigito(string.substring(2, 3), TypeDocument.rucNatural);
      validarCodigoEstablecimiento(string.substring(10, 13));
      algoritmoModulo10(
          string.substring(0, 9), int.parse(string.substring(9, 10)));
    } catch (e) {
      return false;
    }
    return true;
  }

  @protected
  static bool validarInicial(String numero, int caracteres) {
    if (numero.isEmpty) {
      throw Exception('Valor no puede estar vacio');
    }

    final _numeric = RegExp(r'^-?[0-9]+$');
    if (!_numeric.hasMatch(numero)) {
      throw Exception('Valor ingresado solo puede tener dígitos');
    }

    if (numero.length != caracteres) {
      throw Exception(
          'Valor ingresado debe tener {$caracteres.toString()} caracteres');
    }

    return true;
  }

  @protected
  static bool validarCodigoProvincia(String numero) {
    if (int.parse(numero) < 0 || int.parse(numero) > 24) {
      throw Exception(
          'Codigo de Provincia (dos primeros dígitos) no deben ser mayor a 24 ni menores a 0');
    }
    return true;
  }

  @protected
  static bool validarTercerDigito(String numero, int tipo) {
    switch (tipo) {
      case TypeDocument.cedula:
      case TypeDocument.rucNatural:
        if (int.parse(numero) < 0 || int.parse(numero) > 5) {
          throw Exception(
              'Tercer dígito debe ser mayor o igual a 0 y menor a 6 para cédulas y RUC de persona natural ... permitidos de 0 a 5');
        }
        break;
      case TypeDocument.rucPrivada:
        if (int.parse(numero) != 9) {
          throw Exception(
              'Tercer dígito debe ser igual a 9 para sociedades privadas');
        }
        break;
      case TypeDocument.rucPublica:
        if (int.parse(numero) != 6) {
          throw Exception(
              'Tercer dígito debe ser igual a 6 para sociedades públicas');
        }
        break;
      default:
        throw Exception('Tipo de Identificacion no existe.');
    }
    return true;
  }

  @protected
  static bool validarCodigoEstablecimiento(String numero) {
    if (int.parse(numero) < 1) {
      throw Exception('Código de establecimiento no puede ser 0');
    }
    return true;
  }

// https://github.com/diaspar/validacion-cedula-ruc-ecuador/blob/master/validadores/php/ValidarIdentificacion.php
  @protected
  static bool algoritmoModulo10(
      String digitosInicialesDAT, int digitoVerificador) {
    final arrayCoeficientes = List<int>.from([2, 1, 2, 1, 2, 1, 2, 1, 2]);
    final digitosIniciales = digitosInicialesDAT.split('').toList();
    var total = 0;
    for (var i = 0; i < digitosIniciales.length; i++) {
      var valorPosicion = int.parse(digitosIniciales[i]) * arrayCoeficientes[i];
      if (valorPosicion >= 10) {
        final valor1 = int.parse(valorPosicion.toString().split('')[0]);
        final valor2 = int.parse(valorPosicion.toString().split('')[1]);
        valorPosicion = valor1 + valor2;
      }
      total = total + valorPosicion;
    }
    final residuo = (total % 10);
    int resultado;
    if (residuo == 0) {
      resultado = 0;
    } else {
      resultado = (10 - residuo);
    }
    if (resultado != digitoVerificador) {
      throw Exception('Dígitos iniciales no validan contra Dígito Idenficador');
    }
    return true;
  }
}

class TypeDocument {
  static const int none = 0;
  static const int cedula = 1;
  static const int rucNatural = 2;
  static const int rucPrivada = 3;
  static const int rucPublica = 4;
}
