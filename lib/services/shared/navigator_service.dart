import 'package:bullion/router.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';
import 'analytics_service.dart';

class NavigationService {
  final _navigatorKey = GlobalKey<NavigatorState>();

  final tabBarKey = GlobalKey();

  GlobalKey<NavigatorState> get navigatorKey {
    return _navigatorKey;
  }

  Future<dynamic>? pushNamed(
    String? routeName, {
    Object? arguments,
    bool rootNavigator = false,
  }) {
    if (routeName?.isEmpty != false) {
      return null;
    }

    Uri uri = Uri.parse(routeName!);

    if (uri.pathSegments.isNotEmpty) {
      if (Uri.parse(routeName).pathSegments.first == "pages") {
        switch (Uri.parse(routeName).pathSegments.last) {
          case "home":
            changeTab(0);
            popUntil(Routes.dashboard);
            return null;
          case "deals":
            changeTab(1);
            popUntil(Routes.dashboard);
            return null;
          case "charts":
            changeTab(2);
            popUntil(Routes.dashboard);
            return null;
          case "bullion-club":
            changeTab(3);
            popUntil(Routes.dashboard);
            return null;
        }
      }
    }

    locator<AnalyticsService>().logScreenView(routeName);

    // if (rootNavigator) {
    //   return _bottomNavKey.currentState?.pushNamed(
    //     routeName,
    //     arguments: arguments,
    //   );
    // }
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic> pushReplacementNamed(
    String routeName, {
    Object? arguments,
    bool rootNavigator = false,
  }) {
    // if (rootNavigator) {
    //   return _bottomNavKey.currentState!.pushReplacementNamed(
    //     routeName,
    //     arguments: arguments,
    //   );
    // }
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
    required String removeUntil,
  }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      ModalRoute.withName(removeUntil),
      arguments: arguments,
    );
  }

  Future<dynamic> popAllAndPushNamed(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (_) => false,
      arguments: arguments,
    );
  }

  Future<dynamic> popAndPushNamed(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.popAndPushNamed(
      routeName,
      arguments: arguments,
    );
  }

  popUntil(String routeName) {
    navigatorKey.currentState!.popUntil(ModalRoute.withName(routeName));
  }

  Future<dynamic> pushAndPopUntil(String routeName,
      {Object? arguments, required String removeRouteName}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName, ModalRoute.withName(removeRouteName),
        arguments: arguments);
  }

  Future<dynamic> push(Route route) => navigatorKey.currentState!.push(route);

  void pop({returnValue}) {
    navigatorKey.currentState!.pop(returnValue);
  }

  void changeTab(int index) {
    final BottomNavigationBar navigationBar =
        tabBarKey.currentWidget as BottomNavigationBar;
    if (navigationBar.currentIndex != index) {
      navigationBar.onTap!(index);
    }
  }
}
