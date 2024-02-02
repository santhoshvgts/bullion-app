import 'package:bullion/core/models/chart/spot_price.dart';
import 'package:bullion/core/models/module/page_settings.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/api_request/spot_price_request.dart';
import 'package:bullion/services/chart/spotprice_service.dart';
import 'package:bullion/services/filter_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';

class SpotPriceDetailViewModel extends VGTSBaseViewModel {
  List<SpotPrice>? _spotPriceList = [];

  List<SpotPrice>? get spotPriceList => _spotPriceList;

  ScrollController controller = ScrollController();

  PageController pageController = PageController(
    initialPage: 0,
  );

  int? _selectedIndex = 0;

  int? get selectedIndex => _selectedIndex;

  PageSettings? _pageSettings;

  PageSettings? get pageSettings => _pageSettings;

  set pageSettings(PageSettings? value) {
    _pageSettings = value;
  }

  set selectedIndex(int? value) {
    _selectedIndex = value;
    locator<FilterService>().alertMetal = metalName;
    notifyListeners();
  }

  SpotPrice? get selectedSpotPrice {
    return _spotPriceList?[_selectedIndex ?? 0];
  }

  String? get metalName {
    if (_selectedIndex != null) {
      return _spotPriceList![_selectedIndex!].metalName;
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

  init(String metalName, vsync) async {
    setBusy(true);
    _spotPriceList = await locator<SpotPriceService>().fetchSpotPriceDayChart();
    int? index = _spotPriceList?.indexWhere((element) => element.metalName?.toLowerCase() == metalName.toLowerCase());
    _name = metalName;
    if (index == -1) {
      _selectedIndex = null;
    } else {
      _selectedIndex = index;
      pageController.jumpToPage(_selectedIndex!);
    }
    setBusy(false);
  }

  onChangeMetal(int index) {}
}
