import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'ai_suggestion_cards_build_widget/break_line.dart';
import 'ai_suggestion_cards_build_widget/chart.dart';
import 'ai_suggestion_cards_build_widget/chart_data_point.dart';
import 'ai_suggestion_cards_build_widget/controls.dart';
import 'ai_suggestion_cards_build_widget/header.dart';
import 'ai_suggestion_cards_build_widget/price_info.dart';
import 'ai_suggestion_cards_build_widget/trading_info.dart';

class SuggestionCardContent extends StatefulWidget {
  final String ticker;
  final DateTime launchDate;
  final String aiAnalysis;
  final List<ChartDataPoint> chartData;
  final Map<String, String> socials;
  final double currentPrice;

  const SuggestionCardContent({
    super.key,
    required this.ticker,
    required this.launchDate,
    required this.aiAnalysis,
    required this.chartData,
    required this.socials,
    required this.currentPrice,
  });

  @override
  State<SuggestionCardContent> createState() => _SuggestionCardContentState();
}

class _SuggestionCardContentState extends State<SuggestionCardContent> {
  late TextEditingController investmentController;
  late TextEditingController tpController;
  late TextEditingController slController;
  bool showVolatilityBands = false;

  double investmentAmount = 100;
  double takeProfitPercentage = 0.20;
  double stopLossPercentage = 0.10;

  @override
  void initState() {
    super.initState();
    investmentController =
        TextEditingController(text: investmentAmount.toString());
    tpController =
        TextEditingController(text: (takeProfitPercentage * 100).toString());
    slController =
        TextEditingController(text: (stopLossPercentage * 100).toString());
  }

  @override
  void dispose() {
    investmentController.dispose();
    tpController.dispose();
    slController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardHeader(
              ticker: widget.ticker,
              launchDate: widget.launchDate,
              socials: widget.socials,
            ),
            SizedBox(height: 8.h),
            BreakLine(analysis: widget.aiAnalysis),
            SizedBox(height: 8.h),
            PriceInfo(
              currentPrice: widget.currentPrice,
              chartData: widget.chartData,
            ),
            SizedBox(height: 8.h),
            Expanded(
              flex: 4,
              child: PriceChart(
                chartData: widget.chartData,
                currentPrice: widget.currentPrice,
                showVolatilityBands: showVolatilityBands,
                takeProfitPercentage: takeProfitPercentage,
                stopLossPercentage: stopLossPercentage,
                onVolatilityToggle: () {
                  setState(() {
                    showVolatilityBands = !showVolatilityBands;
                  });
                },
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              flex: 2,
              child: Controls(
                investmentController: investmentController,
                tpController: tpController,
                slController: slController,
                //TODO: Implement wallet balance
                walletBalance: 10,
                onInvestmentChanged: (value) {
                  setState(() {
                    investmentAmount =
                        double.tryParse(value) ?? investmentAmount;
                  });
                },
                onTakeProfitChanged: (value) {
                  setState(() {
                    takeProfitPercentage =
                        (double.tryParse(value) ?? takeProfitPercentage) / 100;
                  });
                },
                onStopLossChanged: (value) {
                  setState(() {
                    stopLossPercentage =
                        (double.tryParse(value) ?? stopLossPercentage) / 100;
                  });
                },
              ),
            ),
            // TradingInfo(
            //   currentPrice: widget.currentPrice,
            //   investmentAmount: investmentAmount,
            //   takeProfitPercentage: takeProfitPercentage,
            //   stopLossPercentage: stopLossPercentage,
            // ),
          ],
        ),
      ),
    );
  }
}
