// import 'package:bullion/locator.dart';
// import 'package:bullion/services/appconfig_service.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:bullion/locator.dart';
// import 'package:bullion/router.dart';
// import 'package:bullion/services/appconfig_service.dart';
// import 'package:bullion/services/security_service.dart';
// import 'package:bullion/services/shared/dialog_service.dart';
// import 'package:bullion/services/shared/navigation_service.dart';
// import 'package:bullion/ui/v2/views/settings/notification_prompt_bottom_sheet.dart';
//
// class PushNotificationService {
//   final AppConfigService? _appConfigService = locator<AppConfigService>();
//
//   int _tab = 0;
//
//   //Remove these when v1 is removed
//   getReturnTab() => _tab;
//   setReturnTab(int tab) => _tab = tab;
//
//
//   Future<void> configure() async {
//     debugPrint(_appConfigService!.config!.oneSignalID);
//     OneSignal.shared.setAppId(_appConfigService!.config!.oneSignalID!);
//
//     OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {
//       print("Subscription Observer");
//     });
//   }
//
//   Future<void> initNotificationListener() async {
//     debugPrint("Initialized Notification Listener");
//
//     OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) async {
//       try {
//         String? url = result.notification.additionalData!['target_url'];
//
//         if (url?.isNotEmpty == true) {
//           Uri uri = Uri.parse(url!);
//           String uriPath = uri.path;
//           if (uriPath == "/") {
//             uri = uri.replace(path: Routes.home);
//           }
//           if (locator<SecurityService>().locked) {
//             locator<SecurityService>().setPendingLinkData(uri.path + (uri.hasQuery ? "?${uri.query}" : ""),);
//           } else {
//             locator<NavigationService>().pushNamed(uri.path + (uri.hasQuery ? "?${uri.query}" : ""),);
//           }
//         }
//       } on Exception catch (e) {
//         print(e.toString());
//       }
//     });
//
//     OneSignal.shared.setInAppMessageClickedHandler((OSInAppMessageAction action) async {
//       try {
//         if (action.clickName != null) {
//           Uri? uri = Uri.tryParse(action.clickName!);
//           if (uri != null) {
//             locator<NavigationService>().pushNamed(
//               uri.path + (uri.hasQuery ? "?${uri.query}" : ""),
//             );
//           }
//         }
//       } on Exception catch (e) {
//         print(e.toString());
//       }
//     });
//   }
//
//   Future<Map<String, dynamic>> setUser(int? userId) async {
//     return await OneSignal.shared.setExternalUserId(userId.toString());
//     //TODO: send OneSignal player ID to APMEX
//   }
//
//   Future<bool> promptOneSignal({bool fallbackToSettings = false}) async {
//     return await OneSignal.shared.promptUserForPushNotificationPermission(
//         fallbackToSettings: fallbackToSettings);
//   }
//
//   checkPermissionAndPromptSettings(String title, {String description = "Never miss an update with push notifications"}) async {
//     OSDeviceState? status = await (OneSignal.shared.getDeviceState());
//     if (status!.hasNotificationPermission) {
//       return true;
//     }
//
//     locator<DialogService>().showBottomSheet(
//         child: NotificationPromptBottomSheet(title, description));
//     return false;
//   }
//
// }
