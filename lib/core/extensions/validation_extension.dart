import 'package:flutter/material.dart';

/// An extension used to easily add a validation method to a [TextFormField].
/// To use the extension you need to import the file.
/// in the validator property of the [TextFormField] you can add this extension by,
/// context.validateEmail, context.validatePassword, context.validateName, context.validatePhoneNumber.
/// E.G TextFormField(validator: context.validateEmail)
extension ValidationExtension on BuildContext {
  String? validateFieldNotEmpty(String? value) =>
      value == null || value.isEmpty ? 'Field cannot be empty' : null;

  String? validateFieldNotNull<T>(T? value) =>
      value == null ? 'Field cannot be empty' : null;

  String? validateEmailAddress(String? value) {
    if (value == null) return 'Field cannot be empty';

    if (value.isEmpty) return 'Field cannot be empty';

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);

    return !emailValid ? 'Enter a Valid Email Address' : null;
  }

  String? validatePassword(String? value) => value == null || value.length < 6
      ? 'Passowrd must have 6 or more characters'
      : null;

  String? validateConfirmPassword(
      {required String? value, required String? initialPassword}) {
    if (value == null || value.isEmpty) return 'Field cannot be empty';
    bool isConfirmed = value != initialPassword;
    return (isConfirmed) ? 'Passwords do not match' : null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) return 'Field cannot be empty';

    bool isPhoneValid = RegExp(r'(^(?:9)?[0-9]{11}$)').hasMatch(value);

    return (isPhoneValid) ? null : 'Please enter a valid phone number';
  }

  String? validateFullName<T>(String? value) {
    if (value == null) return 'Field cannot be empty';

    if (value.isEmpty) return 'Field cannot be empty';

    if (value.split(' ').length < 2) {
      return 'Please enter your FULL NAME';
    } else {
      return null;
    }
  }

  String? validateOnlyNumbers(String? value) {
    if (value == null) return 'Field cannot be empty';

    if (value.isEmpty) return 'Field cannot be empty';

    final isNumber = RegExp(r'^[0-9]+$').hasMatch(value);

    return isNumber ? null : 'Please enter a valid number';
  }

  /// This method is used to prevent the user from adding space.
  RegExp validateNoSpacesInBetween() => RegExp(r'\s');
}