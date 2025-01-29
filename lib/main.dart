import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:oracle/core/theme/env_theme_manager.dart';
import 'package:oracle/data/controllers/wallet_controller.dart'; // Import wallet controller
import 'package:oracle/presentation/splash.dart';

import 'data/controllers/theme_notifier.dart';
import 'utils/locator.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpLocator();

  runApp(const ProviderScope(
    child: Oracle(),
  ));
}

class Oracle extends ConsumerStatefulWidget {
  const Oracle({super.key});

  @override
  ConsumerState<Oracle> createState() => _OracleState();
}

class _OracleState extends ConsumerState<Oracle> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider).isDarkMode;
    debugPrint(
        "The screen is on >> ${isDarkMode ? 'Dark mode' : 'Light mode'}");
    return ScreenUtilInit(
      designSize: ScreenUtil.defaultSize,
      builder: (context, child) {
        return OKToast(
          child: MaterialApp(
            title: "Oracle",
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            darkTheme: EnvThemeManager.darkTheme,
            theme: EnvThemeManager.lightTheme,
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: Consumer(
              builder: (context, ref, child) {
                final walletController = ref.watch(walletControllerProvider);

                return FutureBuilder(
                  future: walletController.appKitModal == null
                      ? walletController.initializeAppKitModal()
                      : null,
                  builder: (context, snapshot) {
                    if (walletController.appKitModal == null) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }

                    return const OracleSplash();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
