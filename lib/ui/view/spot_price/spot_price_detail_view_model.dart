import 'package:bullion/core/models/chart/spot_price.dart';
import 'package:bullion/core/models/module/page_settings.dart';
import 'package:bullion/services/api_request/spot_price_request.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/cupertino.dart';

class SpotPriceDetailViewModel extends VGTSBaseViewModel {
  List<SpotPrice>? _spotPriceList = [];

  List<SpotPrice>? get spotPriceList => _spotPriceList;

  ScrollController controller = ScrollController();

  int? _selectedIndex = 0;

  int? get selectedIndex => _selectedIndex;

  PageSettings? _pageSettings;

  PageSettings? get pageSettings => _pageSettings;

  set pageSettings(PageSettings? value) {
    _pageSettings = value;
  }

  set selectedIndex(int? value) {
    _selectedIndex = value;
    notifyListeners();
  }

  SpotPrice? get selectedSpotPrice {
    return _spotPriceList?[_selectedIndex ?? 0];
  }

  String? get metalName {
    if (_selectedIndex != null) {
      return _spotPriceList![_selectedIndex!].title;
    } else {
      return _pageSettings?.title ?? _name;
    }
  }

  String? _name;

  String? get name => _name;

  set name(String? value) {
    _name = value;
  }

  bool _loading = false;

  set loading(bool value) {
    _loading = value;
  }

  bool get loading => _loading;

  init(String metalName) async {
    setBusy(true);
    _spotPriceList = await requestList<SpotPrice>(
        SpotPriceRequest.fetchSpotPricePortfolioDayChart());
    int? index = _spotPriceList?.indexWhere((element) =>
        element.metalName?.toLowerCase() == metalName.toLowerCase());
    _name = metalName;
    if (index == -1) {
      _selectedIndex = null;
    } else {
      _selectedIndex = index;
    }
    setBusy(false);
  }

  onChangeMetal(int index) {}
}
