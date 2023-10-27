import 'package:bullion/services/shared/api_model/request_settings.dart';
import 'package:bullion/services/shared/request_method.dart';

class CategoryApi {

  static RequestSettings filterProducts(String url) {
    return RequestSettings(url, RequestMethod.GET, params: null, authenticated: false);
  }

}
