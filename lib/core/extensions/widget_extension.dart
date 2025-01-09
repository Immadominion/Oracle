import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension WidgetExtension on Widget {
  Widget get aftmDefaultBorderRadius => ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: this,
      );

  Widget get afmDoubleUp => Transform.scale(
        scale: 2,
        child: this,
      );

  Widget get afmCenter => Center(
        child: this,
      );

  Widget get afmNeverScroll => SingleChildScrollView(
        child: this,
      );
  Widget afmBorderRadius(BorderRadius radius) => ClipRRect(
        borderRadius: radius,
        child: this,
      );

  Widget afmGetFuture(Future<Object?>? future) => FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return this;
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );

  Widget afmTouchable(
    VoidCallback onTap, {
    Color? splashColor,
    double? elevation,
  }) =>
      Material(
        color: Colors.transparent,
        elevation: elevation ?? 0,
        child: InkWell(
          splashColor: splashColor,
          onTap: onTap,
          child: this,
        ),
      );

  Widget afmPadding([EdgeInsetsGeometry? padding]) {
    return Padding(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: 10.h,
            vertical: 10.w,
          ),
      child: this,
    );
  }

  Widget afmPositionCentered([context]) {
    return Positioned(
      right: MediaQuery.of(context).size.width / 2.5,
      child: this,
    );
  }

  Widget get afmWrapUp => Container(
        padding: EdgeInsets.all(3.sp),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: this,
      );
}
