

import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/view/dashboard/dashboard_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class DashboardPage extends VGTSBuilderWidget<DashboardViewModel> {
  const DashboardPage({super.key});


  const DashboardPage({super.key});

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, DashboardViewModel viewModel, Widget? child) {

    return Scaffold(
      body: PersistentTabView(
        context,
        controller: viewModel.bottomNavController,
        screens: viewModel.pages,
        items: [
          _PersistentBottomNav(
            inactiveIcon: const Icon(CupertinoIcons.home),
            icon: const Icon(CupertinoIcons.house_fill),
            title: "Home",
            routeAndNavigatorSettings: const RouteAndNavigatorSettings(
              initialRoute: "/pages/home",
            )
          ),
          _PersistentBottomNav(
              icon: const Icon(CupertinoIcons.bag_fill),
              inactiveIcon: const Icon(CupertinoIcons.bag),
              title: "Shop",
              routeAndNavigatorSettings: const RouteAndNavigatorSettings(
                  initialRoute: "/pages/shop",
              )
          ),
          _PersistentBottomNav(
              icon: const Icon(CupertinoIcons.chart_bar_fill),
              inactiveIcon: const Icon(CupertinoIcons.chart_bar),
              title: "Charts",
              routeAndNavigatorSettings: const RouteAndNavigatorSettings(
                  initialRoute: "/pages/spot-price",
              )
          ),
          _PersistentBottomNav(
              inactiveIcon: const Icon(CupertinoIcons.tag),
              icon: const Icon(CupertinoIcons.tag_solid),
              title: "Deals",
              routeAndNavigatorSettings: const RouteAndNavigatorSettings(
                  initialRoute: "/pages/deals",
              )
          ),
          _PersistentBottomNav(
              icon: const Icon(CupertinoIcons.person_fill),
              inactiveIcon: const Icon(CupertinoIcons.person),
              title: "Accounts",
              routeAndNavigatorSettings: const RouteAndNavigatorSettings(
                  initialRoute: "/pages/accounts",
              )
          ),
        ],
        padding: const NavBarPadding.all(4),
        confineInSafeArea: true,
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        decoration: NavBarDecoration(
          boxShadow: AppStyle.topShadow
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.simple,
      )
    );
  }

  @override
  DashboardViewModel viewModelBuilder(BuildContext context) {
   return DashboardViewModel();
  }

}

class _PersistentBottomNav extends PersistentBottomNavBarItem {

  _PersistentBottomNav({
    required super.icon,
    required super.inactiveIcon,
    required super.title,
    required super.routeAndNavigatorSettings,
  });

  @override
  double get iconSize => 20;

  @override
  Color get activeColorPrimary => const Color(0xff626A7D);

  @override
  Color? get activeColorSecondary => AppColor.primary;
}