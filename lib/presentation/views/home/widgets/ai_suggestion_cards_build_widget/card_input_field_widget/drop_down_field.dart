import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_input_dialog.dart';

class SetTakeProfitStopLossDialog extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(String) onChanged;
  final List<String> percentageTags;
  final Color color;

  const SetTakeProfitStopLossDialog({
    super.key,
    required this.label,
    required this.controller,
    required this.onChanged,
    this.percentageTags = const ['10', '25', '50', '75', '100'],
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        String? result = await showDialog<String>(
          context: context,
          builder: (context) => CustomInputDialog(
            label: label,
            controller: controller,
            onChanged: onChanged,
            percentageTags: percentageTags,
            color: color,
          ),
        );

        if (result != null) {
          controller.text = result;
          onChanged(result);
        }
      },
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              color: color.withOpacity(0.2),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            controller.text.isEmpty ? 'Select' : controller.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
