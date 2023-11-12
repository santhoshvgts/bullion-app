import 'package:bullion/ui/view/cart/cart_page.dart';
import 'package:bullion/ui/view/dashboard/content/dashboard_content_page.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../settings/settings_user_page.dart';

class DashboardViewModel extends VGTSBaseViewModel {
  final PersistentTabController bottomNavController = PersistentTabController(
    initialIndex: 2,
  );

  var pageNames = [
    '/pages/deals',
    '/spot-prices',
    '/pages/home',
    '/cart/viewcart',
    '/settings'
  ];

  final List<Widget> pages = [
    DashboardContentPage(
      key: const PageStorageKey('Spot Price'),
      path: "/pages/deals",
    ),
    DashboardContentPage(
      key: const PageStorageKey('Charts'),
      path: "/spot-prices",
    ),
    DashboardContentPage(
      key: const PageStorageKey('Home'),
      path: "/pages/home",
    ),
    CartPage(),
    const SettingsUserPage()
  ];
}
