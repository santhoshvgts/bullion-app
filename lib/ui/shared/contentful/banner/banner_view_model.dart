import 'package:bullion/core/models/module/banner_module.dart';
import 'package:bullion/core/models/module/module_settings.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../../locator.dart';
import '../../../../router.dart';

class BannerViewModel extends BaseViewModel {
  ModuleSettings? settings;
  List<BannerItem>? _items;

  PageController bannerPageController = new PageController();

  List<BannerItem>? get items => _items;

  int _index = 0;

  int get index => _index;

  set index(int value) {
    _index = value;
    notifyListeners();
  }

  BannerViewModel() {
    print(index);
  }

  @required
  init(ModuleSettings settings) {
    this.settings = settings;
    this._items = settings.items!.map((e) => BannerItem.fromJson(e)).toList();

    notifyListeners();
  }

  onTap(String? targetUrl) {
    notifyListeners();
    locator<NavigationService>().pushNamed(
      targetUrl,
    );
  }
}
