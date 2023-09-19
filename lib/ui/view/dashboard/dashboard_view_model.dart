

import 'package:bullion/ui/view/dashboard/content/dashboard_content_page.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class DashboardViewModel extends VGTSBaseViewModel {

  final PersistentTabController bottomNavController = PersistentTabController(initialIndex: 0);

  final List<Widget> pages = [
    DashboardContentPage(key: const PageStorageKey('Shop'), path: "/pages/home"),

    DashboardContentPage(key: const PageStorageKey('Shop'), path: "/pages/home"),

    DashboardContentPage(key: const PageStorageKey('Deals'), path: "/pages/deals"),

    DashboardContentPage(key: const PageStorageKey('Spot Price'), path: "/spot-prices?includeCommodoties=true"),

    DashboardContentPage(key: const PageStorageKey('BullionClub'), path: "/pages/bullion-club"),
  ];


}