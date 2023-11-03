import '../shared/api_model/request_settings.dart';
import '../shared/request_method.dart';

class AddressRequest {

  static RequestSettings getAddress() {
    return RequestSettings("/address/get", RequestMethod.GET,
        params: null, authenticated: true);
  }
}
