import 'package:bullion/services/shared/api_model/request_settings.dart';
import 'package:bullion/services/shared/request_method.dart';

class ActivityRequest  {

  //get:getAddress()
  static String _recently_viewed = "/recommendation/recently-viewed";

  static String _recently_bought = "/recommendation/recently-bought";

  static String _search_history = "/search/history";

  static RequestSettings getRecentlyViewed({ int pageNo = 1 }) {
    return RequestSettings( "$_recently_viewed?pageNumber=$pageNo", RequestMethod.GET, params: null, authenticated: true);
  }

  static RequestSettings getRecentlyBought({ int pageNo = 1 }) {
    return RequestSettings( "$_recently_bought?pageNumber=$pageNo", RequestMethod.GET, params: null, authenticated: true);
  }

  static RequestSettings getSearchHistory() {
    return RequestSettings(_search_history, RequestMethod.GET, params: null, authenticated: true);
  }

}