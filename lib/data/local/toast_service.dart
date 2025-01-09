// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

class ToastService {
  void showSuccessToast(String message) {
    _showToast(message);
  }

  void showErrorToast(String message) {
    if (message != '') {}
    _showToast(message);
  }

  void showInfoToast(String message) {
    _showToast(message);
  }

  void showWarningToast(String message) {
    _showToast(message);
  }

  void _showToast(String message) {
    showToastWidget(
      _buildToastContainer(message),
      position: ToastPosition.bottom,
      duration: const Duration(seconds: 5),
      handleTouch: true,
      animationCurve: Curves.elasticIn,
    );
  }

  Widget _buildToastContainer(String message) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: 30.w),
          padding: const EdgeInsets.symmetric(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(50),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(1, 1),
              ),
            ],
            gradient: LinearGradient(
              colors: const [
                Color.fromARGB(221, 95, 19, 167),
                Color.fromARGB(221, 95, 19, 167),
                Color.fromARGB(221, 95, 19, 167),
              ],
              stops: const [0.0, 0.4, 0.8],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontFamily: 'Int',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
