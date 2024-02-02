import 'package:bullion/core/models/alert/product_alert_response_model.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/models/alert/alert_add_response_model.dart';
import '../../../../services/api_request/alerts_request.dart';

class AlertsViewModel extends VGTSBaseViewModel {
  late ScrollController _scrollController;

  Map<int, String> metalNames = {
    1: 'Gold',
    2: 'Silver',
    3: 'Platinum',
    4: 'Palladium',
  };

  AlertsViewModel() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    init();
  }

  AlertGetResponse? _alertResponse;
  List<ProductDetails>? _productAlerts;
  List<ProductDetails>? _alertMeAlerts;

  _onScroll() {
    notifyListeners();
  }

  void init() async {
    setBusy(true);

    Future<AlertGetResponse?> alertResponseFuture = request<AlertGetResponse>(AlertsRequest.getMarketAlerts());

    Future<List<ProductDetails>?> productAlertsFuture = requestList<ProductDetails>(AlertsRequest.getProductPriceAlerts());

    Future<List<ProductDetails>?> alertMeAlertsFuture = requestList<ProductDetails>(AlertsRequest.getAlertMeProducts());

    await Future.wait([
      alertResponseFuture,
      productAlertsFuture,
      alertMeAlertsFuture,
    ]);

    _alertResponse = await alertResponseFuture;
    _productAlerts = await productAlertsFuture;
    _alertMeAlerts = await alertMeAlertsFuture;

    setBusy(false);
  }

  String getMetalName(int? metalID) {
    return metalNames[metalID] ?? "";
  }

  ScrollController get scrollController => _scrollController;

  AlertGetResponse? get alertResponse => _alertResponse;

  List<ProductDetails>? get productAlerts => _productAlerts;

  List<ProductDetails>? get alertMeAlerts => _alertMeAlerts;

  refreshProductAlert() async {
    _productAlerts = await requestList<ProductDetails>(AlertsRequest.getProductPriceAlerts());
    notifyListeners();
  }

  refreshAlertMe() async {
    _alertMeAlerts =  await requestList<ProductDetails>(AlertsRequest.getAlertMeProducts());
    notifyListeners();
  }

  void removeSpotPriceAlert(int? id) async {
    setBusy(true);

    await request(AlertsRequest.removeSpotPriceAlert(id));
    _alertResponse = await request<AlertGetResponse>(AlertsRequest.getMarketAlerts());

    setBusy(false);
  }

  void removePriceAlert(int? id) async {
    setBusy(true);

    await request(AlertsRequest.removePriceAlert(id));
    _productAlerts = await requestList<ProductDetails>(
        AlertsRequest.getProductPriceAlerts());

    setBusy(false);
  }

  void removeAlertMe(int? id) async {
    setBusy(true);

    await request(AlertsRequest.removeAlertMe(id));
    _alertMeAlerts = await requestList<ProductDetails>(
        AlertsRequest.getAlertMeProducts());

    setBusy(false);

    refreshAlertMe();
  }

  void editAlertMe(int? productId, int? targetPrice) async {
    setBusy(true);

    await request(AlertsRequest.editPriceAlert(productId, targetPrice));
    _alertMeAlerts = await requestList<ProductDetails>(
        AlertsRequest.getAlertMeProducts());

    setBusy(false);
  }
}
