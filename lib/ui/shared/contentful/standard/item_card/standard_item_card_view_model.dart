import 'package:bullion/services/shared/analytics_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:bullion/core/models/module/item_display_settings.dart';
import 'package:bullion/core/models/module/standard_item.dart';
import 'package:stacked/stacked.dart';

import '../../../../../locator.dart';

class StandardItemCardViewModel extends BaseViewModel {
  final ItemDisplaySettings? itemDisplaySettings;
  final StandardItem? item;
  final String? id;

  GlobalKey contentSectionKey = new GlobalKey();
  GlobalKey imageSectionKey = new GlobalKey();

  double _contentSectionHeight = 0;
  double _imageSectionHeight = 0;
  double _imageSectionWidth = 0;

  double get imageSectionWidth => _imageSectionWidth;

  double get itemSectionHeight {
    double height = 0;
    if ((itemDisplaySettings!.imagePosition.contains("right") || itemDisplaySettings!.imagePosition.contains("left"))) {
      height = _contentSectionHeight;
    }
    height = _contentSectionHeight + _imageSectionHeight;
    return height + (itemDisplaySettings!.fullBleed ? 0 : (itemDisplaySettings!.cardPadding * 2));
  }

  double get imageSectionPositionBottom => contentSectionPositionTop - 10;

  double get contentSectionPositionLeft {
    if (itemDisplaySettings!.imagePosition.contains("left")) {
      return _imageSectionWidth + 10;
    }
    return 0;
  }

  double get contentSectionPositionRight {
    if (itemDisplaySettings!.imagePosition.contains("right")) {
      return _imageSectionWidth + 10;
    }
    return 0;
  }

  double get contentSectionPositionTop {
    if (itemDisplaySettings!.imagePosition == "bottom" || itemDisplaySettings!.imagePosition == "center") {
      return _imageSectionHeight;
    }
    return 0;
  }

  StandardItemCardViewModel({this.itemDisplaySettings, this.item, this.id}) {
    // WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  // _afterLayout(_){
  //   _contentSectionHeight = contentSectionKey.currentContext.size.height;
  //
  //   if (item.imageUrl != null && item.imageUrl != ""){
  //     _imageSectionHeight = imageSectionKey.currentContext.size.height;
  //     _imageSectionWidth = imageSectionKey.currentContext.size.width;
  //   }
  //   notifyListeners();
  // }

  onTap() {
    print(item!.targetUrl);
    locator<AnalyticsService>().logModuleClick(id, item!.title ?? id);
    locator<NavigationService>().pushNamed(item!.targetUrl);
  }
}
