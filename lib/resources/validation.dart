abstract class StringValidation {
  String? amountValidation(String amount);
  String? readingValidation(String reading);
  String? nameValidation(String name);
}

class Validation extends StringValidation {
  static final RegExp nameRegExp = RegExp(r'[a-zA-Z]');
  static final RegExp readingRegExp = RegExp(r'[0-9]');

  @override
  String? amountValidation(String? amount) {
    if (amount == null) {
      return 'Enter an amount';
    } else {
      return int.tryParse(amount.trim().replaceAll(',', '')) != null
          ? null
          : 'Invalid amount';
    }
  }

  @override
  String? nameValidation(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Enter Your Full Name';
    } else {
      return nameRegExp.hasMatch(name) ? null : 'Enter a Valid Full Name';
    }
  }

  @override
  String? readingValidation(String? reading) {
    if (reading == null || reading.trim().isEmpty) {
      return 'Enter New Reading';
    } else {
      if (readingRegExp.hasMatch(reading)) {
        return reading.length == 4 ? null : 'Must be 4 Number';
      } else {
        return 'Enter Valid Reading';
      }
    }
  }
}
