import 'package:bullion/ui/order_details.dart';
import 'package:bullion/ui/view/dashboard/content/dashboard_content_page.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class DashboardViewModel extends VGTSBaseViewModel {
  final PersistentTabController bottomNavController =
      PersistentTabController(initialIndex: 0);

  final List<Widget> pages = [
    const DashboardContentPage(
        key: PageStorageKey('Home'), path: "/pages/home"),
    const DashboardContentPage(
        key: PageStorageKey('Shop'), path: "/pages/shop"),
    const DashboardContentPage(
        key: PageStorageKey('Charts'), path: "/spot-prices"),
    const DashboardContentPage(
        key: PageStorageKey('Spot Price'), path: "/pages/deals"),
    //const SettingsUserPage()
     OrderDetails()
  ];
}
