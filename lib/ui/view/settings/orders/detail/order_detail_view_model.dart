import 'package:bullion/core/models/module/cart/cart_item.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/view/main/guest_register/guest_register_bottom_sheet.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/models/module/order.dart';
import '../../../../../../services/api_request/order_request.dart';

class OrderDetailViewModel extends VGTSBaseViewModel {

  late String orderId;
  late bool fromSuccess;

  bool isGuestUser = false;

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

    isGuestUser = authenticationService.isGuestUser;
    _orderDetail = await request<Order>(OrderRequest.getOrderDetails(orderId));
    debugPrint("Order detail........$_orderDetail");

    setBusy(false);
  }

  onGuestRegisterClick() async {
    var alertResponse = await locator<DialogService>().showBottomSheet(
        title: "Register As User",
        child: const GuestRegisterBottomSheet()
    );

    if (alertResponse.status == true) {
      if (authenticationService.isAuthenticated) {
        await authenticationService.getUserInfo();
        isGuestUser = authenticationService.isGuestUser;
      }
      notifyListeners();
    }
  }

  Future<void> refreshData() async {

  }

}