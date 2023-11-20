import 'package:bullion/services/api/endpoints.dart';

import '../shared/api_model/request_settings.dart';
import '../shared/request_method.dart';

class AlertsRequest {

  static RequestSettings getOperators() {
    return RequestSettings(Endpoints.getMarketAlertOperators, RequestMethod.GET,
        params: null, authenticated: true);
  }

  static RequestSettings getMarketAlerts() {
    return RequestSettings(Endpoints.getMarketAlerts, RequestMethod.GET,
        params: null, authenticated: true);
  }

  static RequestSettings postMarketAlert(double price, int operatorId, int metal) {
    Map<String, dynamic> params = {};
    params['operator_id'] = operatorId;
    params['metal'] = metal;
    params['price'] = price;

    return RequestSettings(Endpoints.addMarketAlert, RequestMethod.POST,
        params: params, authenticated: true);
  }

}
