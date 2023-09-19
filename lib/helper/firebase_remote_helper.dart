// ignore_for_file: avoid_print

import 'dart:io';

import 'package:bullion/services/appconfig_service.dart';
import 'package:bullion/services/toast_service.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'logger.dart';
import '../locator.dart';

class FirebaseRemoteHelper {
  final AppConfigService appConfigService = locator<AppConfigService>();
  late FirebaseRemoteConfig remoteConfig;

  Future<void> configure() async {
    remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(fetchTimeout: remoteConfig.settings.fetchTimeout, minimumFetchInterval: const Duration(minutes: 0)));

      await remoteConfig.fetchAndActivate();
      appConfigService.setConfig(getStringValue("app_config"));

      Logger.d('Init RemoteConfig: SUCCESS');
      Logger.d(appConfigService.config!.toJson().toString());
    } catch (exception, stacktrace) {
      if (appConfigService.config == null) {
        Logger.e("Remote Config Fetch", e: exception, s: stacktrace);
        locator<ToastService>().showText(
          text: "There is a problem connecting to the remote server. Please try again",
        );

        await Future.delayed(const Duration(seconds: 5));
        exit(0);
      }
    } finally {
      if (appConfigService.config == null) {
        Logger.e("Remote Config Fetch", e: "AppConfig Stored as Null", s: null);
      }
    }
  }

  String getStringValue(String value) => remoteConfig.getString(value);
  bool getBoolValue(String value) => remoteConfig.getBool(value);
  int getIntValue(String value) => remoteConfig.getInt(value);
  double getDoubleValue(String value) => remoteConfig.getDouble(value);
}
