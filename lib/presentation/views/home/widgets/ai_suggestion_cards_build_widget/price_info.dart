import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../suggestion_card_content.dart';
import 'chart_data_point.dart';

class PriceInfo extends StatelessWidget {
  final double currentPrice;
  final List<ChartDataPoint> chartData;

  const PriceInfo({
    super.key,
    required this.currentPrice,
    required this.chartData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Price',
                style: TextStyle(
                  fontSize: 9.sp,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '\$${currentPrice.toStringAsFixed(4)}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          _build24hChange(context),
        ],
      ),
    );
  }

  Widget _build24hChange(BuildContext context) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final yesterdayPrice = chartData
        .firstWhere((data) => data.time.isAfter(yesterday),
            orElse: () => chartData.first)
        .price;
    final priceChange =
        ((currentPrice - yesterdayPrice) / yesterdayPrice) * 100;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 2.w,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: priceChange >= 0 ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        '${priceChange >= 0 ? '+' : ''}${priceChange.toStringAsFixed(2)}%',
        style: TextStyle(
          color: priceChange >= 0 ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 12.sp,
          fontFamily: 'Int',
        ),
      ),
    );
  }
}
