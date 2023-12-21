import 'dart:async';

import 'package:bullion/core/models/chart/chart_selection_info.dart';
import 'package:bullion/core/models/chart/spot_price.dart';
import 'package:bullion/core/models/chart/spot_price_time_range_filter.dart';
import 'package:bullion/core/models/module/page_settings.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/api_request/page_request.dart';
import 'package:bullion/services/chart/spotprice_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';

import '../../../../../../helper/utils.dart';
import '../../../../chart/spotprice_sparkline.dart';

class SpotPriceChartViewModel extends VGTSBaseViewModel {
  bool? _mounted;
  SpotPrice? _spotPriceChartData;

  String? tag;

  Future<void> render() async {
    await updateSpotPrice();
    await Util.updateHomeWidget();
  }

   Future updateSpotPrice() async {
    try {
      return Future.wait([
        HomeWidget.saveWidgetData<String>('headline_title',
            spotPriceChartData?.metalName ?? "Metal"),
        HomeWidget.saveWidgetData<String>(
            'headline_description',
            chartSelectionInfoModel?.formatedPrice ??
                "0"),
        HomeWidget.saveWidgetData<String>('price_changes',
            "${chartSelectionInfoModel!.changePct! > 0 ? "+" : "-"} ${chartSelectionInfoModel?.formatedChange!} (${chartSelectionInfoModel!.changePct! > 0 ? "+" : ""}${chartSelectionInfoModel!.formatedChangePercentage})"),
        HomeWidget.renderFlutterWidget(
          SizedBox(
            height: 200,
            width: 300,
            child: SpotPriceSparkLineView(
              _spotPriceChartData?.metalName,
              _spotPriceChartData?.chartData,
            ),
          ),
          logicalSize: const Size(200, 200),
          key: 'logoDev',
        )
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Sending Data. $exception');
    }
  }


  final SpotPriceService _spotPriceService = locator<SpotPriceService>();

  late List<SpotPriceTimeRangeFilter> spotPriceTimeRangeFilters;
  ChartSelectionInfoModel? chartSelectionInfoModel;

  int selectedSpotPriceMetal = 1;

  StreamController<ChartSelectionInfoModel?> trackedSpotController =
      StreamController<ChartSelectionInfoModel?>.broadcast();

  int spotTimeRangeSelectedIndex = 0;

  SpotPrice? get spotPriceChartData => _spotPriceChartData;

  // List<String> filterItems = ["Gold", "Silver", "Platinum", "Palladium"];

  set selectedIndex(int value) {
    // controller.value = value;
    // locator<FilterService>().spotPriceTag = filterItems[value].toLowerCase();
    notifyListeners();
  }

  set spotPriceChartData(SpotPrice? value) {
    _spotPriceChartData = value;
    notifyListeners();
  }

  SpotPriceTimeRangeFilter get selectedFilterValue =>
      spotPriceTimeRangeFilters[spotTimeRangeSelectedIndex];

  init(String? slug, dynamic spotPrice) async {
    setBusy(true);

    try {
      _spotPriceChartData = SpotPrice.fromJson(spotPrice);
      chartSelectionInfoModel =
          ChartSelectionInfoModel.fromSpotPrice(_spotPriceChartData!);
      trackedSpotController.add(chartSelectionInfoModel);

      selectedSpotPriceMetal = _spotPriceChartData!.metalId!;

      if (spotPriceChartData!.metalId! >= 1 &&
          spotPriceChartData!.metalId! <= 4) {
        spotPriceTimeRangeFilters =
            _spotPriceService!.spotPriceTimeRangeFilters;
      } else {
        spotPriceTimeRangeFilters =
            _spotPriceService!.moreMarketTimeRangeFilters;
      }
    } catch (ex) {}
      render();
    setBusy(false);
  }

  // Future fetchSpotPrice({bool isTimeChange = false}) async {
  //   if (!isTimeChange) setState(ViewState.Busy);
  //   spotPriceTimeRangeFilters = _spotPriceService.spotPriceTimeRangeFilters;
  //   _spotPriceChartData = await _spotPriceService.getSpotPriceDataForChart(tag, spotPriceTimeRangeFilters[spotTimeRangeSelectedIndex].value);
  //   chartSelectionInfoModel = ChartSelectionInfoModel.fromSpotPrice(_spotPriceChartData);
  //   trackedSpotController.add(chartSelectionInfoModel);
  //
  //   setState(ViewState.Idle);
  // }

  setSelectedTimePeriod(int index) async {
    spotTimeRangeSelectedIndex = index;
    await fetchSpotPriceChart();
    if (_mounted != null && !_mounted!) {
      notifyListeners();
    }
  }

  onTrackballTouchUp() {
    //need to force a new instance for the stream builder to build
    chartSelectionInfoModel =
        ChartSelectionInfoModel.fromSpotPrice(_spotPriceChartData!);
    trackedSpotController.add(chartSelectionInfoModel);
    //
    // if (_mounted != null && !_mounted!) {
    //   notifyListeners();
    // }
  }

  onTrackballPositionChanges(DateTime time, double? value) {
    //spotPriceMetal = value;
    chartSelectionInfoModel =
        ChartSelectionInfoModel.fromSelection(value, time);
    // trackedSpotController.add(chartSelectionInfoModel);
  }

  void disposeModel() {
    _mounted = true;
    trackedSpotController.close();
  }

  fetchSpotPriceChart() async {
    PageSettings? _pageSetting = (await request<PageSettings>(
      PageRequest.fetch(
        path:
            "${_spotPriceChartData?.targetUrl}?type=${spotPriceTimeRangeFilters[spotTimeRangeSelectedIndex].value}",
      ),
    ));
    if (_pageSetting != null) {
      spotPriceChartData = SpotPrice.fromJson(_pageSetting.spotPrice);
      notifyListeners();
      trackedSpotController
          .add(ChartSelectionInfoModel.fromSpotPrice(_spotPriceChartData!));
    }
  }

  onCreateSpotPriceClick() async {
    // if (!locator<AuthenticationService>()!.isAuthenticated) {
    //   bool isLogged = await signInRequest(Images.userIcon,
    //       title: "Spot Price Alert", content: "");
    //   if (!isLogged) {
    //     return;
    //   }
    // }
    //
    // String title;
    // String description;
    //
    // title = "Custom Spot Price Alerts";
    // description =
    //     "Tell us your Gold, Silver, Platinum or Palladium target price and we will alert you as soon as the market reaches your price. "
    //     "\n\n Allow push notification to get notified instantly of price movements.";
    //
    // bool hasNotificationPermission = await locator<PushNotificationService>()
    //     .checkPermissionAndPromptSettings(title, description: description);
    // if (!hasNotificationPermission) {
    //   return false;
    // }
    //
    // navigationService.pushNamed(
    //     "${Routes.myMarketAlerts}/${locator<FilterService>().alertMetal}");
  }
}
