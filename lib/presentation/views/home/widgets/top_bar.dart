import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle/core/constants/constants.dart';
import 'package:oracle/core/extensions/widget_extension.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(80.h);
  const HomeAppBar({super.key});

  @override
  HomeAppBarState createState() => HomeAppBarState();
}

class HomeAppBarState extends State<HomeAppBar> {
  bool _isAutoTrading = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  const AssetImage('assets/images/oracle_mum_buddy.jpg'),
              radius: 26.r,
            ),
            SizedBox(width: 8.w),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Oracle',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Int',
                    fontSize: 16.sp,
                    color:
                        Theme.of(context).colorScheme.onPrimary.withOpacity(.7),
                  ),
                ),
                TextSpan(
                  text: '\nMommy',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Int',
                    fontSize: 18.sp,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ]),
            )
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(.1),
            borderRadius: BorderRadius.circular(25.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 7.h),
          child: Row(
            children: [
              Text(
                "Auto Trading",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontFamily: "Int",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CupertinoSwitch(
                value: _isAutoTrading,
                onChanged: (value) {
                  setState(() {
                    _isAutoTrading = value;
                  });
                },
                activeColor:
                    OracleColors.primaryDark, // Thumb color when active
                trackColor:
                    Colors.grey.withOpacity(0.5), // Track color when inactive
              ),
            ],
          ),
        ),
      ],
    ).afmPadding(
      EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
    );
  }
}
