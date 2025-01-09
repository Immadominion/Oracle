import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle/core/extensions/widget_extension.dart';

class TokensList extends StatelessWidget {
  final String balance;
  final String ticker;
  final String name;
  final String image;

  const TokensList({
    super.key,
    required this.balance,
    required this.ticker,
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: ClipOval(
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    width: 40.r,
                    height: 40.r,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: balance,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Int",
                          ),
                        ),
                        TextSpan(
                          text: " $ticker",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(.5),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Int",
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(.5),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Int",
                    ),
                  )
                ],
              ).afmPadding(
                EdgeInsets.only(
                  left: 5.h,
                ),
              ),
            ],
          ),
        ),
        Icon(
          CupertinoIcons.right_chevron,
          size: 20.sp,
        ),
      ],
    );
  }
}
