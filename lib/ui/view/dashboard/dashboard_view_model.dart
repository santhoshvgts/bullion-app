import 'package:bullion/ui/view/cart/cart_page.dart';
import 'package:bullion/ui/view/dashboard/content/dashboard_content_page.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../settings/settings_user_page.dart';

class DashboardViewModel extends VGTSBaseViewModel {
  final PersistentTabController bottomNavController = PersistentTabController(
    initialIndex: 0,
  );

  var pageNames = [
    '/pages/home',
    '/pages/deals',
    '/spot-prices',
    '/cart/viewcart',
    '/settings'
  ];

  final List<Widget> pages = [
    DashboardContentPage(
      key: const PageStorageKey('Home'),
      path: "/pages/home",
    ),
    DashboardContentPage(
      key: const PageStorageKey('Deals'),
      path: "/pages/deals",
    ),
    DashboardContentPage(
      key: const PageStorageKey('Charts'),
      path: "/spot-prices",
    ),
    CartPage(),
    const SettingsUserPage()
  ];
}
