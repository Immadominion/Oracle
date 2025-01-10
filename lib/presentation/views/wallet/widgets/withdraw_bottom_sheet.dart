import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WithdrawBottomSheet extends StatelessWidget {
  const WithdrawBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.sp),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Content for WithdrawBottomSheet
          Text("Hello, this is the Withdraw bottom sheet"),
          Text("Hello, this is the Withdraw bottom sheet"),
        ],
      ),
    );
  }
}
