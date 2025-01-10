import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle/core/extensions/widget_extension.dart';
import 'package:reown_appkit/reown_appkit.dart';

import 'deposit_bottom_sheet.dart';
import 'withdraw_bottom_sheet.dart';

class DepositWithdrawWidget extends StatelessWidget {
  final ReownAppKitModal appKit;
  const DepositWithdrawWidget({super.key, required this.appKit});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return const DepositBottomSheet();
                },
              );
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
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return const WithdrawBottomSheet();
                },
              );
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
