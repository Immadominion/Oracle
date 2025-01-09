import 'dart:async';
import 'package:flutter/material.dart';
import 'package:oracle/main.dart';
import 'package:oracle/presentation/views/auth/login.dart';
import 'package:oracle/presentation/views/dashboard.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reown_appkit/reown_appkit.dart';

class OracleSplash extends StatefulWidget {
  final ReownAppKitModal appKitModal;
  const OracleSplash({super.key, required this.appKitModal}  );

  @override
  OracleSplashState createState() => OracleSplashState();
}

class OracleSplashState extends State<OracleSplash> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      setState(() {
        Navigator.of(context).pushReplacement(
          PageTransition(
            type: PageTransitionType.bottomToTop,
            // child: const DashBoard(),
            child: LoginPage(
              appKitModal: widget.appKitModal,
            ),
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
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
