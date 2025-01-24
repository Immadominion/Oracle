import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvestmentInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final double walletBalance;

  const InvestmentInputField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.walletBalance,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.h,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.r),
            bottomLeft: Radius.circular(8.r),
          ),
          color: Theme.of(context).primaryColor.withAlpha(200),
        ),
        child: Row(
          children: [
            Icon(Icons.attach_money, color: Colors.green, size: 16.sp),
            SizedBox(width: 4.w),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  onChanged(value);
                },
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: "0.00",
                  hintStyle:
                      TextStyle(color: Colors.grey[700], fontSize: 12.sp),
                  border: InputBorder.none, // Remove border for cleaner UI
                  isDense: true, // Make input field more compact
                  contentPadding: EdgeInsets.zero, // Adjust padding
                ),
              ),
            ),
            Icon(
              Icons.error_outline,
              color: (double.tryParse(controller.text) ?? 0) <= walletBalance &&
                      (double.tryParse(controller.text) ?? 0) > 0
                  ? Colors.green
                  : Colors.red,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}
