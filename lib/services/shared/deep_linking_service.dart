import 'dart:async';
import 'dart:io';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/helper/logger.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/services/shared/sign_in_request.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:uni_links/uni_links.dart';

class DeepLinkingService {

  StreamSubscription? _linkSubscription;
  StreamSubscription<PendingDynamicLinkData>? _firebaseLinkSubscription;

  bool isStreamInitialized = false;

  var deepLinkedUrl;

  Future handleInitialLink() async {
    try {

      Uri? initialLink = await getInitialUri();
      if (initialLink != null && initialLink != deepLinkedUrl) {
        _processLink(initialLink);
      }

      if (Platform.isIOS) {
        PendingDynamicLinkData? dynamicLinkData = await FirebaseDynamicLinks.instance.getInitialLink();
        _dynamicLinkNavigate(dynamicLinkData);
      }

    } catch (ex, st) {
      Logger.e(ex.toString(), s: st);
    }
  }

  Future handleStreamDeepLinks() async {
    if (isStreamInitialized) {
      return;
    }

    // UNI LINK STREAM LISTENER
    _linkSubscription = uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          _processLink(uri);
        }
    }, onError: (Object err) {
      print('Got error $err');
    });

    // FIREBASE DYNAMIC LINK - Stream Listener only for iOS
    if (Platform.isIOS) {
      _firebaseLinkSubscription = FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
        _dynamicLinkNavigate(dynamicLinkData);
      });
    }

    isStreamInitialized = true;
  }

  _processLink(Uri link) async {

    try {
      deepLinkedUrl = link;

      try {
        var dynamicLinkData = await FirebaseDynamicLinks.instance.getDynamicLink(link);
        print("dynamicLinkData");
        print(dynamicLinkData);

        if (dynamicLinkData != null) {
          // Redirect when the uri like below examplem
          // https://apmexdev.page.link/Go1D (create in dynamic links)
          //
          _dynamicLinkNavigate(dynamicLinkData);
          return;
        }
      } catch (ex, s) {
        Logger.e(ex.toString(), s: s);
      }

      // Redirect only when the uri like below example
      // https://apmexdev.page.link/product/12477/1-gram-gold-bar-secondary-market
      // https://apmexdev.smart.link/product/12477/1-gram-gold-bar-secondary-market
      //
      _parseAndNavigate(link);
    } catch (ex, s) {
      Logger.e(ex.toString(), s: s);
    }
  }

  _dynamicLinkNavigate(PendingDynamicLinkData? dynamicLinkData) {
    if (dynamicLinkData != null) {
      Uri uri = dynamicLinkData.link;
      _parseAndNavigate(uri);
    }
  }

  _parseAndNavigate(Uri uri) async {
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

  DeepLinkingService._privateConstructor();

  static final DeepLinkingService instance = DeepLinkingService._privateConstructor();

  cancel() {
    if (_linkSubscription != null) {
      _linkSubscription!.cancel();
    }

    if (_firebaseLinkSubscription != null) {
      _firebaseLinkSubscription!.cancel();
    }
  }

  pause() {
    if (_linkSubscription?.isPaused == false) _linkSubscription?.pause();
    if (Platform.isIOS && _firebaseLinkSubscription?.isPaused == false) _firebaseLinkSubscription?.pause();
  }

  resume() {
    if (_linkSubscription?.isPaused == true) _linkSubscription?.resume();
    if (Platform.isIOS && _firebaseLinkSubscription?.isPaused == true) _firebaseLinkSubscription?.resume();
  }

}