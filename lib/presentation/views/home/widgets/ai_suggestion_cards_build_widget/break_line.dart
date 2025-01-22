import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BreakLine extends StatelessWidget {
  final String analysis;

  const BreakLine({
    super.key,
    required this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.h,
      color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.1),
    );
  }
}
