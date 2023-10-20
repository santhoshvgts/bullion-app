import 'package:bullion/core/models/chart/chart_data.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class SpotPriceSparkLineView extends StatelessWidget {
  final String? metalName;
  final List<ChartData>? chartData;
  final bool? loading;

  const SpotPriceSparkLineView(this.metalName, this.chartData,
      {super.key, this.loading = false});

  List<double> get d {
    List<ChartData>? filter = [];

    final releaseDateMap =
        chartData?.groupListsBy((m) => m.time.toString().split(':')[0]);

    releaseDateMap?.forEach((key, value) {
      filter.add(ChartData(time: value.first.time, price: value.first.price));
    });

    return filter.map((f) => f.price!.toDouble()).toList().cast<double>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      child: loading!
          ? Sparkline(
              data: d,
              lineWidth: 1,
              lineColor: const Color(0x1AFFFFFF),
              fillColor: const Color(0x40F2F2F7),
              fillMode: FillMode.below,
            )
          : Sparkline(
              data: d,
              lineWidth: 1,
              lineColor: AppColor.opacityMetalColor(metalName!),
              fillColor:
                  AppColor.opacityMetalColor(metalName!).withOpacity(0.2),
              fillMode: FillMode.below,
            ),
    );
  }
}
