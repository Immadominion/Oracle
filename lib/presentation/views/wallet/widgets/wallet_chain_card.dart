import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle/presentation/views/wallet/widgets/address_qr_code.dart';

import '../../../../core/helpers/string_helpers.dart';
import '../../../../data/local/toast_service.dart';
import '../../../../utils/locator.dart';

class WalletChainCard extends StatelessWidget {
  final String chainName;
  final String? walletAddress;
  final String imageAsset;
  final bool isActive;

  const WalletChainCard({
    super.key,
    required this.chainName,
    required this.walletAddress,
    this.isActive = false,
    required this.imageAsset,
  });

  void _onCopyTap(BuildContext context) async {
    if (isActive && (walletAddress != null && walletAddress!.isNotEmpty)) {
      debugPrint('wallet address copied');
      await Clipboard.setData(ClipboardData(text: walletAddress!));
      await _vibrate(context);
      locator<ToastService>().showErrorToast("Wallet address copied!");
    } else if (!isActive) {
      await _vibrate(context);
      locator<ToastService>()
          .showErrorToast("We are working on supporting this chain");
    } else {
      locator<ToastService>()
          .showErrorToast("Please connect your wallet again!");
    }
  }

  void _onReceiveTap(BuildContext context) {
    (walletAddress != null &&
            walletAddress != "" &&
            walletAddress != "coming soon")
        ? showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return AddressQRCode(
                walletAddress: walletAddress!,
              );
            },
          )
        : {
            locator<ToastService>()
                .showErrorToast("We are working on supporting this chain")
          };
  }

  Future<void> _vibrate(BuildContext context) async {
    if (Platform.isIOS) {
      await HapticFeedback.mediumImpact();
    } else if (Platform.isAndroid) {
      await HapticFeedback.vibrate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onReceiveTap(context),
      child: Container(
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
                    imageAsset,
                    width: 50.sp,
                    height: 50.sp,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      chainName,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16.sp,
                        fontFamily: 'Int',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      StringHelper.shortenWalletAddress(walletAddress),
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(.4),
                        fontSize: 16.sp,
                        fontFamily: 'Int',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => _onReceiveTap(context),
                  child: CircleAvatar(
                    radius: 20.sp,
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(.5),
                    child: Icon(
                      CupertinoIcons.qrcode,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                ),
                SizedBox(width: 5.sp),
                GestureDetector(
                  onTap: () => _onCopyTap(context),
                  child: CircleAvatar(
                    radius: 20.sp,
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(.5),
                    child: Icon(
                      CupertinoIcons.doc_on_doc,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                ),
                SizedBox(width: 8.sp),
              ],
            )
          ],
        ),
      ),
    );
  }
}
