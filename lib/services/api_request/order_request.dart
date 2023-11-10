import 'package:bullion/services/api/endpoints.dart';

import '../shared/api_model/request_settings.dart';
import '../shared/request_method.dart';

class OrderRequest {
  static RequestSettings getAllOrders(int pageNum) {
    Map<String, dynamic> params = {};
    params['pageNumber'] = pageNum;

    return RequestSettings(Endpoints.getAllOrders, RequestMethod.GET,
        params: params, authenticated: true);
  }

  static RequestSettings getOrderDetails(String orderID) {
    return RequestSettings(Endpoints.getOrderDetails.replaceAll('<orderId>', orderID), RequestMethod.GET,
        params: null, authenticated: true);
  }
}
