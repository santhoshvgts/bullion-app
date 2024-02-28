import 'package:bullion/core/models/chart/spot_price.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/api_request/spot_price_request.dart';
import 'package:bullion/services/chart/spotprice_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';

class SpotPriceViewModel extends VGTSBaseViewModel {
  List<SpotPrice>? _spotPriceList;

  List<SpotPrice>? get spotPriceList => _spotPriceList ?? <SpotPrice>[];

  set spotPriceList(List<SpotPrice>? value) {
    _spotPriceList = value;
    notifyListeners();
  }

  bool _graphLoading = true;

  bool get graphLoading => _graphLoading;

  set graphLoading(bool value) {
    _graphLoading = value;
    notifyListeners();
  }

  init(dynamic list) async {
    _spotPriceList = list.map<SpotPrice>((e) => SpotPrice.fromJson(e)).toList();
    notifyListeners();

    graphLoading = true;
    _spotPriceList = await locator<SpotPriceService>().fetchSpotPriceDayChart();
    graphLoading = false;
  }
}
