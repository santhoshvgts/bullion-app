// ignore_for_file: avoid_function_literals_in_foreach_calls, library_prefixes, unused_catch_stack

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bullion/core/exception/api_exceptions.dart';
import 'package:bullion/core/models/api/api_error_response.dart';
import 'package:bullion/core/models/auth/token.dart';
import 'package:bullion/core/models/auth/user.dart';
import 'package:bullion/core/models/base_model.dart';
import 'package:bullion/core/models/module/dynamic.dart';
import 'package:bullion/services/appconfig_service.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:bullion/services/shared/device_service.dart';
import 'package:bullion/services/shared/eventbus_service.dart';
import 'package:bullion/services/shared/request_method.dart';
import 'package:bullion/services/toast_service.dart';
import 'package:bullion/services/token_service.dart';
import 'package:http/http.dart' as HTTP;
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../helper/logger.dart';
import '../../locator.dart';
import 'api_base_helper.dart';
import 'api_model/error_response_exception.dart';
import 'api_model/no_response_exception.dart';
import 'api_model/request_settings.dart';
import 'dialog_service.dart';
import 'preference_service.dart';

class ApiBaseService extends ApiBaseHelper {
  final PreferenceService _preferenceService = locator<PreferenceService>();
  final AppConfigService _appConfigService = locator<AppConfigService>();
  final DeviceService _deviceService = locator<DeviceService>();
  final TokenService _tokenService = locator<TokenService>();
  final DialogService _dialogService = locator<DialogService>();

  User? get _user => locator<AuthenticationService>().getUser;

  var client = HTTP.Client();

  Future<List<T>> requestList<T extends BaseModel>(RequestSettings settings) async {
    try {
      var response = await _sendAsync(settings.method, settings.endPoint, settings.params, authenticated: settings.authenticated);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          return jsonDecode(utf8.decode(response.bodyBytes)).map((e) => BaseModel.createFromMap<T>(e)).cast<T>().toList();
        }
      }
    } on TimeoutException catch (exception, stacktrace) {
      _dialogService.showDialog(title: "Server Error", description: "There is a problem connecting server");
    } on ErrorResponseException catch (exception) {
      throw ErrorResponseException(error: exception.error);
    } catch (exception, stacktrace) {
      Logger.e(exception.toString(), e: exception, s: stacktrace);
    }
    throw NoResponseException(
      message: "No Response: something error",
    );
  }

  Future<T> request<T extends BaseModel>(RequestSettings settings) async {
    try {
      var response = await _sendAsync(settings.method, settings.endPoint, settings.params, authenticated: settings.authenticated);
      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          return BaseModel.createFromMap<T>(response.bodyBytes.isEmpty ? {} : jsonDecode(utf8.decode(response.bodyBytes)));
        }
      }
    } on TimeoutException catch (exception, stacktrace) {
      _dialogService.showDialog(title: "Server Error", description: "There is a problem connecting server");
    } on ErrorResponseException catch (exception) {
      throw ErrorResponseException(error: exception.error);
    } catch (exception, stacktrace) {
      Logger.e(exception.toString(), e: exception, s: stacktrace);
    }
    throw NoResponseException(
      message: "No Response: something error",
    );
  }

  Future<HTTP.Response?> _sendAsync(String method, String endPoint, Object? body, {Map<String, String>? queryParams, bool authenticated = true}) async {
    // Generate URL from Base Url & Endpoint
    // Concatenate query params if exists
    Logger.d(_appConfigService.config?.baseApiUrl);

    String baseUrl = _appConfigService.config!.baseApiUrl!;

    Logger.d(endPoint);

    endPoint = endPoint.startsWith("http") ? endPoint : baseUrl + endPoint;
    var url = Uri.parse(endPoint + (queryParams != null ? Uri(queryParameters: queryParams).query : ""));
    Logger.d(url.toString());

    // Create Http Request using Method & URL
    HTTP.Request requestMessage = HTTP.Request(method, url);

    // Add Body Content to Request, Serialize Body Object if it is not a String
    // Add Headers to Request from _headers() function
    if (body is! HTTP.MultipartRequest) requestMessage.body = (body is String) ? body : serialize(body);
    requestMessage.headers.addAll(await _headers(endPoint, body, authenticated));

    // Declared HTTP Response Object
    HTTP.Response? response;

    try {
      // If body Object is Multipart Request, add headers to body object
      if (body is HTTP.MultipartRequest) body.headers.addAll(requestMessage.headers);

      Logger.d(requestMessage.headers.toString());
      Logger.d(body.toString());

      // Stream Response using HTTP
      // Send body if it is a Multipart Request, else send Request Message
      response = await HTTP.Response.fromStream(await client.send(body is HTTP.MultipartRequest ? body : requestMessage));
    } on HttpException catch (e) {
      Logger.d("ERROR EXCEPTION $e");
      var error = ApiException(handleConnectionError());
      // ignore: unnecessary_null_comparison
      if ((error.error != null)) {
        locator<DialogService>().showDialog(title: "ERROR", description: error.error.getSingleMessage());
      }
    }

    // [Returns]
    // Process and Return Response data according to the Response Status Code
    return _handleResponse(response);
  }

  // [Returns]
  // Add Headers according to [body] Object Type
  // Add Authentication Token if [authenticated] is true
  Future<Map<String, String>> _headers(String path, Object? body, bool authenticated) async {
    Map<String, String> headerParams = {};
    headerParams["HttpHeaders.contentTypeHeader"] = "application/json";

    if (body is String) {
      headerParams["Content-Type"] = "application/x-www-form-urlencoded";
    } else if (body is Map || body is List) {
      headerParams['Accept'] = "application/json";
      headerParams["Content-Type"] = "application/json";
    } else if (body is HTTP.MultipartRequest) {
      headerParams['Accept'] = "application/json";
      headerParams["Content-Type"] = "multipart/form-data";
    }

    headerParams["User-Agent"] = _deviceService.getUserAgent()!;
    headerParams['OG-Device-Id'] = await _deviceService.getDeviceId() ?? '';
    headerParams['Session-Id'] = _deviceService.getRiskifiedSessionId()!;
    headerParams['App-Version'] = (await PackageInfo.fromPlatform()).version;
    headerParams['OG-User'] = await _getUserInfo();

    if (_preferenceService.getCartId() != null) {
      headerParams['ap-s'] = _preferenceService.getCartId()!;
    }

    if (authenticated && locator<AuthenticationService>().isAuthenticated == true) {
      headerParams['Authorization'] = 'Bearer ${await _getBearerToken()}';
    }

    if (path.contains("login")) {
      headerParams.addAll(await _deviceService.getDeviceInfoHeaders() ?? {});
    }

    return headerParams;
  }

  Future<Map<String, String?>> getWebViewHeader() async {
    Map<String, String?> headers = new Map();
    if (locator<AuthenticationService>().isAuthenticated == true) {
      headers['Authorization'] = 'Bearer ${await _getBearerToken()}';
    }

    headers["User-Agent"] = _deviceService.getUserAgent();
    headers['OG-Device-Id'] = await _deviceService.getDeviceId();
    headers['Session-Id'] = _deviceService.getRiskifiedSessionId();
    headers['App-Version'] = (await PackageInfo.fromPlatform()).version;
    headers['OG-User'] = await _getUserInfo();

    return headers;
  }

  Future<bool> logOut() async {
    var url = Uri.parse("${_appConfigService.config!.baseApiUrl!}/auth/logout");
    Logger.d("URL $url");
    var requestMessage = Request("POST", url);
    Map<String, String> headerParams = {};
    headerParams['Accept'] = "application/json";
    headerParams["Content-Type"] = "application/json";
    try {
      headerParams["User-Agent"] = _deviceService.getUserAgent()!;
      headerParams['OG-Device-Id'] = await _deviceService.getDeviceId() ?? '';
      headerParams['Session-Id'] = _deviceService.getRiskifiedSessionId()!;
      headerParams['App-Version'] = (await PackageInfo.fromPlatform()).version;

      headerParams['Authorization'] = 'Bearer ${await _getBearerToken()}';
      requestMessage.headers.addAll(headerParams);
      try {
        await Response.fromStream(await client.send(requestMessage));
      } catch (e) {
        Logger.w(e.toString());
      }
    } finally {}
    return true;
  }

  // Refresh Token
  //
  Future<Token?> doRefreshToken() async {
    var refreshToken = await (_tokenService.getRefreshToken());
    var token = await _tokenService.getToken()!;
    if (refreshToken!.isEmpty) {
      throw ApiException(ErrorResponse());
    }
    var url = Uri.parse("${_appConfigService.config!.baseApiUrl!}/auth/refresh-token");
    Logger.d("URL $url");
    Map<String, dynamic> params = Map();
    params['auth_token'] = token;
    params['refresh_token'] = refreshToken;

    var requestMessage = Request("POST", url);
    requestMessage.body = serialize(params);
    Map<String, String> headerParams = {};
    headerParams['Accept'] = "application/json";
    headerParams["Content-Type"] = "application/json";

    try {
      headerParams["User-Agent"] = _deviceService.getUserAgent()!;
      headerParams['OG-Device-Id'] = await _deviceService.getDeviceId() ?? '';
      headerParams['App-Version'] = (await PackageInfo.fromPlatform()).version;
      headerParams['Authorization'] = 'Bearer $token';
      requestMessage.headers.addAll(headerParams);
      Response? response;

      try {
        response = await Response.fromStream(await client.send(requestMessage));
      } catch (e) {
        var error = ApiException(handleConnectionError());
        if (error != null && error.error != null) {
          if (error.error.getSingleMessage() != null) {
            locator<DialogService>().showDialog(description: error.error.getSingleMessage());
          }
        }
      }

      if (response != null) {
        if (response.statusCode == 200) {
          var tokenResponse = Token.fromJson(json.decode(response.body));
          await _tokenService.setTokens(tokenResponse.authToken, tokenResponse.refreshToken);
          return tokenResponse;
        } else {
          var error = await handleApiError(response, true);

          if (error != null) {
            if (error.getSingleMessage() != null) {
              locator<DialogService>().showDialog(description: error.getSingleMessage());
            }
          }
        }
      }
    } finally {}
    return null;
  }

  // [Returns]
  // Process and Return Response data according to the Response Status Code
  Future<HTTP.Response?> _handleResponse(HTTP.Response? response) async {
    if (response == null) {
      return null;
    }

    Logger.d(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.headers['ap-s'] != null) {
        _preferenceService.setCartId(response.headers['ap-s']);
      }
      Logger.d("response printing from hagle responce $response");
      return response;
    } else if (response.statusCode == 401) {
      locator<ToastService>().showText(text: "Your session has expired. Please login again");
      Logger.e("Response Status Code: 401", s: StackTrace.current);
      _preferenceService.clearData();
      locator<AuthenticationService>().logout("");
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      var error = await handleApiError(response, false);
      throw ErrorResponseException(error: error);
    } else if (response.statusCode >= 500) {
      Logger.e("response printing from hagle responce $response   500", s: StackTrace.current);
    }

    return null;
  }

  // Basic Authentication Header
  Future<String> _getBearerToken() async {
    var accessToken = _tokenService.getToken();
    if (_tokenService.tokenNeedsRefresh()) {
      var tokenResponse = await doRefreshToken();
      accessToken = tokenResponse!.authToken;
    }
    return accessToken ?? '';
  }

  Future<String> _getUserInfo() async {
    if (_user != null) {
      return "${_user!.userId}-${_user!.email}";
    }
    return "None";
  }
}
