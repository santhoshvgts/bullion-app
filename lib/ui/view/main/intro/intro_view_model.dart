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
  int index = 0;

  List<IntroSliderItem> introSliderItems = [
    IntroSliderItem(Images.priceAlerts, "Exclusive Deals", "Access to limited-time offers, discounts and promotions."),
    IntroSliderItem(Images.marketNews, "Order Tracking", "Easily track your shipments and stay updated on the delivery status."),
    IntroSliderItem(Images.vaultDeals, "Personalized Recommendations", "Receive tailored product suggestions based on your preferences."),
  ];

  String get _buttonName => introSliderItems.last == introSliderItems[index] ? "Get started" : "Next";
  String get buttonName => _buttonName;

  bool get _isLastindex => introSliderItems.last == introSliderItems[index] ? true : false;
  bool get isLastindex => _isLastindex;

  @override
  Future onInit() {
    pageController = PageController(initialPage: index);
    return super.onInit();
  }

  void skipOnPressed() {
    pageController?.animateToPage(introSliderItems.length - 1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    notifyListeners();
    return;
  }

  void introButtonOnPressed() {
    if (!isLastindex) {
      pageController?.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      notifyListeners();
      return;
    }
    locator<NavigationService>().popAllAndPushNamed(Routes.login);
    return;
  }

  login() {
    navigationService.pushNamed(Routes.login);
  }

  register() {
    navigationService.pushNamed(
      Routes.register,
    );
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
