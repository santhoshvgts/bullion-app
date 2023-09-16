import 'dart:core';
import 'package:bullion/helper/utils.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/preference_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class DeviceService {
  String? _deviceId;
  String? _userAgent;
  String? _riskifiedSessionId;
  Map<String, String>? _deviceInfoHeaders;
  PackageInfo? packageInfo;

  String? _webViewUserAgent;

  final PreferenceService? preferenceService = locator<PreferenceService>();

  Future<PackageInfo?> initPlatformPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }

  String? getRiskifiedSessionId() {
    if (isNullOrEmpty(_riskifiedSessionId)) {
      _riskifiedSessionId = Uuid().v4();
    }

    return _riskifiedSessionId;
  }

  Future<String?> getEnvironment() async {

    String environment;

    packageInfo = await PackageInfo.fromPlatform();
    String? _packageName = packageInfo?.packageName;
    if (_packageName?.endsWith(".ecom.dev") == true || _packageName?.endsWith(".dev") == true) {
      environment = "DEVELOP";
    } else {
      environment = "PROD";
    }
    debugPrint(environment);
    return environment;
  }


  String? getUserAgent() {
    if (!isNullOrEmpty(_userAgent)) {
      return _userAgent;
    }
    String ogappVersionString;
    if (Platform.isIOS || Platform.isAndroid) {
      ogappVersionString = "ogapp/${packageInfo!.version}";
    } else
      ogappVersionString = "ogapp/?";
    final dartVersionString = Platform.version.split(" ").first;
    final osString = Platform.operatingSystem;
    final osVersionString = Platform.operatingSystemVersion.split(" ").first;
    _userAgent =
        "$ogappVersionString Dart/$dartVersionString OS/$osString-$osVersionString";
    debugPrint("Useragent $_userAgent");
    return _userAgent;
  }

  String? getWebViewUserAgent() {
    if (!isNullOrEmpty(_webViewUserAgent)) {
      return _webViewUserAgent;
    }
    String ogappVersionString;
    if (Platform.isIOS || Platform.isAndroid) {
      ogappVersionString = "ogapp/${packageInfo!.version}";
    } else
      ogappVersionString = "ogapp/?";
    final dartVersionString = Platform.version.split(" ").first;

    String agent = '';
    if (Platform.isIOS) {
      agent = "Mozilla/5.0 (iPhone; CPU iPhone OS 16_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Mobile/15E148 Safari/604.1";
    } else {
      agent = 'Mozilla/5.0 (Linux; Android 11; Pixel 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.91 Mobile Safari/537.36';
    }

    _webViewUserAgent = "$ogappVersionString Dart/$dartVersionString ${agent}";
    debugPrint("Web UserAgent $_webViewUserAgent");
    return _webViewUserAgent;
  }

  Future<Map<String, String>?> getDeviceInfoHeaders() async {
    if (_deviceInfoHeaders != null) {
      return _deviceInfoHeaders;
    }
    _deviceInfoHeaders = <String, String>{};
    try {
      final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo info = await _deviceInfoPlugin.androidInfo;
        _deviceInfoHeaders!['deviceType'] = "Android";
        _deviceInfoHeaders!['deviceName'] = info.model;
        _deviceInfoHeaders!['devicePushToken'] = info.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo info = await _deviceInfoPlugin.iosInfo;
        _deviceInfoHeaders!['deviceType'] = "iOS";
        _deviceInfoHeaders!['deviceName'] = info.model ?? '';
        _deviceInfoHeaders!['devicePushToken'] = info.identifierForVendor ?? '';
      }
    } on Exception {}
    return _deviceInfoHeaders;
  }

  Future<String?> getDeviceId() async {
    _deviceId ??= await preferenceService!.getDeviceId();
    return _deviceId;
  }

}
