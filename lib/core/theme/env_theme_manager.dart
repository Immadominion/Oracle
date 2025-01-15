import 'package:flutter/material.dart';
import '../constants/env_colors.dart';

class EnvThemeManager {
  EnvThemeManager._();

  static String get fontFamily => 'Int'; // Update as per your preferred font

  static ThemeData lightTheme = themeData(_lightColorScheme);
  static ThemeData darkTheme = themeData(_darkColorScheme);

  static final ColorScheme _lightColorScheme =
      const ColorScheme.light().copyWith(
    primary: OracleColors.primary,
    error: OracleColors.errorColor,
    inverseSurface: OracleColors.darkBackgroundColor,
    surface: OracleColors.lightBackgroundColor,
    onPrimary: OracleColors.darkColor,
    shadow: OracleColors.darkColor,
    onPrimaryContainer: OracleColors.darkColor,
    onInverseSurface: OracleColors.dashboardWhiteColor,
    onSecondary: OracleColors.darkColor,
    onSurface: OracleColors.darkColor,
    onSurfaceVariant: OracleColors.whitePaddingColor,
    onTertiary: OracleColors.darkColor.withOpacity(0.5),
    onErrorContainer: OracleColors.lightColor,
    onTertiaryContainer: OracleColors.darkBackgroundColor,
    onSecondaryContainer: OracleColors.whitePaddingColor,
    brightness: Brightness.light,
    secondary: OracleColors.mildLightColor,
  );

  static final ColorScheme _darkColorScheme = const ColorScheme.dark().copyWith(
    primary: OracleColors.primary,
    error: OracleColors.errorColor,
    surface: OracleColors.darkBackgroundColor,
    onPrimary: OracleColors.lightColor,
    shadow: OracleColors.lightColor,
    onSurface: OracleColors.lightColor,
    onError: OracleColors.lightColor,
    onSecondary: OracleColors.lightColor,
    onInverseSurface: OracleColors.darkBackgroundColor.withOpacity(0.5),
    brightness: Brightness.dark,
    secondary: OracleColors.mildGrey,
    onSecondaryContainer: OracleColors.darkPaddingColor,
    onSurfaceVariant: OracleColors.lightColor,
    primaryContainer: OracleColors.darkColor,
  );

  static ThemeData themeData(ColorScheme colorScheme) => ThemeData(
        scaffoldBackgroundColor: colorScheme.surface,
        colorScheme: colorScheme,
        fontFamily: fontFamily,
        useMaterial3: false,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        appBarTheme: AppBarTheme(backgroundColor: colorScheme.surface),
      );
}
