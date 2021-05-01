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
    String day = (now.day < 10) ? "0" + now.day.toString() : now.day.toString();
    String month = (now.month < 10) ? "0" + now.month.toString() : now.month.toString();
    String year = now.year.toString();
    String result = day + "/" + month + "/" + year;
    return result;
  }

  static String formatHour(DateTime now) {
    String hour = (now.hour < 10) ? "0" + now.hour.toString() : now.hour.toString();
    String minute = (now.minute < 10) ? "0" + now.minute.toString() : now.minute.toString();
    String second = (now.second < 10) ? "0" + now.second.toString() : now.second.toString();
    String result = hour + ":" + minute + ":" + second;
    return result;
  }

  static bool isEmailPro(String string) {
    RegExp regExp = new RegExp(r"^([a-zA-Z0-9._-]{2,})@((\[[0–9]{1,3}\.[0–9]{1,3}\.[0–9]{1,3}\.[0–9]{1,3}])|(([a-zA-Z\-0–9]{2,}\.)+[a-zA-Z]{2,}))$");
    bool matches = regExp.hasMatch(string);
    return matches;
  }

  static bool isPass(String string) {
    RegExp regExp = RegExp(r"(?=\w*[0-9]{1,})(?=\w*[A-Z]{1,})(?=\w*[a-z]{1,})\S{8,15}");
    bool estado = regExp.hasMatch(string);
    return estado;
  }

  static bool isTextPro(String string) {
    //VALIDA SI SOLO ES TEXTO
    RegExp regExp = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚ ]{2,200}$");
    bool estado = regExp.hasMatch(string);
    return estado;
  }

  static bool haveContinuousSpaces(String string) {
    //VALIDA QUE NO TENGA NOS ESPACIOS SEGIDOS
    RegExp regExp = RegExp(r"\s{2,}");
    bool estado = regExp.hasMatch(string);
    return estado;
  }

  static bool maxlength(String string, int max) => (string.length > max);

  static bool validarTelefono(String string) {
    RegExp regExp = RegExp(r"^[0-9 ]{12,12}$");
    bool estado = regExp.hasMatch(string);
    return estado;
  }

  static bool validarCedula(String string) {
    try {
      validarInicial(string, 10);
      validarCodigoProvincia(string.substring(0, 2));
      validarTercerDigito(string.substring(2, 3), TipoDocumento.cedula);
      algoritmoModulo10(string.substring(0, 9), int.parse(string.substring(9, 10)));
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  static bool validarRuc(String string) {
    try {
      validarInicial(string, 13);
      validarCodigoProvincia(string.substring(0, 2));
      validarTercerDigito(string.substring(2, 3), TipoDocumento.rucNatural);
      validarCodigoEstablecimiento(string.substring(10, 13));
      algoritmoModulo10(string.substring(0, 9), int.parse(string.substring(9, 10)));
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  @protected
  static bool validarInicial(String numero, int caracteres) {
    if (numero.isEmpty) {
      throw new Exception("Valor no puede estar vacio");
    }

    RegExp _numeric = new RegExp(r'^-?[0-9]+$');
    if (!_numeric.hasMatch(numero)) {
      throw new Exception("Valor ingresado solo puede tener dígitos");
    }

    if (numero.length != caracteres) {
      throw new Exception("Valor ingresado debe tener " + caracteres.toString() + " caracteres");
    }

    return true;
  }

  @protected
  static bool validarCodigoProvincia(String numero) {
    if (int.parse(numero) < 0 || int.parse(numero) > 24) {
      throw new Exception("Codigo de Provincia (dos primeros dígitos) no deben ser mayor a 24 ni menores a 0");
    }
    return true;
  }

  @protected
  static bool validarTercerDigito(String numero, int tipo) {
    switch (tipo) {
      case TipoDocumento.cedula:
      case TipoDocumento.rucNatural:
        if (int.parse(numero) < 0 || int.parse(numero) > 5) {
          throw new Exception("Tercer dígito debe ser mayor o igual a 0 y menor a 6 para cédulas y RUC de persona natural ... permitidos de 0 a 5");
        }
        break;
      case TipoDocumento.rucPrivada:
        if (int.parse(numero) != 9) {
          throw new Exception("Tercer dígito debe ser igual a 9 para sociedades privadas");
        }
        break;
      case TipoDocumento.rucPublica:
        if (int.parse(numero) != 6) {
          throw new Exception("Tercer dígito debe ser igual a 6 para sociedades públicas");
        }
        break;
      default:
        throw new Exception("Tipo de Identificacion no existe.");
    }
    return true;
  }

  @protected
  static bool validarCodigoEstablecimiento(String numero) {
    if (int.parse(numero) < 1) {
      throw new Exception("Código de establecimiento no puede ser 0");
    }
    return true;
  }

// https://github.com/diaspar/validacion-cedula-ruc-ecuador/blob/master/validadores/php/ValidarIdentificacion.php
  @protected
  static bool algoritmoModulo10(String digitosInicialesDAT, int digitoVerificador) {
    List<int> arrayCoeficientes = new List<int>.from([2, 1, 2, 1, 2, 1, 2, 1, 2]);
    List<String> digitosIniciales = digitosInicialesDAT.split('').toList();
    int total = 0;
    for (var i = 0; i < digitosIniciales.length; i++) {
      int valorPosicion = int.parse(digitosIniciales[i]) * arrayCoeficientes[i];
      if (valorPosicion >= 10) {
        int valor1 = int.parse(valorPosicion.toString().split('')[0]);
        int valor2 = int.parse(valorPosicion.toString().split('')[1]);
        valorPosicion = valor1 + valor2;
      }
      total = total + valorPosicion;
    }
    int residuo = (total % 10);
    int resultado;
    if (residuo == 0) {
      resultado = 0;
    } else {
      resultado = (10 - residuo);
    }
    if (resultado != digitoVerificador) {
      throw new Exception("Dígitos iniciales no validan contra Dígito Idenficador");
    }
    return true;
  }
}

class TipoDocumento {
  static const int none = 0;
  static const int cedula = 1;
  static const int rucNatural = 2;
  static const int rucPrivada = 3;
  static const int rucPublica = 4;
}
