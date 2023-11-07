import '../shared/api_model/request_settings.dart';
import '../shared/request_method.dart';

class AddressRequest {
  static RequestSettings getAddress() {
    return RequestSettings("/address/get", RequestMethod.GET,
        params: null, authenticated: true);
  }

  static RequestSettings deleteAddress(int addressId) {
    return RequestSettings(
        "/address/remove?addressId=$addressId", RequestMethod.POST,
        params: null, authenticated: true);
  }

  static RequestSettings addAddress(Map<String, dynamic> json) {
    return RequestSettings("/address/save", RequestMethod.POST,
        params: json, authenticated: true);
  }
}
