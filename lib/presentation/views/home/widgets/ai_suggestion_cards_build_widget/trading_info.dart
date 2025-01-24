import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuySettings extends StatelessWidget {
  final BuildContext context;
  final double currentPrice;
  final double investmentAmount;
  final double takeProfitPercentage;
  final double stopLossPercentage;

  const BuySettings({
    super.key,
    required this.currentPrice,
    required this.investmentAmount,
    required this.takeProfitPercentage,
    required this.stopLossPercentage,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final tpPrice = currentPrice * (1 + takeProfitPercentage);
    final slPrice = currentPrice * (1 - stopLossPercentage);
    final potentialProfit =
        (tpPrice - currentPrice) * investmentAmount / currentPrice;
    final potentialLoss =
        (currentPrice - slPrice) * investmentAmount / currentPrice;

    return _buildTradingInfoRow(
      'Buy Settings',
      '\$${tpPrice.toStringAsFixed(4)}',
      '+\$${potentialProfit.toStringAsFixed(2)}',
      Colors.green,
    );
  }

  Widget _buildTradingInfoRow(
    String label,
    String price,
    String profit,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 3.h,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.scrim.withAlpha(
                100,
              ),
          width: 1.5.w,
        ),
        borderRadius: BorderRadius.circular(
          8.r,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.slider_horizontal_3,
                size: 16.sp,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
              ),
              SizedBox(
                width: 3.sp,
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(4.sp),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.scrim.withAlpha(100),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 16.sp,
                ),
                Text(
                  'Mev: OFF',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(200),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(
                CupertinoIcons.hare,
                size: 16.sp,
              ),
              SizedBox(
                width: 3.sp,
              ),
              Text(
                '20%',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
