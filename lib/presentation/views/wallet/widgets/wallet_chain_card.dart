import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/string_helpers.dart';

class WalletChainCard extends StatelessWidget {
  final String chainName;
  final String? walletAddress;
  final String imageAsset;

  const WalletChainCard({
    super.key,
    required this.chainName,
    required this.walletAddress,
    required this.imageAsset,
    bool isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              CircleAvatar(
                radius: 20.sp,
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(.5),
                child: Icon(
                  CupertinoIcons.qrcode,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 5.sp),
              CircleAvatar(
                radius: 20.sp,
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(.5),
                child: Icon(
                  CupertinoIcons.doc_on_doc,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 8.sp),
            ],
          )
        ],
      ),
    );
  }
}
