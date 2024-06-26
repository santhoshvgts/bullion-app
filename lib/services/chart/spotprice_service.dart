import 'dart:math';

import 'package:bullion/core/models/chart/chart_data.dart';
import 'package:bullion/core/models/chart/spot_price.dart';
import 'package:bullion/core/models/chart/spot_price_time_range_filter.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/api_request/spot_price_request.dart';
import 'package:bullion/services/shared/api_base_service.dart';

class SpotPriceService {

  final ApiBaseService _apiBaseService = locator<ApiBaseService>();

  List<SpotPrice> spotPriceList = [];

  Map<String, List<ChartData>> watchList = {};

  List<SpotPriceTimeRangeFilter> get spotPriceTimeRangeFilters => _spotPriceFilters;

  List<SpotPriceTimeRangeFilter> get moreMarketTimeRangeFilters => _moreFilters;

  List<SpotPriceTimeRangeFilter> get portfolioTimeRangeFilters => _portfolioFilters;

  final List<SpotPriceTimeRangeFilter> _spotPriceFilters = [
    SpotPriceTimeRangeFilter("24H", "day"),
    SpotPriceTimeRangeFilter("1W", "week"),
    SpotPriceTimeRangeFilter("1M", "month"),
    SpotPriceTimeRangeFilter("1Y", "year"),
    SpotPriceTimeRangeFilter("5Y", "5year"),
    SpotPriceTimeRangeFilter("ALL", "ALL"),
  ];

  final List<SpotPriceTimeRangeFilter> _moreFilters = [
    SpotPriceTimeRangeFilter("1W", "week"),
    SpotPriceTimeRangeFilter("1M", "month"),
    SpotPriceTimeRangeFilter("1Y", "year"),
    SpotPriceTimeRangeFilter("5Y", "5year"),
    SpotPriceTimeRangeFilter("ALL", "ALL"),
  ];

  final List<SpotPriceTimeRangeFilter> _portfolioFilters = [
    SpotPriceTimeRangeFilter("6M", "month"),
    SpotPriceTimeRangeFilter("1Y", "year"),
    SpotPriceTimeRangeFilter("5Y", "5year"),
    SpotPriceTimeRangeFilter("ALL", "ALL"),
  ];

  List<ChartData> get loadingData => List.generate(24, (i) => i + 1)
      .map((e) => ChartData(
          time: DateTime.now().subtract(Duration(minutes: e * 10)), price: 5))
      .toList();

  List<ChartData> dynamicData(String metalName) {
    if (watchList.containsKey(metalName) == false) {
      watchList[metalName] = List.generate(24, (i) => i + 1)
          .map((e) => ChartData(
              time: DateTime.now().subtract(Duration(minutes: e * 10)),
              price: Random().nextInt(120).toDouble()))
          .toList();
    }
    return watchList[metalName] ??
        List.generate(24, (i) => i + 1)
            .map((e) => ChartData(
                time: DateTime.now().subtract(Duration(minutes: e * 10)),
                price: Random().nextInt(120).toDouble()))
            .toList();
  }


  Future<List<SpotPrice>> fetchSpotPriceDayChart() async {
    if (spotPriceList.isEmpty) {
      spotPriceList = await _apiBaseService.requestList(SpotPriceRequest.fetchSpotPriceDayChart());
    }
    return spotPriceList;
  }



}
