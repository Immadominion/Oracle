import 'package:flutter/material.dart';

class OracleColors {
  static Color appBackgroundColor = const Color.fromARGB(255, 239, 239, 239);
  static List<Color> containerGradient = const [
    Color.fromARGB(255, 0, 176, 215), 
    Color.fromARGB(255, 0, 136, 195), 
    Color.fromARGB(255, 102, 224, 255), 
  ];

  static Color darkBackgroundColor = const Color.fromRGBO(51, 51, 51, 1);
  static Color lightBackgroundColor = const Color.fromRGBO(255, 255, 255, 1);
  static Color dashboardWhiteColor = const Color.fromRGBO(255, 255, 255, 0.1);
  static Color whitePaddingColor = const Color.fromRGBO(240, 240, 240, 1);
  static Color darkPaddingColor = const Color.fromRGBO(130, 70, 243, 0.5);

  static Color darkColor = const Color.fromARGB(255, 0, 0, 0);
  static Color mildLightColor = const Color.fromARGB(255, 214, 214, 214);
  static Color successColor = const Color.fromARGB(255, 24, 189, 38);
  static Color primary = const Color.fromARGB(255, 0, 176, 215);
  static Color primaryDark = const Color.fromRGBO(0, 120, 215, 1);

  static const MaterialColor errorColor = MaterialColor(
    _errorColorValue,
    <int, Color>{
      50: Color(0xFFFDEEEE),
      100: Color(0xFFFCE6E6),
      200: Color(0xFFF9CBCB),
      300: Color(_errorColorValue),
      400: Color(0xFFD44E4E),
      500: Color(0xFFBC4646),
      600: Color(0xFFB04141),
      700: Color(0xFF8D3434),
      800: Color(0xFF6A2727),
      900: Color(0xFF521E1E),
    },
  );

  static const Color lightColor = Color(0xffffffff);
  static const Color mildGrey = Color.fromARGB(255, 51, 50, 50);
  static const MaterialColor primaryColor =
      MaterialColor(_primaryColorValue, <int, Color>{
    50: Color(0xFFFFF3E0),
    100: Color(0xFFFFE0B2),
    200: Color(0xFFFFCC80),
    300: Color(0xFFFFB74D),
    400: Color(0xFFFFA726),
    500: Color(0x000ffeee), // Your custom color: rgb(254, 85, 46)
    600: Color(0xFFFB8C00),
    700: Color(0xFFF57C00),
    800: Color(0xFFEF6C00),
    900: Color(0xFFE65100),
  });

  static Color secondaryTextColor = const Color(0xff53505b);

  static const int _errorColorValue = 0xFFB42318;
  static const int _primaryColorValue = 0xFFfa7f41;
}
