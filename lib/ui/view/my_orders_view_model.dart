import 'package:bullion/core/enums/order_status.dart';
import 'package:bullion/core/models/module/order.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';

class MyOrdersViewModel extends VGTSBaseViewModel {
  List<Order>? ordersList;
  List<Order>? _filteredList;
  OrderStatus? orderStatus;
  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  MyOrdersViewModel(this.ordersList, this.orderStatus) {
    handleOrderStatus(orderStatus);
  }

  void handleOrderStatus(OrderStatus? status) {
    switch (status) {
      case OrderStatus.ALL:
        _filteredList = ordersList;
        break;

      case OrderStatus.INPROGRESS:
        _filteredList = ordersListBasedOnStatus("Processing Payment");
        break;

      case OrderStatus.SHIPPED:
        _filteredList = ordersListBasedOnStatus("Order Processing");
        break;

      case OrderStatus.CANCELLED:
        _filteredList = ordersListBasedOnStatus("Awaiting Payment");
        break;

      case null:
        throw ("Null, No data");
    }
  }

  List<Order> ordersListBasedOnStatus(String status) {
    List<Order> filteredList = [];
    ordersList?.forEach((element) {
      if (element.orderSummary?[2].value == status) {
        filteredList.add(element);
      }
    });
    return filteredList;
  }

  String? getDayCode(String? text) {

    for (var day in days) {
      final regexp = RegExp(day, caseSensitive: false);
      text = text?.replaceAll(regexp, day.substring(0, 3));
    }

    return text;
  }

  List<Order>? get filteredList => _filteredList;
}