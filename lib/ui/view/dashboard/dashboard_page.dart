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

  @override
  Widget viewBuilder(
    BuildContext context,
    AppLocalizations locale,
    DashboardViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: viewModel.bottomNavController,
        screens: [
          ...viewModel.pages
              .asMap()
              .map((index, e) {
                return MapEntry(
                  index,
                  e,
                );
              })
              .values
              .toList()
        ],
        items: [
          _PersistentBottomNav(
            inactiveIcon: const Icon(CupertinoIcons.home),
            icon: const Icon(CupertinoIcons.house_fill),
            title: "Home",
            routeAndNavigatorSettings: RouteAndNavigatorSettings(
              initialRoute: "/pages/home",
              navigatorKey: locator<NavigationService>().getBottomKeyByIndex(0),
            ),
          ),
          _PersistentBottomNav(
            icon: const Icon(CupertinoIcons.bag_fill),
            inactiveIcon: const Icon(CupertinoIcons.bag),
            title: "Shop",
            routeAndNavigatorSettings: RouteAndNavigatorSettings(
              initialRoute: "/pages/shop",
              navigatorKey: locator<NavigationService>().getBottomKeyByIndex(1),
            ),
          ),
          _PersistentBottomNav(
            icon: const Icon(CupertinoIcons.chart_bar_fill),
            inactiveIcon: const Icon(CupertinoIcons.chart_bar),
            title: "Charts",
            routeAndNavigatorSettings: RouteAndNavigatorSettings(
              initialRoute: "/pages/spot-price",
              navigatorKey: locator<NavigationService>().getBottomKeyByIndex(2),
            ),
          ),
          _PersistentBottomNav(
            inactiveIcon: const Icon(CupertinoIcons.tag),
            icon: const Icon(CupertinoIcons.tag_solid),
            title: "Deals",
            routeAndNavigatorSettings: RouteAndNavigatorSettings(
              initialRoute: "/pages/deals",
              navigatorKey: locator<NavigationService>().getBottomKeyByIndex(3),
            ),
          ),
          _PersistentBottomNav(
            icon: const Icon(CupertinoIcons.person_fill),
            inactiveIcon: const Icon(CupertinoIcons.person),
            title: "Accounts",
            routeAndNavigatorSettings: RouteAndNavigatorSettings(
              initialRoute: "/pages/accounts",
              navigatorKey: locator<NavigationService>().getBottomKeyByIndex(4),
            ),
          ),
        ],
        padding: const NavBarPadding.all(4),
        confineInSafeArea: true,
        hideNavigationBarWhenKeyboardShows: true,
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        decoration: NavBarDecoration(boxShadow: AppStyle.topShadow),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.simple,
      ),
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
