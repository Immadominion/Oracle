import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'social_icons.dart';

class CardHeader extends StatelessWidget {
  final String ticker;
  final DateTime launchDate;
  final Map<String, String> socials;

  const CardHeader({
    super.key,
    required this.ticker,
    required this.launchDate,
    required this.socials,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticker,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              'Since ${DateFormat('MMM d, y').format(launchDate)}',
              style: TextStyle(
                fontSize: 9.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        SocialIcons(socials: socials),
      ],
    );
  }
}
