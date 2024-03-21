// ignore_for_file: must_be_immutable

import 'package:bullion/core/models/base_model.dart';
import 'package:bullion/core/models/module/cart/display_message.dart';
import 'package:bullion/core/models/module/cart/order_total_summary.dart';
import 'package:bullion/core/models/module/checkout/selected_bullion_card_reward.dart';
import 'package:bullion/core/models/module/checkout/selected_payment_method.dart';
import 'package:bullion/core/models/module/checkout/shipping_address.dart';
import 'package:bullion/core/models/module/checkout/shipping_option.dart';

class Checkout extends BaseModel {
  DisplayMessage? displayMessage;
  bool? isPriceExpired;
  String? priceTimeStamp;
  int? timerDuration;
  ShippingAddress? selectedShippingAddress;
  SelectedPaymentMethod? selectedPaymentMethod;
  SelectedShippingOption? selectedShippingOption;
  SelectedBullionCardReward? selectedBullionCardReward;
  bool? quickShipEligible;
  int? totalItems;
  bool? isEstimate;
  bool? redirect;
  String? redirectUrl;
  double? orderTotal;
  String? formattedOrderTotal;
  List<OrderTotalSummary>? orderTotalSummary;
  List<String>? warnings;

  Checkout(
      {this.displayMessage,
      this.isPriceExpired,
      this.priceTimeStamp,
      this.timerDuration,
      this.selectedShippingAddress,
      this.selectedPaymentMethod,
      this.selectedShippingOption,
      this.quickShipEligible,
      this.totalItems,
      this.isEstimate,
      this.orderTotal,
      this.formattedOrderTotal,
      this.orderTotalSummary});

  Checkout.fromJson(Map<String, dynamic> json) {
    displayMessage = json['display_message'] != null ? DisplayMessage.fromJson(json['display_message']) : null;
    isPriceExpired = json['is_price_expired'];
    priceTimeStamp = json['price_time_stamp'];
    timerDuration = json['timer_duration'];
    selectedShippingAddress = json['selected_shipping_address'] != null ? ShippingAddress.fromJson(json['selected_shipping_address']) : null;
    if (json['warnings'] != null) {
      warnings = json['warnings'].cast<String>();
    }
    selectedPaymentMethod = json['selected_payment_method'] != null ? SelectedPaymentMethod.fromJson(json['selected_payment_method']) : null;
    selectedBullionCardReward = json['selected_bullion_card_rewards'] != null ? SelectedBullionCardReward.fromJson(json['selected_bullion_card_rewards']) : null;

    selectedShippingOption = json['selected_shipping_option'] != null ? SelectedShippingOption.fromJson(json['selected_shipping_option']) : null;
    quickShipEligible = json['quick_ship_eligible'];
    totalItems = json['total_items'];
    isEstimate = json['is_estimate'];
    redirect = json['redirect'];
    redirectUrl = json['redirect_to'];
    orderTotal = double.tryParse(json['order_total'].toString());
    formattedOrderTotal = json['formatted_order_total'] ?? '';
    if (json['order_total_summary'] != null) {
      orderTotalSummary = <OrderTotalSummary>[];
      json['order_total_summary'].forEach((v) {
        orderTotalSummary!.add(OrderTotalSummary.fromJson(v));
      });
    }
  }

  @override
  Checkout fromJson(json) => Checkout.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (displayMessage != null) {
      data['display_message'] = displayMessage!.toJson();
    }
    data['is_price_expired'] = isPriceExpired;
    data['price_time_stamp'] = priceTimeStamp;
    data['timer_duration'] = timerDuration;
    if (selectedShippingAddress != null) {
      data['selected_shipping_address'] = selectedShippingAddress!.toJson();
    }
    if (selectedPaymentMethod != null) {
      data['selected_payment_method'] = selectedPaymentMethod!.toJson();
    }
    if (selectedBullionCardReward != null) {
      data['selected_bullion_card_rewards'] = selectedBullionCardReward!.toJson();
    }
    if (warnings != null) {
      data['warnings'] = warnings.toString();
    }
    if (selectedShippingOption != null) {
      data['selected_shipping_option'] = selectedShippingOption!.toJson();
    }
    data['quick_ship_eligible'] = quickShipEligible;
    data['total_items'] = totalItems;
    data['is_estimate'] = isEstimate;
    data['order_total'] = orderTotal;
    data['redirect_to'] = redirectUrl;
    data['redirect'] = redirect;
    data['formatted_order_total'] = formattedOrderTotal;
    if (orderTotalSummary != null) {
      data['order_total_summary'] = orderTotalSummary!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
