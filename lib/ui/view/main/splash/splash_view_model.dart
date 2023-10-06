import 'package:bullion/core/models/module/page_settings.dart';
import 'package:bullion/helper/firebase_remote_helper.dart';
import 'package:bullion/helper/logger.dart';
import 'package:bullion/helper/update_checker.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/api_request/page_request.dart';
import 'package:bullion/services/page_storage_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/cupertino.dart';

class SplashViewModel extends VGTSBaseViewModel {
  @override
  Future onInit() async {
    await locator<FirebaseRemoteHelper>().configure();
    await preferenceService.init();

    try {
      try {
        await locator<UpdateChecker>().versionCheck();
      } catch (e) {
        Logger.d(e.toString());
        print("TOTAL VALUE");
      }

      Map<String, Future<PageSettings?>> futures = {
        "Home": request<PageSettings>(PageRequest.fetch(path: "/pages/home")),
        "Shop": request<PageSettings>(PageRequest.fetch(path: "/pages/shop")),
        "Deals": request<PageSettings>(PageRequest.fetch(path: "/pages/deals")),
        "Charts": request<PageSettings>(PageRequest.fetch(path: "/spot-prices"))
      };

      Future.wait([...futures.values.toList()]).then((value) {
        for (int i = 0; i < value.length; i++) {
          locator<PageStorageService>().write(
              navigationService.navigatorKey.currentContext!,
              PageStorageKey(futures.keys.toList()[i]),
              value[i]);
        }
      }).whenComplete(() async {
        if (preferenceService.getBearerToken().isNotEmpty) {
          navigationService.popAllAndPushNamed(Routes.dashboard);
          return;
        }
        navigationService.popAllAndPushNamed(Routes.introPage);
      });
    } catch (ex, s) {
      debugPrint("EXCEPTION $ex");
      Logger.e(ex.toString(), s: s);
    }

    return super.onInit();
  }
}
