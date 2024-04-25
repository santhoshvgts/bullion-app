import 'package:bullion/locator.dart';
import 'package:bullion/services/appconfig_service.dart';
import 'package:flutter/foundation.dart';
import 'package:kochava_tracker/kochava_tracker.dart';

class KochavaService {

  init() {
    if (locator<AppConfigService>().config?.kochavaInfo != null) {
      KochavaTracker.instance.registerAndroidAppGuid(locator<AppConfigService>().config!.kochavaInfo!.AndroidGUID);
      KochavaTracker.instance.registerIosAppGuid(locator<AppConfigService>().config!.kochavaInfo!.IosGUID);
      KochavaTracker.instance.setAppLimitAdTracking(true);
      KochavaTracker.instance.enableIosAtt();
      KochavaTracker.instance.setIosAttAuthorizationAutoRequest(true);
      if (kReleaseMode) {
        KochavaTracker.instance.setLogLevel(KochavaTrackerLogLevel.Info);
      } else {
        KochavaTracker.instance.setLogLevel(KochavaTrackerLogLevel.Trace);
      }
      KochavaTracker.instance.start();
    }
  }

}