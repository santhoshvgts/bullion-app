
import 'package:bullion/services/shared/api_model/request_settings.dart';
import 'package:bullion/services/shared/request_method.dart';

class AccountRequest  {

  static RequestSettings getProfile()  {
    return RequestSettings( "/account/get-profile", RequestMethod.GET, params: null, authenticated: true);
  }

  static RequestSettings saveProfile(String? salutation, String name, String lname, String phone, String alternativePhone, String companyName) {
    Map<String, String?> params = {};
    params['salutation'] = salutation;
    params['first_name'] = name;
    params['last_name'] = lname;
    params['phone_number'] = phone;
    params['alternate_phone_number'] = alternativePhone;
    params['company_name'] = companyName;

    return RequestSettings( "/account/save-profile", RequestMethod.POST, params: params, authenticated: true);
  }

  static RequestSettings changeEmail(String oldEmail, String newEmail, String confirmEmail) {

    Map<String, String> params = {};
    params['old_email'] = oldEmail;
    params['new_email'] = newEmail;
    params['confirm_email'] = confirmEmail;

    return RequestSettings( "/auth/change-email", RequestMethod.POST, params: params, authenticated: true);
  }

  static RequestSettings changePassword(String oldPassword, String newPassword, String confirmPassword) {

    Map<String, String> params = {};
    params['old_password'] = oldPassword;
    params['new_password'] = newPassword;
    params['confirm_new_password'] = confirmPassword;
    return RequestSettings( "/auth/change-password", RequestMethod.POST, params: params, authenticated: true);
  }

}