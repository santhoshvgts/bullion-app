import 'dart:async';

import 'package:bullion/core/models/chart/chart_selection_info.dart';
import 'package:bullion/core/models/chart/spot_price.dart';
import 'package:bullion/core/models/chart/spot_price_time_range_filter.dart';
import 'package:bullion/core/models/module/page_settings.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/api_request/page_request.dart';
import 'package:bullion/services/chart/spotprice_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';

import '../../../../../../router.dart';

class SpotPriceChartViewModel extends VGTSBaseViewModel {
  bool? _mounted;
  SpotPrice? _spotPriceChartData;

  String? tag;

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

  createSpotPrice() {
    if (authenticationService!.isAuthenticated) {
      navigationService.pushNamed(Routes.editSpotPrice,
          arguments: {"metalName": spotPriceChartData?.metalName});
      return true;
    }
    return false;
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
