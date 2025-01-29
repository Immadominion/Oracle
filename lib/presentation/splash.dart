import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oracle/data/controllers/wallet_controller.dart';
import 'package:oracle/presentation/views/auth/login.dart';
import 'package:oracle/presentation/views/dashboard.dart';
import 'package:page_transition/page_transition.dart';

class OracleSplash extends ConsumerStatefulWidget {
  const OracleSplash({super.key});

  @override
  ConsumerState<OracleSplash> createState() => _OracleSplashState();
}

class _OracleSplashState extends ConsumerState<OracleSplash> {
  @override
  void initState() {
    super.initState();

    // Delay for splash screen display
    Timer(const Duration(seconds: 2), _navigateBasedOnConnection);
  }

  /// Navigates to the appropriate screen based on wallet connection
  void _navigateBasedOnConnection() {
    final walletController = ref.read(walletControllerProvider);
    final appKitModal = walletController.appKitModal;

    if (appKitModal == null) {
      // Handle case where appKitModal is not initialized
      return;
    }

    // Check if the appKitModal is connected
    if (appKitModal.isConnected) {
      // Navigate to Dashboard if connected
      Navigator.of(context).pushReplacement(
        PageTransition(
          type: PageTransitionType.bottomToTop,
          child: const DashBoard(),
        ),
      );
    } else {
      // Navigate to LoginPage if not connected
      Navigator.of(context).pushReplacement(
        PageTransition(
          type: PageTransitionType.bottomToTop,
          child: const LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Image.asset(
          "assets/images/oracle.png",
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}