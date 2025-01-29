import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oracle/core/extensions/widget_extension.dart';
import 'package:oracle/data/controllers/wallet_controller.dart';

import '../views/auth/login.dart';

class TopBarWidget extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final String text;
  @override
  Size get preferredSize => Size.fromHeight(80.h);
  const TopBarWidget({super.key, required this.text});

  @override
  TopBarWidgetState createState() => TopBarWidgetState();
}

class TopBarWidgetState extends ConsumerState<TopBarWidget> {
  @override
  Widget build(BuildContext context) {
    final appKitModal = ref.watch(walletControllerProvider);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 7,
          child: Text(
            widget.text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontFamily: "Int",
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                CupertinoIcons.bell,
                size: 24.r,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              //I want this icon on tap to log us out of the reown wallet kit session and lead back to the loginpage
              IconButton(
                icon: Icon(
                  CupertinoIcons.person,
                  size: 24.r,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () async {
                  try {
                    await appKitModal.appKitModal?.disconnect();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Logout failed: $e')),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ],
    ).afmPadding(
      EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
    );
  }
}
