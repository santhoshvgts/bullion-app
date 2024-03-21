import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/models/module/order.dart';
import '../../../../services/api_request/order_request.dart';

class OrdersViewModel extends VGTSBaseViewModel {
  List<Order>? _ordersList = [];
  int pageNum = 1;
  bool hasNextPage = true;

  late ScrollController _scrollController;

  List<Order>? get ordersList => _ordersList;

  ScrollController get scrollController => _scrollController;

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
  }

  Map<String, String> tabs =  {
    'all': "All Order",
    'in-progress' : "In Progress",
    'shipped' : "Shipped Orders",
    'cancelled' : "Cancelled Orders",
  };

  @override
  Future onInit() async {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    setBusy(true);
    await fetchOrders();
    setBusy(false);

    super.onInit();
  }

  onTabSelected(int index) async {
    _selectedIndex = index;
    setBusy(true);
    pageNum = 1;
    hasNextPage = true;
    await fetchOrders();
    setBusy(false);
  }

  _onScroll() async {
    if (scrollController.position.pixels > (scrollController.position.maxScrollExtent - 50) || busy(ordersList)) {
      return null;
    }

    setBusyForObject(ordersList, true);
    await fetchOrders();
    setBusyForObject(ordersList, false);
  }

  fetchOrders() async {
    if (!hasNextPage) {
      return;
    }

    List<Order> orders = (await requestList<Order>(OrderRequest.getAllOrders(pageNum, tabs.keys.toList()[_selectedIndex]))) ?? [];
    hasNextPage = orders.isNotEmpty;

    if (pageNum == 1) {
      _ordersList = orders;
    } else {
      _ordersList?.addAll(orders);
    }
    pageNum++;
    notifyListeners();
  }

}