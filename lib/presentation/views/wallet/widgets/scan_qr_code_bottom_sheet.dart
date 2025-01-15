import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'scan_qr_code.dart';

class ScanQRCodeBottomSheet extends StatelessWidget {
  const ScanQRCodeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .77,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // DepositBottomSheet Header
          Container(
            padding: EdgeInsets.only(left: 16.sp, right: 16.sp),
            height: MediaQuery.of(context).size.height * .07,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    CupertinoIcons.xmark,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 8.sp),
                Text(
                  'Scan QR Code',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18.sp,
                    fontFamily: 'Int',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          //Scan Qr Code
          const ScanQRCode(),
        ],
      ),
    );
  }
}
