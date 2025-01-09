// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:oracle/core/constants/env_assets.dart';
import 'package:oracle/core/extensions/widget_extension.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final String prefixIcon;
  final String suffixIcon;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.prefixIcon,
    this.suffixIcon = '',
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    required this.controller,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final inputStyle = TextStyle(
      fontFamily: "Int",
      fontWeight: FontWeight.w600,
      fontSize: 18.sp,
      color: const Color.fromRGBO(51, 51, 51, .5),
    );

    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword ? _obscureText : false,
      textAlignVertical: TextAlignVertical.top,
      style: inputStyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
        labelText: widget.labelText,
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: SvgPicture.asset(
            EnvAssets.getSvgPath(widget.prefixIcon),
            width: 24.w,
            height: 24.h,
            fit: BoxFit.contain,
            color: const Color.fromRGBO(51, 51, 51, .5),
          ).afmPadding(EdgeInsets.only(left: 5.sp)),
        ),
        labelStyle: inputStyle,
        suffixIcon: widget.isPassword
            ? IconButton(
                padding: EdgeInsets.only(right: 10.sp),
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey,
                  size: 24.sp,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : widget.suffixIcon.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: SvgPicture.asset(
                      EnvAssets.getSvgPath(widget.suffixIcon),
                      width: 24.w,
                      height: 24.h,
                      fit: BoxFit.contain,
                      color: const Color.fromRGBO(51, 51, 51, 1),
                    ),
                  )
                : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.sp),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.sp),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        isDense: true,
        filled: true,
        fillColor: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
    );
  }
}
