import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle/core/extensions/widget_extension.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../data/local/toast_service.dart';
import '../../../../utils/locator.dart';

class AddressQRCode extends StatelessWidget {
  final String walletAddress;

  const AddressQRCode({
    super.key,
    required this.walletAddress,
  });

  void _copyAddress(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: walletAddress));
    locator<ToastService>().showErrorToast("Wallet address copied!");
    if (Platform.isIOS) {
      await HapticFeedback.mediumImpact();
    } else if (Platform.isAndroid) {
      await HapticFeedback.vibrate();
    }
  }

  void _shareAddress() {
    print('sharing');
    final shareText = "Here’s my Solana wallet address:\n$walletAddress";
    Share.share(shareText, subject: "Solana Wallet Address");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .77,
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.sp),
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
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    CupertinoIcons.arrow_left,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 8.sp),
                Text(
                  'Your Solana Address',
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

          // QR Code with Copy Icon
          Column(
            children: [
              SizedBox(height: 20.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: QrImageView(
                  data: walletAddress,
                  version: QrVersions.auto,
                  size: 230.sp,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.all(10.sp),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "Fund your Solana wallet by scanning this code with another wallet",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'Int',
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ).afmPadding(),
              SizedBox(height: 24.h),
            ],
          ),

          // Action Buttons: Copy & Share side by side
          Row(
            children: [
              // Copy Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _copyAddress(context),
                  icon: Icon(
                    CupertinoIcons.doc_on_doc,
                    size: 20.sp,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Copy',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Int',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.sp),
                    backgroundColor:
                        Theme.of(context).colorScheme.onSurface.withOpacity(.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              // Share Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _shareAddress(),
                  icon: Icon(
                    CupertinoIcons.share,
                    size: 20.sp,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  label: Text(
                    'Share',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Int',
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.sp),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
              ),
            ],
          ).afmPadding(EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h)),
        ],
      ),
    );
  }
}
