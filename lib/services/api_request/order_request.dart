import '../shared/api_model/request_settings.dart';
import '../shared/request_method.dart';

class OrderRequest {
  static RequestSettings getAllOrders(int pageNum) {
    Map<String, dynamic> params = {};
    params['pageNumber'] = pageNum;

    return RequestSettings("/order/get-all", RequestMethod.GET,
        params: params, authenticated: true);
  }

  static RequestSettings getOrderDetails(String orderID) {
    return RequestSettings("/order/get/$orderID", RequestMethod.GET,
        params: null, authenticated: true);
  }
}
