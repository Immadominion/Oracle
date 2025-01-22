import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TradingInfo extends StatelessWidget {
  final double currentPrice;
  final double investmentAmount;
  final double takeProfitPercentage;
  final double stopLossPercentage;

  const TradingInfo({
    super.key,
    required this.currentPrice,
    required this.investmentAmount,
    required this.takeProfitPercentage,
    required this.stopLossPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final tpPrice = currentPrice * (1 + takeProfitPercentage);
    final slPrice = currentPrice * (1 - stopLossPercentage);
    final potentialProfit = (tpPrice - currentPrice) * investmentAmount / currentPrice;
    final potentialLoss = (currentPrice - slPrice) * investmentAmount / currentPrice;

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          _buildTradingInfoRow(
            'Take Profit Target',
            '\$${tpPrice.toStringAsFixed(4)}',
            '+\$${potentialProfit.toStringAsFixed(2)}',
            Colors.green,
          ),
          Divider(height: 8.h),
          _buildTradingInfoRow(
            'Stop Loss Target',
            '\$${slPrice.toStringAsFixed(4)}',
            '-\$${potentialLoss.toStringAsFixed(2)}',
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildTradingInfoRow(
    String label,
    String price,
    String profit,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            price,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            profit,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}