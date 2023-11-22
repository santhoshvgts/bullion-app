import 'package:bullion/core/models/chart/chart_data.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/helper/logger.dart';
import 'package:bullion/ui/shared/contentful/dynamic/spot_price/chart_view/spot_price_chart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AreaChartWidget extends ViewModelWidget<SpotPriceChartViewModel> {
  final List<ChartData>? tsdata;
  final String type;
  final int metal;

  AreaChartWidget(this.tsdata, this.type, this.metal);

  @override
  Widget build(BuildContext context, viewModel) {
    final pt = tsdata!.map((f) => f.price).toList()..sort();
    double? _minValue;
    double? _maxValue;
    _minValue = pt.firstWhere((t) => true);
    _maxValue = pt.lastWhere((t) => true);

    final double diff = _maxValue! - _minValue!;
    double? initialValue = _minValue;

    // print(pt);

    if (diff <= 1.0) {
      initialValue = (_minValue * 10).floor() / 10; // 0.10
    } else if (diff <= 5.0) {
      initialValue = _minValue.floorToDouble(); // 1.0
    } else if (diff <= 10.0) {
      initialValue = (_minValue / 2).floorToDouble() * 2; // 2.0
    } else {
      initialValue = (_minValue / 5).floorToDouble() * 5; // 5.0
    }

    List<double> increments = [
      5000.0,
      4500.0,
      4000.0,
      3500.0,
      3000.0,
      2500.0,
      2000.0,
      1000.0,
      500.0,
      400.0,
      300.0,
      250.0,
      200.0,
      100.0,
      80.0,
      60.0,
      50.0,
      45.0,
      40.0,
      35.0,
      30.0,
      25.0,
      20.0,
      15.0,
      10.0,
      8.0,
      5.0,
      2.5,
      2.0,
      1.5,
      1.0,
      0.75,
      0.5,
      0.3,
      0.25,
      0.2,
      0.15,
      0.1,
      0.05,
      0.01
    ]..sort((b, a) => a.compareTo(b));

    _maxValue = calculateMaxValue(initialValue, _maxValue);

    // print("_maxValue : $_maxValue");
    print("_maxValue : ${(_maxValue! - initialValue) / 6}");

    var greater = increments
        .where((e) => e >= (_maxValue! - initialValue!) / 6)
        .toList()
      ..sort(); //List of the greater values
    double intervalValue = greater.isEmpty ? increments.first : greater.first;

    _maxValue = roundMaxValue(intervalValue, 2, initialValue, _maxValue);

    print("_maxValue : $_maxValue");
    print("initialValue : $initialValue");
    print("intervalValue : $intervalValue");

    return Column(
      children: [
        // StreamBuilder(
        //   stream: viewModel.trackedSpotController.stream,
        //   initialData: viewModel.chartSelectionInfoModel,
        //   builder: (BuildContext context, snapshot) {
        //     return SpotPriceHeader(,snapshot.data as ChartSelectionInfoModel);
        //   },
        // ),
        Listener(
          onPointerUp: (val) {
            Future.delayed(const Duration(milliseconds: 200), () {
              viewModel.onTrackballTouchUp();
            });
          },
          child: SizedBox(
            height: (MediaQuery.of(context).size.height / 2.3).roundToDouble(),
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              margin: EdgeInsets.zero,
              primaryXAxis: DateTimeAxis(
                majorGridLines: const MajorGridLines(
                  width: 0,
                ),
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                minorTickLines: const MinorTickLines(width: 0),
                minorGridLines: const MinorGridLines(width: 0),
                labelPosition: ChartDataLabelPosition.inside,
                isVisible: false,
                labelIntersectAction: AxisLabelIntersectAction.hide,
              ),
              primaryYAxis: NumericAxis(
                labelPosition: ChartDataLabelPosition.inside,
                tickPosition: TickPosition.inside,
                minimum: initialValue,
                maximum: _maxValue,
                opposedPosition: true,
                interval: intervalValue,
                axisLine: const AxisLine(
                  width: 0,
                ),
                majorTickLines: const MajorTickLines(size: 0),
                majorGridLines: const MajorGridLines(
                  width: 0.3,
                ),
                numberFormat: NumberFormat.currency(
                  symbol: r'$',
                  decimalDigits:
                      hasDecimalPlaces(initialValue) || metal == 2 ? 2 : 0,
                ),
              ),
              onTrackballPositionChanging: (TrackballArgs value) {
                viewModel.onTrackballPositionChanges(
                  value.chartPointInfo.chartDataPoint!.x,
                  value.chartPointInfo.chartDataPoint!.y,
                );
              },
              series: _getDefaultDateTimeSeries(viewModel),
              trackballBehavior: TrackballBehavior(
                enable: true,
                lineDashArray: const [0.2, 0.5],
                activationMode: ActivationMode.singleTap,
                tooltipAlignment: ChartAlignment.near,
                tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                markerSettings: TrackballMarkerSettings(
                  markerVisibility: TrackballVisibilityMode.visible,
                  color: viewModel.spotPriceChartData!.color,
                  borderColor: viewModel.spotPriceChartData!.color,
                ),
                builder: (BuildContext context, TrackballDetails details) {
                  return Container(
                    padding: const EdgeInsets.all(5.0),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      // color: AppColor.opacityColor(
                      //         viewModel.spotPriceChartData!.metalName!)
                      //     .withOpacity(0.1),
                      color: AppColor.secondaryBackground,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          // color: AppColor.opacityColor(
                          //     viewModel.spotPriceChartData!.metalName!),
                          color: AppColor.border,
                          width: 0.5),
                    ),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.vertical,
                      children: [
                        Text(
                          viewModel.chartSelectionInfoModel!.formatedPrice!,
                          style: AppTextStyle.labelLarge,
                        ),
                        HorizontalSpacing.d10px(),
                        Text(
                          viewModel.chartSelectionInfoModel!.chartToolTipDate!,
                          style: AppTextStyle.labelSmall
                              .copyWith(color: AppColor.secondaryText),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  roundMaxValue(
      double diff, int interval, double initialValue, double maxValue) {
    double value = initialValue + (diff * interval);
    print("$interval ${value} $maxValue");
    if (value >= maxValue) {
      return double.parse(value.toStringAsFixed(2));
    }
    return roundMaxValue(diff, interval + 1, initialValue, maxValue);
  }

  calculateMaxValue(double initialValue, double maxValue) {
    try {
      double diff = maxValue - initialValue;
      print("DIFF $diff ${diff.ceilToDouble()}");
      if (diff < 0.5) {
        int data = int.parse(diff.toStringAsFixed(2).split(".")[1]);
        diff = double.parse("0.${((data / 5).ceil() * 5).toInt()}");
      } else {
        diff = diff.ceilToDouble();
      }
      maxValue = initialValue + diff;
      print("DIFF $initialValue ${diff} $maxValue");
    } catch (ex, s) {
      Logger.e(ex.toString(), s: s);
    }
    return double.parse(maxValue.toStringAsFixed(2));
  }

  static bool hasDecimalPlaces(var number) {
    List<String> subString = number.toString().split('.');
    return subString.isNotEmpty ? int.parse(subString[1]) > 0 : false;
  }

  List<AreaSeries<ChartData, DateTime>> _getDefaultDateTimeSeries(
    SpotPriceChartViewModel vm,
  ) {
    return <AreaSeries<ChartData, DateTime>>[
      AreaSeries<ChartData, DateTime>(
        borderColor: vm.spotPriceChartData!.color,
        color: vm.spotPriceChartData!.areaColor.withOpacity(0.04),
        // color: Colors.transparent,
        borderWidth: 1.5,
        dataSource: tsdata!,
        xValueMapper: (ChartData data, _) => data.time,
        yValueMapper: (ChartData data, _) => data.price,
      )
    ];
  }
}
