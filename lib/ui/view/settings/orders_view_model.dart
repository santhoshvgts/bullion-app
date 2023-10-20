import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';

import '../../../core/models/module/order.dart';
import '../../../services/api_request/order_request.dart';

class OrdersViewModel extends VGTSBaseViewModel {
  List<Order>? _ordersList = [];
  int pageNum = 1;

  OrdersViewModel() {
    init();
  }

  void init() {
    getOrders();
  }

  getOrders() async {
    setBusy(true);

    _ordersList = await requestList<Order>(OrderRequest.getAllOrders(pageNum));
    debugPrint("orders........$_ordersList");

    setBusy(false);
  }

  List<Order>? get ordersList => _ordersList;
}
