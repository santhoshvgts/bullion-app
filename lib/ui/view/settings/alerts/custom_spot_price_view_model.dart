import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/models/alert_add_response_model.dart';
import '../../../../services/api_request/alerts_request.dart';

class AlertsViewModel extends VGTSBaseViewModel {
  late ScrollController _scrollController;

  AlertsViewModel() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    init();
  }

  AlertGetResponse? _alertResponse;

  _onScroll() {
    notifyListeners();
  }

  void init() async {
    setBusy(true);

    _alertResponse =
        await request<AlertGetResponse>(AlertsRequest.getMarketAlerts());

    setBusy(false);
  }

  ScrollController get scrollController => _scrollController;

  AlertGetResponse? get alertResponse => _alertResponse;
}
