import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle/core/constants/constants.dart';
import 'package:oracle/core/extensions/widget_extension.dart';


class WalletBalance extends StatelessWidget {
  const WalletBalance({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Total Balance",
          style: TextStyle(
            color:
                Theme.of(context).colorScheme.onSurface.withOpacity(.5),
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            fontFamily: "Int",
          ),
        ).afmPadding(
          EdgeInsets.only(
            bottom: 5.h,
          ),
        ),
        Text(
          "1,597,231.00\$",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            fontFamily: "Int",
          ),
        ).afmPadding(
          EdgeInsets.only(
            bottom: 1.h,
          ),
        ),
        Text(
          "+1,597,230.00\$",
          style: TextStyle(
            color: CertifyColors.successColor,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            fontFamily: "Int",
          ),
        ),
      ],
    );
  }
}
