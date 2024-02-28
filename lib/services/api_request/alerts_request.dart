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

  static RequestSettings getPriceAlertById(int productId) {
    return RequestSettings("/product-alerts/get-product-price-alert?productId=${productId.toString()}", RequestMethod.GET,
        params: null, authenticated: true);
  }

  static RequestSettings getAlertMeById(int productId) {
    return RequestSettings("/product-alerts/get-product-alert?productId=${productId.toString()}", RequestMethod.GET,
        params: null, authenticated: true);
  }

  static RequestSettings getProductPriceAlerts() {
    return RequestSettings(Endpoints.getProductPriceAlerts, RequestMethod.GET,
        params: null, authenticated: true);
  }

  static RequestSettings getAlertMeProducts() {
    return RequestSettings(Endpoints.getAlertMeProductAlerts, RequestMethod.GET,
        params: null, authenticated: true);
  }

  static RequestSettings createEditMarketAlert(int id, double price, int operatorId, int metal, bool isCreate) {
    Map<String, dynamic> params = {};
    params['id'] = id;
    params['operator_id'] = operatorId;
    params['metal'] = metal;
    params['price'] = price;

    return RequestSettings(
        isCreate ? Endpoints.addMarketAlert : Endpoints.editMarketAlert,
        RequestMethod.POST,
        params: params,
        authenticated: true
    );
  }

  static RequestSettings removeSpotPriceAlert(alertId) {
    return RequestSettings(
        Endpoints.removeSpotPriceAlert.replaceFirst("<alertId>", alertId.toString()),
        RequestMethod.POST,
        params: null,
        authenticated: true);
  }

  static RequestSettings removePriceAlert(productId) {
    return RequestSettings(
        Endpoints.removePriceAlert.replaceFirst("<productId>", productId.toString()), RequestMethod.POST,
        params: null, authenticated: true);
  }

  static RequestSettings removeAlertMe(productId) {
    return RequestSettings(
        Endpoints.removeAlertMe.replaceFirst("<productId>", productId.toString()), RequestMethod.POST,
        params: null, authenticated: true);
  }

  static RequestSettings editPriceAlert(productId, targetPrice) {
    return RequestSettings(
        Endpoints.editPriceAlert
            .replaceFirst("<productId>", productId.toString())
            .replaceFirst("<targetPrice>", targetPrice.toString()),
        RequestMethod.POST,
        params: null,
        authenticated: true);
  }

  static RequestSettings editAlertMe(productId, quantity) {
    return RequestSettings(
        Endpoints.editAlertMe
            .replaceFirst("<productId>", productId.toString())
            .replaceFirst("<quantity>", quantity.toString()),
        RequestMethod.POST,
        params: null,
        authenticated: true);
  }
}
