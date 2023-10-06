import 'package:bullion/router.dart';
import 'package:bullion/services/shared/eventbus_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/module_type.dart';
import '../../../../core/res/images.dart';
import '../../../../locator.dart';

class IntroViewModel extends VGTSBaseViewModel {
  // Variables
  int currentPageIndex = 0;

  // Controllers
  PageController? pageController;

  // getters
  String get _buttonName => introSliderItems.last == introSliderItems[currentPageIndex] ? "Get started" : "Next";
  String get buttonName => _buttonName;

  bool get _isLastindex => introSliderItems.last == introSliderItems[currentPageIndex] ? true : false;
  bool get isLastindex => _isLastindex;

  // Init
  @override
  Future onInit() {
    pageController = PageController(initialPage: currentPageIndex);
    return super.onInit();
  }

  // Dummy Data
  List<IntroSliderItem> introSliderItems = [
    IntroSliderItem(Images.priceAlerts, "Exclusive Deals", "Access to limited-time offers, discounts and promotions."),
    IntroSliderItem(Images.marketNews, "Order Tracking", "Easily track your shipments and stay updated on the delivery status."),
    IntroSliderItem(Images.vaultDeals, "Personalized Recommendations", "Receive tailored product suggestions based on your preferences."),
  ];

  /* ----- Logics ------ */

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
    navigationService.pushNamed(Routes.login);
    return;
  }

  login() {
    navigationService.pushNamed(Routes.login,);
  }

  register() {
    navigationService.pushNamed(Routes.register);
  }

  continueWithoutLogin() {
    preferenceService.setFirstTimeAppOpen(false);
    navigationService.pushReplacementNamed(Routes.dashboard);
    locator<EventBusService>().eventBus.fire(RefreshDataEvent(RefreshType.homeRefresh));
  }

// Dispose
  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }
}

class IntroSliderItem {
  String image;
  String title;
  String description;

  IntroSliderItem(this.image, this.title, this.description);
}
