import 'dart:async';
import 'package:flutter/material.dart';
import 'package:oracle/main.dart';
import 'package:oracle/presentation/views/auth/login.dart';
import 'package:oracle/presentation/views/dashboard.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reown_appkit/reown_appkit.dart';

class OracleSplash extends StatefulWidget {
  final ReownAppKitModal appKitModal;
  const OracleSplash({super.key, required this.appKitModal});

  @override
  OracleSplashState createState() => OracleSplashState();
}

class OracleSplashState extends State<OracleSplash> {
  @override
  void initState() {
    super.initState();

    // Delay for splash screen display
    Timer(const Duration(seconds: 2), _navigateBasedOnConnection);
  }

  /// Navigates to the appropriate screen based on wallet connection
  void _navigateBasedOnConnection() {
    // Check if the appKitModal is connected
    if (widget.appKitModal.isConnected) {
      // Navigate to Dashboard if connected
      Navigator.of(context).pushReplacement(
        PageTransition(
          type: PageTransitionType.bottomToTop,
          child: DashBoard(appKitModal),
        ),
      );
    } else {
      // Navigate to LoginPage if not connected
      Navigator.of(context).pushReplacement(
        PageTransition(
          type: PageTransitionType.bottomToTop,
          child: LoginPage(appKitModal: widget.appKitModal),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
