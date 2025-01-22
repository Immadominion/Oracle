import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../suggestion_card_content.dart';
import 'chart_data_point.dart';

class PriceChart extends StatelessWidget {
  final List<ChartDataPoint> chartData;
  final double currentPrice;
  final bool showVolatilityBands;
  final double takeProfitPercentage;
  final double stopLossPercentage;
  final VoidCallback onVolatilityToggle;

  PriceChart({
    super.key,
    required this.chartData,
    required this.currentPrice,
    required this.showVolatilityBands,
    required this.takeProfitPercentage,
    required this.stopLossPercentage,
    required this.onVolatilityToggle,
  });

  late final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
    enablePinching: true,
    enableDoubleTapZooming: true,
    enablePanning: true,
    zoomMode: ZoomMode.x,
  );

  late final TrackballBehavior _trackballBehavior = TrackballBehavior(
    enable: true,
    activationMode: ActivationMode.singleTap,
    tooltipSettings: const InteractiveTooltip(
      format: 'Price: \${point.y}',
      borderColor: Colors.blue,
      borderWidth: 2,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            SfCartesianChart(
              zoomPanBehavior: _zoomPanBehavior,
              trackballBehavior: _trackballBehavior,
              margin: EdgeInsets.all(4.w),
              primaryXAxis: DateTimeAxis(
                dateFormat: DateFormat.MMMd(),
                intervalType: DateTimeIntervalType.days,
                majorGridLines: const MajorGridLines(width: 0),
                labelStyle: TextStyle(fontSize: 10.sp),
              ),
              primaryYAxis: NumericAxis(
                numberFormat:
                    NumberFormat.currency(decimalDigits: 4, symbol: '\$'),
                labelStyle: TextStyle(fontSize: 10.sp),
              ),
              series: _getChartSeries(context),
            ),
            Positioned(
              top: 4.h,
              right: 4.w,
              child: IconButton(
                icon: Icon(
                  showVolatilityBands ? Icons.visibility : Icons.visibility_off,
                  size: 20.w,
                ),
                onPressed: onVolatilityToggle,
              ),
            ),
          ],
        );
      },
    );
  }

  List<CartesianSeries> _getChartSeries(BuildContext context) {
    List<CartesianSeries> series = [
      FastLineSeries<ChartDataPoint, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartDataPoint data, _) => data.time,
        yValueMapper: (ChartDataPoint data, _) => data.price,
        color: Theme.of(context).primaryColor,
        width: 2,
      ),
    ];

    if (showVolatilityBands) {
      series.addAll([
        LineSeries<ChartDataPoint, DateTime>(
          dataSource: chartData,
          xValueMapper: (ChartDataPoint data, _) => data.time,
          yValueMapper: (ChartDataPoint data, _) =>
              data.price * (1 + takeProfitPercentage),
          dashArray: const [5, 5],
          color: Colors.green,
        ),
        LineSeries<ChartDataPoint, DateTime>(
          dataSource: chartData,
          xValueMapper: (ChartDataPoint data, _) => data.time,
          yValueMapper: (ChartDataPoint data, _) =>
              data.price * (1 - stopLossPercentage),
          dashArray: const [5, 5],
          color: Colors.red,
        ),
      ]);
    }

    return series;
  }
}
