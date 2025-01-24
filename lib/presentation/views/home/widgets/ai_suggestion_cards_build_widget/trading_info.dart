import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'card_input_field_widget/trade_settings_dialog.dart';


class BuySettings extends StatefulWidget {
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
  });

  @override
  State<BuySettings> createState() => _BuySettingsState();
}

class _BuySettingsState extends State<BuySettings> {
  double _slippage = 1.0;
  double _maxTxFee = 0.005;
  bool _mevProtection = false;

  @override
  Widget build(BuildContext context) {
    final tpPrice = widget.currentPrice * (1 + widget.takeProfitPercentage);
    final slPrice = widget.currentPrice * (1 - widget.stopLossPercentage);
    final potentialProfit =
        (tpPrice - widget.currentPrice) * widget.investmentAmount / widget.currentPrice;
    final potentialLoss =
        (widget.currentPrice - slPrice) * widget.investmentAmount / widget.currentPrice;

    return GestureDetector(
      onTap: () async {
        final result = await showDialog<Map<String, dynamic>>(
          context: context,
          builder: (context) => TradingSettingsDialog(
            currentSlippage: _slippage,
            currentMaxTxFee: _maxTxFee,
            currentMevProtection: _mevProtection,
            color: Colors.green,
          ),
        );

        if (result != null) {
          setState(() {
            _slippage = result['slippage'];
            _maxTxFee = result['maxTxFee'];
            _mevProtection = result['mevProtection'];
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 3.h,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.scrim.withAlpha(100),
            width: 1.5.w,
          ),
          borderRadius: BorderRadius.circular(8.r),
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
                SizedBox(width: 3.sp),
                Text(
                  'Buy Settings',
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
                    color: _mevProtection ? Colors.green : Colors.grey,
                  ),
                  Text(
                    _mevProtection ? 'Mev: ON' : 'Mev: OFF',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: _mevProtection 
                        ? Colors.green 
                        : Theme.of(context).colorScheme.onSurface.withAlpha(200),
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
                SizedBox(width: 3.sp),
                Text(
                  '${_slippage.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}