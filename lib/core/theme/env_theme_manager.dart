import 'package:flutter/material.dart';
import '../constants/env_colors.dart';

class EnvThemeManager {
  EnvThemeManager._();

  static String get fontFamily => 'Int'; // Update as per your preferred font

  static ThemeData lightTheme = themeData(_lightColorScheme);
  static ThemeData darkTheme = themeData(_darkColorScheme);

 static final ColorScheme _lightColorScheme = const ColorScheme.light().copyWith(
  primary: CertifyColors.primary,
  error: CertifyColors.errorColor,
  background: CertifyColors.appBackgroundColor,
  inverseSurface: CertifyColors.darkBackgroundColor,
  surface: CertifyColors.lightBackgroundColor,
  onBackground: CertifyColors.darkColor,
  onPrimary: CertifyColors.darkColor,
  shadow: CertifyColors.darkColor,
  onPrimaryContainer: CertifyColors.darkColor,
  onInverseSurface: CertifyColors.dashboardWhiteColor,
  onSecondary: CertifyColors.darkColor,
  onSurface: CertifyColors.darkColor,
  onSurfaceVariant: CertifyColors.whitePaddingColor,
  onTertiary: CertifyColors.darkColor.withOpacity(0.5),
  onErrorContainer: CertifyColors.lightColor,
  onTertiaryContainer: CertifyColors.darkBackgroundColor,
  onSecondaryContainer: CertifyColors.whitePaddingColor,
  brightness: Brightness.light,
  secondary: CertifyColors.mildLightColor,
);

 static final ColorScheme _darkColorScheme = const ColorScheme.dark().copyWith(
  primary: CertifyColors.primary,
  error: CertifyColors.errorColor,
  background: CertifyColors.darkBackgroundColor,
  surface: CertifyColors.darkBackgroundColor,
  onBackground: CertifyColors.lightColor,
  onPrimary: CertifyColors.lightColor,
  shadow: CertifyColors.lightColor,
  onSurface: CertifyColors.lightColor,
  onError: CertifyColors.lightColor,
  onSecondary: CertifyColors.lightColor,
  onInverseSurface: CertifyColors.darkBackgroundColor.withOpacity(0.5),
  brightness: Brightness.dark,
  secondary: CertifyColors.mildGrey,
  onSecondaryContainer: CertifyColors.darkPaddingColor,
  onSurfaceVariant: CertifyColors.lightColor,
  primaryContainer: CertifyColors.darkColor,
);

  static ThemeData themeData(ColorScheme colorScheme) => ThemeData(
        scaffoldBackgroundColor: colorScheme.background,
        colorScheme: colorScheme,
        fontFamily: fontFamily,
        useMaterial3: false,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        appBarTheme: AppBarTheme(backgroundColor: colorScheme.background),
      );
}
