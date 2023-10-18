import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';

import '../../core/models/module/order.dart';
import '../../../services/api_request/order_request.dart';

class OrderDetailsViewModel extends VGTSBaseViewModel {
  Order? _orderDetail;
  bool _isExpanded = false;

  bool get isExpanded => _isExpanded;

  set isExpanded(bool value) {
    _isExpanded = value;
    notifyListeners();
  }

  init(String orderID) {
    getOrderDetails(orderID);
  }

  getOrderDetails(String orderID) async {
    setBusy(true);

    _orderDetail = await request<Order>(OrderRequest.getOrderDetails(orderID));
    debugPrint("Order detail........$_orderDetail");

    setBusy(false);
  }

  Order? get orderDetail => _orderDetail;
}
