

import 'package:bullion/ui/view/dashboard/dashboard_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class DashboardPage extends VGTSBuilderWidget<DashboardViewModel> {
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
            icon: const Icon(Icons.home),
            title: "Home",
            routeAndNavigatorSettings: const RouteAndNavigatorSettings(initialRoute: "/pages/home")
          ),
          _PersistentBottomNav(
              icon: const Icon(Icons.category),
              title: "Shop",
              routeAndNavigatorSettings: const RouteAndNavigatorSettings(initialRoute: "/pages/shop")
          ),
          _PersistentBottomNav(
              icon: const Icon(Icons.bar_chart_sharp),
              title: "Charts",
              routeAndNavigatorSettings: const RouteAndNavigatorSettings(initialRoute: "/pages/spot-price")
          ),
          _PersistentBottomNav(
              icon: const Icon(Icons.local_offer_sharp),
              title: "Deals",
              routeAndNavigatorSettings: const RouteAndNavigatorSettings(initialRoute: "/pages/deals")
          ),
          _PersistentBottomNav(
              icon: const Icon(Icons.person),
              title: "Accounts",
              routeAndNavigatorSettings: const RouteAndNavigatorSettings(initialRoute: "/pages/accounts")
          ),
        ],
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style6, // Choose the nav bar style with this property.
      )
    );
  }

  @override
  DashboardViewModel viewModelBuilder(BuildContext context) {
   return DashboardViewModel();
  }

}

class _PersistentBottomNav extends PersistentBottomNavBarItem {

  _PersistentBottomNav({required super.icon, required super.title, required super.routeAndNavigatorSettings });

}