import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle/core/theme/env_theme_manager.dart';
import 'package:oracle/presentation/splash.dart';
import 'package:reown_appkit/reown_appkit.dart';

import 'data/controllers/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(
    child: Oracle(),
  ));
}

late ReownAppKitModal appKitModal;

Future<ReownAppKitModal> initializeAppKitModal() async {
  ReownAppKitModalNetworks.removeSupportedNetworks('eip155');
  ReownAppKitModalNetworks.removeSupportedNetworks('bitcoin');

  appKitModal = ReownAppKitModal(
    context: navigatorKey.currentContext!,
    projectId: '2009f3949892128ca51c1d44fd59e939',
    logLevel: LogLevel.nothing,
    metadata: const PairingMetadata(
      name: 'Oracle AI',
      description: 'AI Memecoin trading padre',
      url: 'https://certifyme.live/',
      icons: ['assets/images/oracle.png'],
    ),
    optionalNamespaces: {
      'solana': RequiredNamespace.fromJson({
        'chains': ReownAppKitModalNetworks.getAllSupportedNetworks(
          namespace: 'solana',
        ).map((chain) => 'solana:${chain.chainId}').toList(),
        'methods': NetworkUtils.defaultNetworkMethods['solana']!.toList(),
        'events': [],
      }),
    },
    featuresConfig: FeaturesConfig(
      email: true,
      socials: [
        AppKitSocialOption.X,
        AppKitSocialOption.Apple,
      ],
      showMainWallets: false,
    ),
  );

  await appKitModal.init();

  return appKitModal;
}

final navigatorKey = GlobalKey<NavigatorState>();

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
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return MaterialApp(
            title: "Oracle",
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            darkTheme: EnvThemeManager.darkTheme,
            theme: EnvThemeManager.lightTheme,
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: FutureBuilder(
                future: initializeAppKitModal(),
                builder: (context, snapshot) {
                  // First check if still loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  // Then check for errors
                  if (snapshot.hasError) {
                    return Scaffold(
                      body: Center(
                        child: Text(
                          'Error initializing appKitModal: ${snapshot.error}',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                    );
                  }
                  // Finally, handle the success case
                  if (snapshot.hasData) {
                    final appKitModal = snapshot.data!;
                    log("App kit info >> $appKitModal");
                    return Stack(
                      children: [
                        OracleSplash(
                          appKitModal: appKitModal,
                        ),
                        AppKitModalConnectButton(
                          appKit: appKitModal,
                          custom: const SizedBox.shrink(),
                        ),
                      ],
                    );
                  }

                  // Fallback case (should rarely happen)
                  return const Scaffold(
                    body: Center(
                      child: Text('Unexpected state: No data available'),
                    ),
                  );
                }));
      },
    );
  }
}
