import 'dart:async';
import 'dart:io';

import 'package:bullion/core/constants/module_type.dart';
import 'package:bullion/core/models/auth/auth_response.dart';
import 'package:bullion/core/models/auth/user.dart';
import 'package:bullion/helper/logger.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/api_request/auth_request.dart';
import 'package:bullion/services/checkout/cart_service.dart';
import 'package:bullion/services/push_notification_service.dart';
import 'package:bullion/services/shared/api_base_service.dart';
import 'package:bullion/services/shared/api_model/error_response_exception.dart';
import 'package:bullion/services/shared/eventbus_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/services/shared/preference_service.dart';
import 'package:bullion/services/token_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'shared/analytics_service.dart';
import 'shared/dialog_service.dart';

class AuthenticationService {
  final ApiBaseService _apiBaseService = locator<ApiBaseService>();
  final TokenService _tokenService = locator<TokenService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final DialogService _dialogService = locator<DialogService>();

  final PushNotificationService _pushService = locator<PushNotificationService>();

  User? _user;
  StreamController<User?> userController = StreamController<User?>.broadcast();

  bool get isAuthenticated => _tokenService.getToken()?.isNotEmpty == true;

  User? get getUser => _user;

  bool get isGuestUser {
    if (_user == null) {
      return false;
    }
    return _user!.isGuestAccount ?? false;
  }

  void _setUser(AuthResponse authResult) {
    if ((authResult.token != null) && (authResult.user != null)) {
      _tokenService.setTokens(authResult.token!.authToken, authResult.token!.refreshToken);
      userController.add(authResult.user);
      _user = authResult.user;
      _analyticsService.setUserId(_user!.userId);

      _pushService.setUser(_user!);
      configureSentryScope();
    }
  }

  setUser(AuthResponse authResult) => _setUser(authResult);

  updateUserProfile(User? user) {
    userController.add(user);
    _user = user;
    _analyticsService.setUserId(_user!.userId);

    _pushService.setUser(_user!);
    configureSentryScope();
  }

  Future<AuthResponse?> login(String email, String password) async {
    try {
      var authResult = await _apiBaseService
          .request<AuthResponse>(AuthRequest.login(email, password));
      _setUser(authResult);
      _analyticsService.logLogin();

      locator<EventBusService>().eventBus.fire(RefreshDataEvent(RefreshType.homeRefresh));
      locator<EventBusService>().eventBus.fire(RefreshDataEvent(RefreshType.accountRefresh));

      return authResult;
    } on ErrorResponseException catch (ex) {
      _showAlert(ex, "Error");
    }
    return null;
  }


  Future<AuthResponse?> signInWithGoogle() async {
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().signOut();
    }

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        // clientId: "836178511980-aqd8idj22a64itu788efud4k5bvhriti.apps.googleusercontent.com",
        // serverClientId: "836178511980-aqd8idj22a64itu788efud4k5bvhriti.apps.googleusercontent.com",
      ).signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      if (googleAuth != null) {
        var authResult = await _apiBaseService
            .request<AuthResponse>(AuthRequest.googleAuth(googleUser!.email, googleAuth.accessToken!));
        _setUser(authResult);

        locator<EventBusService>().eventBus.fire(RefreshDataEvent(RefreshType.homeRefresh));
        locator<EventBusService>().eventBus.fire(RefreshDataEvent(RefreshType.accountRefresh));

        return authResult;
      }

    }  on ErrorResponseException catch (ex) {
      _showAlert(ex, "Error");
    }  catch (ex, s) {
      Logger.d(ex.toString(), s: s);
    }

    // final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    //
    // if (googleAuth != null) {
    //   final credential = FA.GoogleAuthProvider.credential(
    //     accessToken: googleAuth.accessToken,
    //     idToken: googleAuth.idToken,
    //   );
    //   return await FA.FirebaseAuth.instance.signInWithCredential(credential);
    // }
    return null;
  }


  Future<void> logout(String anyMessage) async {
    try {
      await _apiBaseService.logOut();
    } on ErrorResponseException catch (ex) {
      _showAlert(ex, "Error");
    }

    await locator<CartService>().clear();
    locator<PreferenceService>().clearData();
    locator<TokenService>().clearToken();
    locator<PushNotificationService>().logout();
    _user = null;
    userController.add(null);

    Sentry.configureScope((p0) => p0.setUser(null));

    //TODO - Revert to Intro Page, after entering the proper content in that page
    // locator<NavigationService>().popAllAndPushNamed(Routes.introPage);
    locator<NavigationService>().popAllAndPushNamed(Routes.splash);
  }

  Future<AuthResponse?> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      var authResult = await _apiBaseService.request<AuthResponse>(
        AuthRequest.register(
          firstName,
          lastName,
          email,
          password,
          confirmPassword,
        ),
      );
      _setUser(authResult);
      _analyticsService.logSignUp();
      locator<EventBusService>().eventBus.fire(RefreshDataEvent(RefreshType.homeRefresh));
      locator<EventBusService>().eventBus.fire(RefreshDataEvent(RefreshType.accountRefresh));
      return authResult;
    } on ErrorResponseException catch (ex) {
      _showAlert(ex, "Error");
    }
    return null;
  }

  Future<AuthResponse?> registerAsGuest(String email) async {
    try {
      var authResult = await _apiBaseService
          .request<AuthResponse>(AuthRequest.registerAsGuest(email));
      _setUser(authResult);

      locator<EventBusService>().eventBus.fire(RefreshDataEvent(RefreshType.homeRefresh));
      locator<EventBusService>().eventBus.fire(RefreshDataEvent(RefreshType.accountRefresh));

      return authResult;
    } on ErrorResponseException catch (ex) {
      _showAlert(ex, "Error");
    }
    return null;
  }

  Future<AuthResponse?> resetPassword(
    String? key,
    String? email,
    String newPassword,
    String oldPassword,
  ) async {
    try {
      var authResult = await _apiBaseService.request<AuthResponse>(
          AuthRequest.resetPassword(key, email, newPassword, oldPassword));
      _setUser(authResult);
      _analyticsService.logLogin();

      return authResult;
    } on ErrorResponseException catch (ex) {
      _showAlert(ex, "Error");
    }
    return null;
  }

  Future<AuthResponse?> guestToAccount(String password, bool emailOptIn) async {
    try {
      var authResult = await _apiBaseService.request<AuthResponse>(
          AuthRequest.guestToAccount(password, emailOptIn));
      _setUser(authResult);
      _analyticsService.logSignUp();

      return authResult;
    } on ErrorResponseException catch (ex) {
      _showAlert(ex, "Error");
    }
    return null;
  }

  Future<User?> getUserInfo() async {
    try {
      String token = _tokenService.getToken()!;
      if (token.isEmpty) {
        return null;
      }

      var user = await _apiBaseService.request<User>(AuthRequest.getUserInfo());
      updateUserProfile(user);
      return user;
    } on ErrorResponseException catch (ex) {
      _showAlert(ex, "Error");
    }
    return null;
  }

  _showAlert(ErrorResponseException error, String title) {
    _dialogService.showDialog(title: title, description: error.error?.getSingleMessage() ?? '-');
  }

  configureSentryScope() {
    if (isAuthenticated) {
      Sentry.configureScope(
        (scope) => scope.setUser(SentryUser(
            id: _user?.userId.toString(),
            email: _user?.email,
            username: _user?.email,
            name: "${_user?.firstName ?? ''} ${_user?.lastName ?? ''}",
            data: _user?.toJson())),
      );
    } else {
      Sentry.configureScope((scope) => scope.setUser(null));
    }
  }
}
