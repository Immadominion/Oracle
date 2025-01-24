import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'card_input_field_widget/investment_input_field.dart';
import 'card_input_field_widget/take_profit_or_stop_loss_field.dart';

class Controls extends StatelessWidget {
  final TextEditingController investmentController;
  final TextEditingController tpController;
  final TextEditingController slController;
  final Function(String) onInvestmentChanged;
  final Function(String) onTakeProfitChanged;
  final Function(String) onStopLossChanged;
  final double walletBalance;

  const Controls({
    super.key,
    required this.investmentController,
    required this.tpController,
    required this.slController,
    required this.onInvestmentChanged,
    required this.onTakeProfitChanged,
    required this.onStopLossChanged,
    required this.walletBalance,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Row(
              children: [
                // Investment Input Widget
                Flexible(
                  flex: 5,
                  child: InvestmentInputField(
                    controller: investmentController,
                    onChanged: onInvestmentChanged,
                    walletBalance: walletBalance,
                  ),
                ),
                SizedBox(width: 2.w),
                // TP and SL Widget
                Flexible(
                  flex: 6,
                  child: TakeProfitStopLossField(
                    tpController: tpController,
                    slController: slController,
                    onTakeProfitChanged: onTakeProfitChanged,
                    onStopLossChanged: onStopLossChanged,
                  ),
                ),
              ],
            ),

            SizedBox(height: 4.h),

            //Row that shows the estimated coin that would be gotten when bought
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Est. Received',
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(100),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Icon(
                      CupertinoIcons.info,
                      size: 12.sp,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(100),
                    )
                  ],
                ),

                //estimated coin that would be gotten when bought
                Text(
                  '0.0000',
                  style: TextStyle(
                    fontSize: 9.sp,
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(100),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  CupertinoIcons.exclamationmark_triangle,
                  size: 12.sp,
                  color: Theme.of(context).colorScheme.error,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Any network errors would be seen here',
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
