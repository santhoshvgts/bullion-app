import 'package:bullion/locator.dart';
import 'package:bullion/services/checkout/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class PreferenceService {
  static const String bearerToken = "BEARERTOKEN";
  static const String refreshToken = "REFRESHTOKEN";
  static const String userName = "USERNAME";
  static const String deviceId = "DEVICEID";
  static const String is_first_time_app_open = "IS_FIRST_TIME_APP_OPEN";
  static const String user = "USER";
  static const String cartId = "CART_ID";

  static const String _auth = "auth";
  static const String appState = "APPSTATE";

  late SharedPreferences pref;

  init() async {
    pref = await SharedPreferences.getInstance();
  }

  // Bearer Token
  //
  setBearerToken(String value) {
    pref.setString(bearerToken, value);
    debugPrint("Bearer Token stored successfully");
  }

  String getBearerToken() {
    return pref.getString(bearerToken) ?? "";
  }

  setAuth(bool value) {
    pref.setBool(_auth, value);
    debugPrint("auth:$value stored successfully");
  }

  bool getAuth() {
    return pref.getBool(_auth) ?? false;
  }

  setResumeSate(String value) {
    pref.setString(appState, value);
    debugPrint("$appState stored successfully");
  }

  String getResumeState() {
    return pref.getString(appState) ?? '';
  }

  // User Name
  //
  setUserName(String value) async {
    pref.setString(userName, value);
    debugPrint("Name  stored successfully");
  }

  String getName() {
    return pref.getString(userName) ?? "";
  }

  // Authentication Status
  //
  setFirstTimeAppOpen(bool value) async {
    pref.setBool(is_first_time_app_open, value);
    debugPrint("Is First Time App Open stored successfully");
  }

  bool isFirstTimeAppOpen() {
    return pref.getBool(is_first_time_app_open) ?? true;
  }

  // Refresh Token
  //
  setRefreshToken(String value) {
    pref.setString(refreshToken, value);
    debugPrint("Refresh Token stored successfully");
  }

  String getRefreshToken() {
    return pref.getString(refreshToken) ?? "";
  }

  // Device Id
  //
  Future<String?> getDeviceId() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString(deviceId) == null) {
      var uuid = const Uuid();
      var id = uuid.v1();
      setDeviceId(id);
      debugPrint("Device ID $id");
      return id;
    }
    debugPrint("Device ID ${pref.getString(deviceId)}");
    return pref.getString(deviceId);
  }

  setDeviceId(String value) async {
    pref.setString(deviceId, value);
    debugPrint("Device ID stored successfully");
  }

  setCartId(String? value) async {
    if (value == "-1") {
      locator<CartService>().clear();
      pref.remove(cartId);
    } else {
      pref.setString(cartId, value!);
    }
  }

  removeCartId() async {
    pref.remove(cartId);
  }

  String? getCartId() {
    return pref.getString(cartId);
  }

  // Clear Data From Preference Service
  clearData() async {
    // pref.clear();
    for (String key in pref.getKeys()) {
      if (key != deviceId) {
        pref.remove(key);
      }
    }
    // await locator<PageStorageService>().write(locator<NavigationService>().navigatorKey.currentContext!, const PageStorageKey('Home'), null);
    // await locator<PageStorageService>().write(locator<NavigationService>().navigatorKey.currentContext!, const PageStorageKey("Spot Price"), null);
    // await locator<PageStorageService>().write(locator<NavigationService>().navigatorKey.currentContext!, const PageStorageKey("BullionClub"), null);
  }

  //delete
  deleteData() async {
    pref.clear();
    // await locator<PageStorageService>().write(locator<NavigationService>().navigatorKey.currentContext!, const PageStorageKey('Home'), null);
  }
}
