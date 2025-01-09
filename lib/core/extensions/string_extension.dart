import 'package:intl/intl.dart';

/// This file contains the extensions for the String class.
extension StringExtensions on String {
  String get svg => "assets/svgs/$this.svg";
  String get png => "assets/images/$this.png";
  String get jpg => "assets/images/$this.jpg";
  String get jpeg => "assets/images/$this.jpeg";
  String get json => "assets/images/lottie/$this.json";

  //? Usage 'calendar'.svg

  /// This method will return the string with the first letter capitalized.
  String get capitalizeFirstLetter {
    if (isEmpty) return this;
    return toBeginningOfSentenceCase(this).toString();
  }

  /// This method will return the file extension of the string.
  String? get getFileExtension {
    try {
      return split('.').last;
    } catch (e) {
      return null;
    }
  }
}
