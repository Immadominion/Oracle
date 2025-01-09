
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oracle/core/constants/env_assets.dart';
import 'package:oracle/core/extensions/widget_extension.dart';

class CertifyAppBar extends StatelessWidget {
  final String text;
  final double bottomPadding;
  const CertifyAppBar({
    this.text = "",
    super.key,
    this.bottomPadding = 25,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset(
                    EnvAssets.getSvgPath('arrow-left-double'),
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          text == ""
              ? const SizedBox()
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontFamily: "Int",
                    fontWeight: FontWeight.w600,
                  ),
                ).afmPadding(
                  EdgeInsets.only(
                    bottom: bottomPadding.h,
                  ),
                ),
        ],
      ),
    );
  }
}
