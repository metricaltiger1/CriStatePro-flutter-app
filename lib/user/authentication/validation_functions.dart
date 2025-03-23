class Validators {
  static bool isValidPhone(String? inputString, {bool isRequired = false}) {
    bool isInputStringValid = false;

    if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
      isInputStringValid = true;
    }

    if (inputString != null && inputString.isNotEmpty) {
      if (inputString.length > 16 || inputString.length < 6) return false;

      const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
      final regExp = RegExp(pattern);
      isInputStringValid = regExp.hasMatch(inputString);
    }

    return isInputStringValid;
  }

  static bool isValidPassword(String? inputString, {bool isRequired = false}) {
    bool isInputStringValid = false;

    if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
      isInputStringValid = true;
    }

    if (inputString != null && inputString.isNotEmpty) {
      const pattern =
          r'^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{8,}$';
      final regExp = RegExp(pattern);
      isInputStringValid = regExp.hasMatch(inputString);
    }

    return isInputStringValid;
  }

  static bool isText(String? inputString, {bool isRequired = false}) {
    bool isInputStringValid = false;

    if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
      isInputStringValid = true;
    }

    if (inputString != null && inputString.isNotEmpty) {
      const pattern = r'^[a-zA-Z]+$';
      final regExp = RegExp(pattern);
      isInputStringValid = regExp.hasMatch(inputString);
    }

    return isInputStringValid;
  }

  static bool isNumeric(String? inputString, {bool isRequired = false}) {
    bool isInputStringValid = false;

    if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
      isInputStringValid = true;
    }

    if (inputString != null && inputString.isNotEmpty) {
      const pattern = r'^\d+$';
      final regExp = RegExp(pattern);
      isInputStringValid = regExp.hasMatch(inputString);
    }

    return isInputStringValid;
  }

  static bool isValidEmail(String? inputString, {bool isRequired = false}) {
    bool isInputStringValid = false;

    if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
      isInputStringValid = true;
    }

    if (inputString != null && inputString.isNotEmpty) {
      const pattern =
          r'^[a-zA-Z0-9._%+-]+@(gmail|yahoo|email|outlook)\.(com|co\.uk|co\.fr|co\.de|co\.in|co\.ke|co\.us)$';
      final regExp = RegExp(pattern);
      isInputStringValid = regExp.hasMatch(inputString);
    }

    return isInputStringValid;
  }
}
