
import 'package:bullion/services/shared/api_model/request_settings.dart';
import 'package:bullion/services/shared/request_method.dart';

class PageRequest {

  static RequestSettings fetch({ required String path }) {
    return RequestSettings(path, RequestMethod.GET, params: null, authenticated: true);
  }

  static RequestSettings getRoute({ String? url }) {
    return RequestSettings("/pages/get-route?url=$url", RequestMethod.GET, params: null, authenticated: true);
  }

  static RequestSettings filterProduct({ required String path }) {
    return RequestSettings(path, RequestMethod.GET, params: null, authenticated: true);
  }

  static RequestSettings paginate({ required String path }) {
    return RequestSettings(path, RequestMethod.GET, params: null, authenticated: true);
  }

}