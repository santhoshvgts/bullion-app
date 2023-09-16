import 'dart:convert';
import 'dart:core';
import 'package:bullion/helper/utils.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/preference_service.dart';

class TokenService {
  String? _refreshToken;
  String? _token;

  final PreferenceService? preferenceService = locator<PreferenceService>();

  Map<String, dynamic>? _decodedToken;

  String? getToken() {
    if (!isNullOrEmpty(_token)) {
      return _token;
    }
    _token = preferenceService!.getBearerToken();
    return _token;
  }

  Future setToken(String token) async {
    _token = token;
    _decodedToken = null;

    preferenceService!.setBearerToken(token);
  }

  Future setTokens(String? token, String? refreshToken) async {
    if (!isNullOrEmpty(token)) {
      Future.wait([
        setToken(token!),
        setRefreshToken(refreshToken!),
      ]);
    }
  }

  Future<String?> getRefreshToken() async {
    if (!isNullOrEmpty(_refreshToken)) {
      return _refreshToken;
    }
    _refreshToken = preferenceService!.getRefreshToken();
    return _refreshToken;
  }

  Future setRefreshToken(String refreshToken) async {
    _refreshToken = refreshToken;
    preferenceService!.setRefreshToken(refreshToken);
  }

  Future clearToken() async {
    _token = null;
    _decodedToken = null;
    _refreshToken = null;
  }

  Map<String, dynamic>? decodeToken() {
    if (_decodedToken != null) {
      return _decodedToken;
    }
    if (_token == null) {
      throw Exception('Token not found');
    }

    final parts = _token!.split('.');
    if (parts.length != 3) {
      throw Exception('JWT must have 3 parts.');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('Cannot decode the token.');
    }
    _decodedToken = payloadMap;
    return _decodedToken;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!');
    }

    return utf8.decode(base64Url.decode(output));
  }

  DateTime? getTokenExpirationDate() {
    var decoded = decodeToken()!;
    if (decoded["exp"] == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(decoded["exp"] * 1000);
  }

  int tokenSecondsRemaining() {
    var d = getTokenExpirationDate();
    if (d == null) {
      return 0;
    }
    var timeRemaining = d.difference(DateTime.now().toUtc());
    return timeRemaining.inSeconds;
  }

  bool tokenNeedsRefresh({int minutes = 5}) {
    var sRemaining = tokenSecondsRemaining();
    return sRemaining < (60 * minutes);
  }
}
