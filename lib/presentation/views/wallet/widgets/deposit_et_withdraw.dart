import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle/core/extensions/widget_extension.dart';

class DepositWithdrawWidget extends StatelessWidget {
  const DepositWithdrawWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              debugPrint("Deposit pressed");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 16.sp),
            ),
            child: Text(
              'Deposit',
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        SizedBox(width: 16.sp),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Handle withdraw button press
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 16.sp),
            ),
            child: Text(
              'Withdraw',
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    ).afmPadding(
      EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
    );
  }
}
