import 'package:bullion/core/models/alert/product_alert_response_model.dart';
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
  List<ProductAlert>? _productAlert;
  List<ProductAlert>? _alertMeAlerts;

  _onScroll() {
    notifyListeners();
  }

  void init() async {
    setBusy(true);

    _alertResponse =
        await request<AlertGetResponse>(AlertsRequest.getMarketAlerts());
    _productAlert =
        await requestList<ProductAlert>(AlertsRequest.getProductPriceAlerts());
    _alertMeAlerts = await requestList<ProductAlert>(
        AlertsRequest.getAlertMeProductAlerts());

    setBusy(false);
  }

  String getMetalName(int? metalID) {
    return metalNames[metalID] ?? "";
  }

  ScrollController get scrollController => _scrollController;

  AlertGetResponse? get alertResponse => _alertResponse;

  List<ProductAlert>? get productAlert => _productAlert;

  List<ProductAlert>? get alertMeAlerts => _alertMeAlerts;

  void removeAlert(int? id) async {
    setBusy(true);

    await requestList(AlertsRequest.removeAlert(id));

    setBusy(false);
  }
}
