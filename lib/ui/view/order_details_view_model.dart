import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/models/module/order.dart';
import '../../../services/api_request/order_request.dart';

class OrderDetailsViewModel extends VGTSBaseViewModel {
  Order? _orderDetail;
  bool _isExpanded = false;
  String? _date;

  bool get isExpanded => _isExpanded;

  String? get date => _date;

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

    if (_orderDetail != null) formatDate();
  }

  Order? get orderDetail => _orderDetail;

  void formatDate() {
    var inputFormat = DateFormat('M/d/y h:m:s a');
    DateTime dateTime = inputFormat.parse(_orderDetail!.formattedPostedDate!);
    _date = DateFormat.yMMMd().format(dateTime);
  }
}
