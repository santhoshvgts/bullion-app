import 'dart:io';

import 'package:bullion/helper/firebase_remote_helper.dart';
import 'package:bullion/helper/logger.dart';
import 'package:bullion/helper/update_checker.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
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
        print(e);
      }

      if (preferenceService.getBearerToken().isNotEmpty) {
        try {
          Future.wait([
            Future.delayed(const Duration(milliseconds: 300)),
          ]).whenComplete(() async {
            navigationService.popAllAndPushNamed(Routes.dashboard);
          });
        } catch (ex, s) {
          Logger.e(ex.toString(), s: s);
          return;
        }
      } else {
        Future.delayed(const Duration(milliseconds: 300)).then((value) {
          navigationService.popAllAndPushNamed(Routes.introPage);
        });
      }
    } catch (ex) {
      debugPrint("EXCEPTION $ex");
    }

    return super.onInit();
  }
}
