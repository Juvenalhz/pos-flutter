import 'package:flutter/material.dart';

class InputValidation {
  static final tpduNumber = RegExp(r'(^[0-9]{10}$)');
  static final ipv4 = RegExp(r'^(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)$');

  static String tpduValidator(String value) {
    if (value == null || value.isEmpty)
      return 'Este campo es requerido';
    else if (!tpduNumber.hasMatch(value.trim()))
      return 'TPDU no valido';
    else
      return null;
  }

  static String defaultPasswordValidator(String value) {
    if (value == null || value.isEmpty)
      return 'Este campo es requerido';
    else if (value.length <= 3)
      return 'Clave muy corta';
    else
      return null;
  }

  static String requiredField(String value) {
    if (value == null || value.isEmpty)
      return 'Campo requerido';
    else
      return null;
  }

  static String ipv4Validator(String value) {
    if (value == null || value.isEmpty)
      return 'Este campo es requerido';
    else if (!ipv4.hasMatch(value.trim())) {
      return 'Dirección IP no valida';
    }
    return null;
  }
}
