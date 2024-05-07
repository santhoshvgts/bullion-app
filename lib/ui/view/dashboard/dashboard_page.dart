import 'package:bullion/core/models/module/page_settings.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/checkout/cart_service.dart';
import 'package:bullion/services/shared/analytics_service.dart';
import 'package:bullion/services/shared/eventbus_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/view/dashboard/dashboard_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class DashboardPage extends VGTSBuilderWidget<DashboardViewModel> {
  DashboardPage({super.key});

  final List<PersistentBottomNav> persistentBottomItems = [PersistentBottomNav(
    inactiveIcon: Image.asset(Images.home, width: 20,),
    icon: Image.asset(Images.home_active, width: 20,),
    title: "Home",
    routeAndNavigatorSettings: RouteAndNavigatorSettings(
      initialRoute: "/pages/home",
      navigatorKey: locator<NavigationService>().getBottomKeyByIndex(0),
    ),
  ),
    PersistentBottomNav(
      inactiveIcon: Image.asset(Images.deals, width: 22,),
      icon: Image.asset(Images.deals_active, width: 22,),
      title: "Deals",
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
        initialRoute: "/pages/deals",
        navigatorKey: locator<NavigationService>().getBottomKeyByIndex(1),
      ),
    ),
    PersistentBottomNav(
      inactiveIcon: Image.asset(Images.chart_inactive, width: 22,),
      icon: Image.asset(Images.chart_active, width: 22, color: AppColor.primary,),
      title: "Charts",
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
        initialRoute: "/pages/spot-price",
        navigatorKey: locator<NavigationService>().getBottomKeyByIndex(2),
      ),
    ),
    PersistentBottomNav(
      inactiveIcon: StreamBuilder<PageSettings?>(
          stream: locator<CartService>().stream,
          builder: (context, snapshot) {
            return SizedBox(
              width: 50,
              height: 24,
              child: Stack(
                children: [
                  Positioned.fill(child: Center(child: Image.asset(Images.cart_inactive, width: 22, height: 22,))),
                  if (snapshot.hasData)
                    if ((snapshot.data?.shoppingCart?.totalItems ?? 0) != 0)
                      Positioned(
                        right: 5,
                        child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: AppColor.primary),
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            snapshot.data?.shoppingCart?.totalItems?.toString() ?? '',

                            style: AppTextStyle.bodyMedium
                                .copyWith(fontSize: 12, color: AppColor.white),
                          ),
                        ),
                      )
                ],
              ),
            );
          }
      ),
      icon: StreamBuilder<PageSettings?>(
          stream: locator<CartService>().stream,
          builder: (context, snapshot) {
            return SizedBox(
              width: 50,
              height: 24,
              child: Stack(
                children: [
                  Positioned.fill(child: Center(child: Image.asset(Images.cart_active, width: 22, height: 22, color: AppColor.primary,))),
                  if (snapshot.hasData)
                    if ((snapshot.data?.shoppingCart?.totalItems ?? 0) != 0)
                      Positioned(
                        right: 5,
                        child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: AppColor.primary),
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            snapshot.data?.shoppingCart?.totalItems?.toString() ?? '',

                            style: AppTextStyle.bodyMedium
                                .copyWith(fontSize: 12, color: AppColor.white),
                          ),
                        ),
                      )
                ],
              ),
            );
          }
      ),
      title: "Cart",
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
        initialRoute: "/cart/viewCart",
        navigatorKey: locator<NavigationService>().getBottomKeyByIndex(3),
      ),
    ),
    PersistentBottomNav(
      inactiveIcon: Image.asset(Images.account, width: 26,),
      icon: Image.asset(Images.account_active, width: 26, color: AppColor.primary,),
      title: "Account",
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
        initialRoute: "/pages/accounts",
        navigatorKey: locator<NavigationService>().getBottomKeyByIndex(4),
      ),
    ),];

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
        key: locator<NavigationService>().tabBarKey,
        controller: viewModel.bottomNavController,
        backgroundColor: AppColor.secondaryBackground,
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
        onItemSelected: (index) {
          debugPrint("Selected bottom : ${persistentBottomItems[index].title}");
          locator<AnalyticsService>().logFooterNavigation(act:persistentBottomItems[index].title,label:persistentBottomItems[index].title);
          if (index == 3) {
            locator<EventBusService>().eventBus.fire(CartRefreshEvent());
          }
        },
        items: persistentBottomItems,
        padding: const NavBarPadding.all(4),
        hideNavigationBarWhenKeyboardShows: true,
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        decoration: const NavBarDecoration(
            // boxShadow: AppStyle.topShadow,
          border: Border(top: BorderSide(color: AppColor.outlineBorder, width: 0.5))
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
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

class PersistentBottomNav extends PersistentBottomNavBarItem {
  PersistentBottomNav({
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
