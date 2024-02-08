import 'package:bullion/locator.dart';
import 'package:bullion/services/appconfig_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:bullion/router.dart';

class PushNotificationService {
  final AppConfigService _appConfigService = locator<AppConfigService>();

  int _tab = 0;

  //Remove these when v1 is removed
  getReturnTab() => _tab;
  setReturnTab(int tab) => _tab = tab;


  Future<void> configure() async {
    debugPrint(_appConfigService.config!.oneSignalID);
    OneSignal.initialize(_appConfigService.config!.oneSignalID!);
  }

  Future<void> initNotificationListener() async {
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
          locator<NavigationService>().pushNamed(uri.path + (uri.hasQuery ? "?${uri.query}" : ""),);
        }
      } on Exception catch (e) {
        print(e.toString());
      }
    });


    OneSignal.InAppMessages.addClickListener((OSInAppMessageClickEvent action) {
      try {
        if (action.result.url != null) {
          Uri? uri = Uri.tryParse(action.result.url!);
          if (uri != null) {
            locator<NavigationService>().pushNamed(uri.path + (uri.hasQuery ? "?${uri.query}" : ""),);
          }
        }
      } on Exception catch (e) {
        print(e.toString());
      }
    });

  }

  Future<void> setUser(int? userId) async {
    return await OneSignal.login(userId.toString());
  }

  Future<bool> promptOneSignal({bool fallbackToSettings = false}) async {
    return await OneSignal.Notifications.requestPermission(fallbackToSettings);
  }

  // checkPermissionAndPromptSettings(String title, {String description = "Never miss an update with push notifications"}) async {
  //   OSDeviceState? status = await (OneSignal.getDeviceState());
  //   if (status!.hasNotificationPermission) {
  //     return true;
  //   }
  //
  //   locator<DialogService>().showBottomSheet(
  //       child: NotificationPromptBottomSheet(title, description));
  //   return false;
  // }

}
