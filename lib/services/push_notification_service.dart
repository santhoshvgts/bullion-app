import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/models/auth/user.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/appconfig_service.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/services/shared/sign_in_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:bullion/router.dart';

import '../ui/view/settings/notification_prompt_bottom_sheet.dart';

class PushNotificationService {
  final AppConfigService _appConfigService = locator<AppConfigService>();

  bool initialized = false;

  int _tab = 0;

  //Remove these when v1 is removed
  getReturnTab() => _tab;
  setReturnTab(int tab) => _tab = tab;

  bool hasPermission = false;


  Future<void> configure() async {
    debugPrint(_appConfigService.config!.oneSignalID);
    OneSignal.initialize(_appConfigService.config!.oneSignalID!);
  }

  Future<void> initNotificationListener() async {
    if (initialized) {
      return;
    }

    debugPrint("Initialized Notification Listener");
    OneSignal.Notifications.addClickListener((OSNotificationClickEvent result) async {
      try {
        String? url = result.notification.additionalData!['target_url'];

        if (url?.isNotEmpty == true) {
          Uri uri = Uri.parse(url!);
          String uriPath = uri.path;
          if (uriPath == "/") {
            uri = uri.replace(path: Routes.home);
          }

          if (Routes.authRoute.where((e)=> e.startsWith(uri.path)).isNotEmpty == true) {
            if (!locator<AuthenticationService>().isAuthenticated) {
              bool authenticated = await signInRequest(Images.iconPriceAlertBottom,
                  title: "Account",
                  content: "Sign in to do more with your account");
              if (!authenticated) return;
            }
          }

          locator<NavigationService>().pushNamed(uri.path + (uri.hasQuery ? "?${uri.query}" : ""),);
        }
      } on Exception catch (e) {
        print(e.toString());
      }
    });

    hasPermission = OneSignal.Notifications.permission;

    OneSignal.Notifications.addPermissionObserver((permission) {
      hasPermission = permission;
    });

    OneSignal.InAppMessages.addClickListener((OSInAppMessageClickEvent action) {
      try {
        if (action.result.actionId != null) {
          Uri? uri = Uri.tryParse(action.result.actionId!);
          if (uri != null) {
            locator<NavigationService>().pushNamed(uri.path + (uri.hasQuery ? "?${uri.query}" : ""),);
          }
        }
      } on Exception catch (e) {
        print(e.toString());
      }
    });

    initialized = true;
  }

  Future<void> setUser(User? user) async {
    if(user!=null)
    {
      OneSignal.User.addEmail(user.email!);
      OneSignal.User.addTagWithKey("email", user.email);
    }
    return await OneSignal.login(user!.userId.toString());
  }

  Future<void> logout() async {
    return await OneSignal.logout();
  }


  Future<bool> promptOneSignal({bool fallbackToSettings = false}) async {
    return await OneSignal.Notifications.requestPermission(fallbackToSettings);
  }

  checkPermissionAndPromptSettings(String title, {String description = "Never miss an update with push notifications"}) async {
    if (hasPermission) {
      return true;
    }

    AlertResponse response = await locator<DialogService>().showBottomSheet(child: NotificationPromptBottomSheet(title, description));
    return false;
  }

}
