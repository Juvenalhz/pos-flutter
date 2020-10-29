
class InputValidation {
  static final tpduNumber = RegExp(r'(^[0-9]{10}$)');
  static final passNumber = RegExp(r'(^[0-9]{6}$)');
  static final ipv4 = RegExp(r'^(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)$');

  static String tpduValidator(String value) {
    if (value == null || value.isEmpty)
      return 'Este campo es requerido';
    else if (!tpduNumber.hasMatch(value.trim()))
      return 'El TPDU debe ser de 10 digitos';
    else
      return null;
  }

  static String defaultPasswordValidator(String value) {
    if (value == null || value.isEmpty)
      return 'Este campo es requerido';
    else if (!passNumber.hasMatch(value.trim()))
      return 'La clave debe ser de 6 digitos';
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
