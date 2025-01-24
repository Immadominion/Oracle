import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildIconInfo(String iconPath, String text) {
  return Column(
    children: [
      Image.asset(
        iconPath,
        height: 28.h,
        width: 28.w,
      ),
      SizedBox(height: 8.sp),
      Text(
        text,
        maxLines: 3,
        textAlign: TextAlign.center,
        softWrap: true,
        style: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}
