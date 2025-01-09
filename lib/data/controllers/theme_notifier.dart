import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences Provider
final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier({required bool isDarkMode})
      : super(ThemeState(isDarkMode: isDarkMode)) {
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        _onPlatformBrightnessChanged;
  }

  void _onPlatformBrightnessChanged() {
    final isSystemDarkMode =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    final isAppDarkMode = state.appDarkMode ?? isSystemDarkMode;

    if (state.appDarkMode == null) {
      state = ThemeState(
          isDarkMode: isSystemDarkMode, appDarkMode: state.appDarkMode);
    } else {
      state =
          ThemeState(isDarkMode: isAppDarkMode, appDarkMode: state.appDarkMode);
    }
  }

  void toggleTheme() {
    final newAppDarkMode = !state.isDarkMode;
    state = ThemeState(isDarkMode: newAppDarkMode, appDarkMode: newAppDarkMode);

    _savePreference(newAppDarkMode);
  }

  void setDarkMode(bool value) {
    state = ThemeState(isDarkMode: value, appDarkMode: value);
    _savePreference(value);
  }

  Future<void> _savePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }
}

class ThemeState {
  final bool isDarkMode;
  final bool? appDarkMode;

  ThemeState({
    required this.isDarkMode,
    this.appDarkMode,
  });
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  final brightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  final isSystemDarkMode = brightness == Brightness.dark;

  // Access SharedPreferences asynchronously
  final sharedPrefs = ref.watch(sharedPreferencesProvider).asData?.value;
  final isAppDarkMode = sharedPrefs?.getBool('isDarkMode');

  final isDarkMode = isAppDarkMode ?? isSystemDarkMode;

  return ThemeNotifier(isDarkMode: isDarkMode);
});
