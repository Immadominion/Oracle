import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DepositBottomSheet extends StatelessWidget {
  const DepositBottomSheet({super.key});

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
            height: 50.h,
            margin: EdgeInsets.only(bottom: 24.sp),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.xmark,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                    SizedBox(width: 8.sp),
                    Text(
                      'Receive',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontFamily: 'Int',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                Icon(
                  CupertinoIcons.qrcode_viewfinder,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ],
            ),
          ),

          // DepositBottomSheet Choose Chain
          Container(
            padding: EdgeInsets.all(10.sp),
            margin: EdgeInsets.only(left: 20.sp, right: 20.sp, bottom: 16.sp),
            width: double.maxFinite,
            height: 70.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(.1),
              borderRadius: BorderRadius.circular(
                15.r,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: double.maxFinite,
                      width: 70.sp,
                      child: Image.asset(
                        'assets/images/solana.png',
                        width: 50.sp,
                        height: 50.sp,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      "Solana",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16.sp,
                        fontFamily: 'Int',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.qrcode,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                    SizedBox(width: 8.sp),
                    Icon(
                      CupertinoIcons.doc_on_doc,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
