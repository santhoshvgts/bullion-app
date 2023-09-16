import 'dart:async';

import 'package:bullion/core/models/auth/auth_response.dart';
import 'package:bullion/core/models/auth/user.dart';
import 'package:bullion/services/api_request/auth_request.dart';
import 'package:bullion/services/shared/api_base_service.dart';
import 'package:bullion/services/toast_service.dart';
import 'package:bullion/locator.dart';

import 'package:bullion/services/shared/preference_service.dart';
import 'package:bullion/services/token_service.dart';

import 'shared/analytics_service.dart';

class AuthenticationService {
  final ApiBaseService _apiBaseService = locator<ApiBaseService>();
  final TokenService _tokenService = locator<TokenService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  // final PushNotificationService? _pushService = locator<PushNotificationService>();

  User? _user;
  StreamController<User?> userController = StreamController<User?>();

  bool get isAuthenticated => _tokenService?.getToken()?.isNotEmpty == true;

  User? get getUser => _user;

  bool get isGuestUser {
    if (_user == null) {
      return false;
    }
    return _user!.isGuestAccount ?? false;
  }

  void _setUser(AuthResponse authResult) {
    if ((authResult.token != null) && (authResult.user != null)) {
      _tokenService.setTokens(
          authResult.token!.authToken, authResult.token!.refreshToken);
      userController.add(authResult.user);
      _user = authResult.user;
      _analyticsService.setUserId(_user!.userId);


      // TODO - Push Implementation
      // _pushService!.setUser(_user!.userId);

      // TODO - Sentry Implementation
      // configureSentryScope();
    }
  }

  setUser(AuthResponse authResult) => _setUser(authResult);

  updateUserProfile(User? user) {
    userController.add(user);
    _user = user;
    _analyticsService.setUserId(_user!.userId);

    // TODO - Push Implementation
    // _pushService!.setUser(_user!.userId);

    // TODO - Sentry Implementation
    // configureSentryScope();
  }

  Future<AuthResponse?> login(String email, String password) async {
    var authResult =  await _apiBaseService.request<AuthResponse>(AuthRequest.login(email, password));
    if (authResult != null) {
      _setUser(authResult);
      _analyticsService.loglogin();

      // TODO - Refresh Page Storage Service
      // await locator<PageStorageService>().write(locator<NavigationService>().navigatorKey.currentContext!, const PageStorageKey("Spot Price"), null);
    }
    return authResult;
  }

  Future<void> logout(String anyMessage) async {
    await _apiBaseService.logOut();

    // TODO - Clear Cart Service
    // await locator<CartService>().clear();
    locator<PreferenceService>().clearData();
    locator<TokenService>().clearToken();
    _user = null;
    userController.add(null);

    // TODO - Sentry Implementation
    // Sentry.configureScope((p0) => p0.setUser(null));
  }

  Future<AuthResponse?> register(
      String firstName, String lastName, String email, String password) async {
    var authResult = await _apiBaseService.request<AuthResponse>(AuthRequest.register(
      firstName,
      lastName,
      email,
      password,
    ));
    if (authResult != null) {
      _setUser(authResult);
      _analyticsService.logSignUp();
    }

    return authResult;
  }

  Future<AuthResponse?> registerAsGuest(String email) async {
    var authResult = await _apiBaseService.request<AuthResponse>(AuthRequest.registerAsGuest(email));
    if (authResult != null) {
      _setUser(authResult);
    }

    return authResult;
  }

  Future<AuthResponse?> resetPassword(String? key, String? email,
      String newPassword, String oldPassword) async {
    var authResult = await _apiBaseService.request<AuthResponse>(AuthRequest.resetPassword(key, email, newPassword, oldPassword));
    if (authResult != null) {
      _setUser(authResult);
      _analyticsService.loglogin();
    }

    return authResult;
  }

  Future<AuthResponse?> guestToAccount(String password, bool emailOptIn) async {
    var authResult = await _apiBaseService.request<AuthResponse>(AuthRequest.guestToAccount(password, emailOptIn));
    if (authResult != null) {
      _setUser(authResult);
      _analyticsService.logSignUp();
    }

    return authResult;
  }

  Future<User?> getUserInfo() async {
    String token = _tokenService.getToken()!;
    if (token.isEmpty) {
      return null;
    }

    var user = await _apiBaseService.request<User>(AuthRequest.getUserInfo());
    if (user != null) {
      updateUserProfile(user);
    }
    return user;
  }

  // TODO - Sentry Implementation
  // configureSentryScope() {
  //   if (isAuthenticated) {
  //     Sentry.configureScope(
  //       (scope) => scope.setUser(SentryUser(
  //           id: _user?.userId.toString(),
  //           email: _user?.email,
  //           username: _user?.email,
  //           name: "${_user?.firstName ?? ''} ${_user?.lastName ?? ''}",
  //           data: _user?.toJson())),
  //     );
  //   } else {
  //     Sentry.configureScope((scope) => scope.setUser(null));
  //   }
  // }
}
