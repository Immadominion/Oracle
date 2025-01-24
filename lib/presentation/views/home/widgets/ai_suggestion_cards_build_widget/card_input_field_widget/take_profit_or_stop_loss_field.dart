import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'drop_down_field.dart';

class TakeProfitStopLossField extends StatelessWidget {
  final TextEditingController tpController;
  final TextEditingController slController;
  final Function(String) onTakeProfitChanged;
  final Function(String) onStopLossChanged;

  const TakeProfitStopLossField({
    super.key,
    required this.tpController,
    required this.slController,
    required this.onTakeProfitChanged,
    required this.onStopLossChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.h,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8.r),
            bottomRight: Radius.circular(8.r),
          ),
          color: Theme.of(context).primaryColor.withAlpha(200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: SetTakeProfitStopLossDialog(
                label: 'TP',
                controller: tpController,
                onChanged: onTakeProfitChanged,
                percentageTags: const ['+10', '+25', '+50', '+75', '+100'],
                color: Colors.green,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              flex: 1,
              child: SetTakeProfitStopLossDialog(
                label: 'SL',
                controller: slController,
                onChanged: onStopLossChanged,
                //if the user wants to set a new percentage, we can inject it from here
                percentageTags: const ['-5', '-10', '-15'],
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
