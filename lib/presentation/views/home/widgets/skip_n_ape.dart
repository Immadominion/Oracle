import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SkipAndApe extends StatelessWidget {
  const SkipAndApe({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              debugPrint("Skip pressed");
            },
            style: OutlinedButton.styleFrom(
              backgroundColor:
                  Theme.of(context).colorScheme.surface.withOpacity(0.1),
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
              padding: EdgeInsets.symmetric(
                horizontal: 45.w,
                vertical: 16.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Skip',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontFamily: "Int",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  size: 20.sp,
                  CupertinoIcons.bin_xmark,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16.sp),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              debugPrint("Ape pressed");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: EdgeInsets.symmetric(
                horizontal: 45.w,
                vertical: 16.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ape',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontFamily: "Int",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  size: 20.sp,
                  CupertinoIcons.checkmark_circle,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
