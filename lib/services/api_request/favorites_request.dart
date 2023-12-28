import '../api/endpoints.dart';
import '../shared/api_model/request_settings.dart';
import '../shared/request_method.dart';

class FavoritesRequest {
  static RequestSettings getFavorites() {
    return RequestSettings(Endpoints.getFavorites, RequestMethod.GET,
        params: null, authenticated: true);
  }
}