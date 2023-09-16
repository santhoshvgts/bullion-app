import 'package:bullion/router.dart';
import 'package:bullion/services/shared/eventbus_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/module_type.dart';
import '../../../../core/res/images.dart';
import '../../../../locator.dart';

class IntroViewModel extends VGTSBaseViewModel {

  final NavigationService navigationService = locator<NavigationService>();
  PageController? pageController;

  List<IntroSliderItem> introSliderItems = [
    IntroSliderItem(Images.priceAlerts, "Custom Spot Price Alerts",
        "Tell us your Gold, Silver, Platinum or Palladium target price and we will send you an email or text message as soon as the market reaches your price."),
    IntroSliderItem(Images.marketNews, "Precious Metals Market News",
        "Stay up to date on fast-changing Precious Metals market news. Read the latest Gold, Silver, Platinum and Palladium headlines from around the world."),
    IntroSliderItem(Images.vaultDeals, "Vault Deals",
        "Find the best savings on Gold, Silver, Collectibles and more."),
  ];

  login() {
    navigationService.pushNamed(Routes.login);
  }

  register() {
    navigationService.pushNamed(Routes.register,);
  }

  continueWithoutLogin() {
    preferenceService.setFirstTimeAppOpen(false);
    navigationService.pushReplacementNamed(Routes.dashboard);
    locator<EventBusService>().eventBus.fire(RefreshDataEvent(RefreshType.homeRefresh));
  }
}

class IntroSliderItem {
  String image;
  String title;
  String description;

  IntroSliderItem(this.image, this.title, this.description);
}
