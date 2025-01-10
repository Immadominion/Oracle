import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle/presentation/views/wallet/widgets/scan_qr_code.dart';
import 'package:oracle/presentation/views/wallet/widgets/wallet_chain_card.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reown_appkit/reown_appkit.dart';

class DepositBottomSheet extends StatelessWidget {
  final ReownAppKitModal appKitModal;
  const DepositBottomSheet({super.key, required this.appKitModal});

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
            margin: EdgeInsets.only(bottom: 24.sp),
            decoration: BoxDecoration(
              color: Colors.transparent,
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
                      'Receive',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18.sp,
                        fontFamily: 'Int',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    // Check camera permission
                    PermissionStatus status = await Permission.camera.status;

                    if (status.isGranted) {
                      // Permission granted, navigate to scanner
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            topRight: Radius.circular(20.r),
                          ),
                        ),
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return const ScanQRCodeBottomSheet();
                        },
                      );
                    } else if (status.isDenied || status.isRestricted) {
                      // Request permission if denied or restricted
                      PermissionStatus newStatus =
                          await Permission.camera.request();

                      if (newStatus.isGranted) {
                        // Permission granted after request, navigate to scanner
                        showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.r),
                              topRight: Radius.circular(20.r),
                            ),
                          ),
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return const ScanQRCodeBottomSheet();
                          },
                        );
                      } else {
                        // Permission denied, show message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Camera permission is required to scan QR codes.'),
                          ),
                        );
                      }
                    } else if (status.isPermanentlyDenied) {
                      // If permission is permanently denied, direct user to app settings
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                              'Camera permission is permanently denied. Enable it in settings.'),
                          action: SnackBarAction(
                            label: 'Open Settings',
                            onPressed: () {
                              openAppSettings();
                            },
                          ),
                        ),
                      );
                    }
                  },
                  child: Icon(
                    CupertinoIcons.qrcode_viewfinder,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
          ),

          // DepositBottomSheet Choose Chain
          WalletChainCard(
            chainName: 'Solana',
            walletAddress: appKitModal.session?.getAddress('solana'),
            imageAsset: 'assets/images/solana.png',
            isActive: true,
          ),
          const WalletChainCard(
            chainName: 'Sui',
            walletAddress: 'coming soon',
            imageAsset: 'assets/images/sui.png',
          ),
          const WalletChainCard(
            chainName: 'Base',
            walletAddress: 'coming soon',
            imageAsset: 'assets/images/base.png',
          ),
        ],
      ),
    );
  }
}

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
