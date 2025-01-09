// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle/core/extensions/widget_extension.dart';


// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final bool agreeTC;
  final void Function()? buttonOnPressed;
  final String pageCTA;
  final double pageCTASize;
  final Color color;
  final Color buttonTextColor;
  double height;
  double width;
  double radius;
  CustomButton({
    super.key,
    this.agreeTC = false,
    this.buttonOnPressed,
    required this.pageCTA,
    this.color = Colors.deepPurple,
    this.buttonTextColor = Colors.white,
    this.height = 45,
    this.width = 1,
    this.pageCTASize = 20,
    this.radius = 50,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint('INFO: $pageCTA button has been pressed');
        buttonOnPressed!();
      },
      child: agreeTC
          ? const SizedBox()
          : Container(
              height: height.h,
              width: width == 1
                  ? MediaQuery.of(context).size.width - 40.w
                  : width.w,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(radius.r),
              ),
              child: Text(
                pageCTA,
                style: TextStyle(
                  fontFamily: 'Int',
                  color: buttonTextColor,
                  fontSize: pageCTASize.sp,
                  fontWeight: FontWeight.w600,
                ),
              ).afmCenter,
            ),
    );
  }
}

