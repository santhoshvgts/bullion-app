import 'package:bullion/services/shared/api_model/request_settings.dart';
import 'package:bullion/services/shared/request_method.dart';

class AuthRequest {

  static RequestSettings login(String emailId, String password) {
    Map<String, dynamic> params = {};
    params['email'] = emailId;
    params['password'] = password;

    return RequestSettings("/auth/login", RequestMethod.POST, params: params, authenticated: false);
  }

  static RequestSettings register(String firstName, String lastName, String email, String password) {
    Map<String, dynamic> params = {};
    params['first_name'] = firstName;
    params['last_name'] = lastName;
    params['email'] = email;
    params['password'] = password;

    return RequestSettings("/auth/register", RequestMethod.POST, params: params, authenticated: false);
  }

  static RequestSettings forgotPassword(String emailId) {
    return RequestSettings("/auth/forgot-password?email=$emailId", RequestMethod.POST, params: null, authenticated: false);
  }

  static RequestSettings registerAsGuest(String emailId) {
    return RequestSettings("/auth/register-as-guest?email=$emailId", RequestMethod.POST, params: null, authenticated: false);
  }

  static RequestSettings resetPassword(String? key, String? email, String newPassword, String confirmPassword) {
    Map<String, String?> params = {};
    params['key'] = key;
    params['email'] = email;
    params['new_password'] = newPassword;
    params['confirm_new_password'] = confirmPassword;

    return RequestSettings("/auth/reset-password", RequestMethod.POST, params: params, authenticated: false);
  }

  static RequestSettings getResetPasswordVerification(String key) {
    return RequestSettings("/auth/reset-password?key=${key}", RequestMethod.GET, params: null, authenticated: true);
  }

  static RequestSettings guestToAccount(String password, bool emailOptIn) {
    return RequestSettings("/auth/guest-to-account?password=$password&emailOptIn=$emailOptIn", RequestMethod.GET, params: null, authenticated: true);
  }

  static RequestSettings getUserInfo() {
    return RequestSettings("/auth/get-user", RequestMethod.GET, params: null, authenticated: true);
  }

}