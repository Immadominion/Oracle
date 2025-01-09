
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle/core/extensions/widget_extension.dart';
import 'package:oracle/presentation/general_components/cta_button.dart';


class PositionsBottomSheet extends StatelessWidget {
  const PositionsBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80.h,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            border: Border(
              top: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(.15),
                width: 1,
              ),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Float. P&L',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Int",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "0.00\$",
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(.5),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    fontFamily: "Int",
                  ),
                ),
              ],
            ).afmPadding(
              EdgeInsets.symmetric(horizontal: 18.w),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: 35.h,
                  pageCTA: 'Close All',
                  radius: 11,
                  buttonOnPressed: () {
                    debugPrint("Close All");
                  },
                ),
                CustomButton(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: 35.h,
                  radius: 11,
                  pageCTA: 'Close Only...',
                  buttonOnPressed: () {
                    debugPrint("Close Only");
                  },
                ),
              ],
            )
          ],
        ));
  }
}
