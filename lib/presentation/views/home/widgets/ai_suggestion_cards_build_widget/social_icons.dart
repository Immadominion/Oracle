import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialIcons extends StatelessWidget {
  final Map<String, String> socials;

  const SocialIcons({
    super.key,
    required this.socials,
  });

  @override
  Widget build(BuildContext context) {
    if (socials.isEmpty) {
      return Text(
        'No Socials',
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.grey[600],
        ),
      );
    }

    return Row(
      children: socials.entries.map((entry) {
        IconData icon;
        Color color;

        switch (entry.key.toLowerCase()) {
          case 'telegram':
            icon = Icons.send;
            color = const Color(0xFF0088cc);
            break;
          case 'website':
            icon = Icons.language;
            color = Colors.blue;
            break;
          case 'x':
            icon = Icons.webhook;
            color = Colors.black;
            break;
          default:
            icon = Icons.link;
            color = Colors.grey;
        }

        return Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(8.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(8.r),
              onTap: () {
                // Handle social link tap
              },
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  size: 20.w,
                  color: color,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}