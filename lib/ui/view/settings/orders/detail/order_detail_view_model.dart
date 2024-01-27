import 'package:bullion/core/models/module/cart/cart_item.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/models/module/order.dart';
import '../../../../../../services/api_request/order_request.dart';

class OrderDetailViewModel extends VGTSBaseViewModel {

  late String orderId;
  late bool fromSuccess;

  Order? _orderDetail;

  Order? get orderDetail => _orderDetail;


  List<CartItem> get taxCartItems => orderDetail?.orderLineItems?.where((element) => element.isTaxable!).toList() ?? [];

  List<CartItem> get nonTaxCartItems => orderDetail?.orderLineItems?.where((element) => !element.isTaxable!).toList() ?? [];



  OrderDetailViewModel(Map data) {
    orderId = data['order_id'];
    fromSuccess = data ['from_success'];

    getOrderDetails(orderId);
  }

  getOrderDetails(String orderId) async {
    setBusy(true);

    _orderDetail = await request<Order>(OrderRequest.getOrderDetails(orderId));
    debugPrint("Order detail........$_orderDetail");

    setBusy(false);
  }

}