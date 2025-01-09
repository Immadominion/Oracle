import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle/core/extensions/widget_extension.dart';

class TopBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final String text;
  @override
  Size get preferredSize => Size.fromHeight(80.h);
  const TopBarWidget({super.key, required this.text});

  @override
  TopBarWidgetState createState() => TopBarWidgetState();
}

class TopBarWidgetState extends State<TopBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 7,
          child: Text(
            widget.text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontFamily: "Int",
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                CupertinoIcons.bell,
                size: 24.r,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              Icon(
                CupertinoIcons.person,
                size: 24.r,
                color: Theme.of(context).colorScheme.onPrimary,
              )
            ],
          ),
        ),
      ],
    ).afmPadding(
      EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
    );
  }
}
