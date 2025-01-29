import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oracle/core/extensions/widget_extension.dart';
import 'package:oracle/presentation/views/dashboard.dart';
import 'package:reown_appkit/reown_appkit.dart';

import '../../../data/controllers/wallet_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  ReownAppKitModal? appKitModal;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        appKitModal = ref.read(walletControllerProvider).appKitModal!;
      });

      if (appKitModal != null) {
        appKitModal!.addListener(_checkConnectionStatus);
      }
    });

    // Delay listener registration until the widget is fully built
    appKitModal?.addListener(_checkConnectionStatus);
  }

  void _checkConnectionStatus() {
    if (appKitModal?.isConnected == true && !_isConnected) {
      setState(() {
        _isConnected = true;
      });

      // Use `mounted` to ensure the widget is still in the widget tree
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashBoard()),
        );
      }
    }
  }

  @override
  void dispose() {
    // Clean up the listener to prevent memory leaks
    appKitModal?.removeListener(_checkConnectionStatus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Sign in to continue',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              Image.asset(
                'assets/images/oracle.png',
                height: 200.h,
              ).afmBorderRadius(BorderRadius.circular(15.r)),
              const SizedBox(height: 40),
              AppKitModalNetworkSelectButton(
                context: context,
                appKit: appKitModal!,
              ),
              const SizedBox(height: 40),
              Center(
                child: AppKitModalConnectButton(
                  context: context,
                  appKit: appKitModal!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
