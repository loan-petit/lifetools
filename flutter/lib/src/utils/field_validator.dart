import 'package:validators/validators.dart';

/// Validate fields of different types.
class FieldValidator {
  /// Validate that the input isn't empty.
  static String validateText(String value) {
    if (value.isEmpty) {
      return 'Enter some text';
    }
    return null;
  }

  /// Validate that the input is a well formatted email.
  static String validateEmail(String value) {
    if (value.isEmpty) return 'Email can\'t be empty!';

    if (!isEmail(value)) {
      return 'Please enter a valid username address.';
    }
    return null;
  }

  /// Validate that the input is a well formatted password.
  static String validatePassword(String value) {
    if (value.isEmpty) return 'Password can\'t be empty!';

    if (value.length < 7) {
      return 'Password must be more than 6 charaters';
    }
    return null;
  }
}
