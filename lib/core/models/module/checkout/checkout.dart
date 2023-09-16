
import 'package:bullion/core/models/module/cart/display_message.dart';
import 'package:bullion/core/models/module/cart/order_total_summary.dart';
import 'package:bullion/core/models/module/checkout/selected_bullion_card_reward.dart';
import 'package:bullion/core/models/module/checkout/selected_payment_method.dart';
import 'package:bullion/core/models/module/checkout/shipping_address.dart';
import 'package:bullion/core/models/module/checkout/shipping_option.dart';

class Checkout {
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
    displayMessage = json['display_message'] != null
        ? new DisplayMessage.fromJson(
        json['display_message'])
        : null;
    isPriceExpired = json['is_price_expired'];
    priceTimeStamp = json['price_time_stamp'];
    timerDuration = json['timer_duration'];
    selectedShippingAddress = json['selected_shipping_address'] != null
        ? new ShippingAddress.fromJson(
        json['selected_shipping_address'])
        : null;
    if (json['warnings'] != null) {
      warnings = json['warnings'].cast<String>();
    }
    selectedPaymentMethod = json['selected_payment_method'] != null
        ? new SelectedPaymentMethod.fromJson(json['selected_payment_method'])
        : null;
    selectedBullionCardReward = json['selected_bullion_card_rewards'] != null
        ? new SelectedBullionCardReward.fromJson(json['selected_bullion_card_rewards'])
        : null;
    print( json['selected_bullion_card_rewards'] );

    selectedShippingOption = json['selected_shipping_option'] != null
        ? new SelectedShippingOption.fromJson(json['selected_shipping_option'])
        : null;
    quickShipEligible = json['quick_ship_eligible'];
    totalItems = json['total_items'];
    isEstimate = json['is_estimate'];
    redirect = json['redirect'];
    redirectUrl = json['redirect_to'];
    orderTotal = json['order_total'];
    formattedOrderTotal = json['formatted_order_total'] == null ? '' : json['formatted_order_total'];
    if (json['order_total_summary'] != null) {
      orderTotalSummary = <OrderTotalSummary>[];
      json['order_total_summary'].forEach((v) {
        orderTotalSummary!.add(new OrderTotalSummary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.displayMessage != null) {
      data['display_message'] = this.displayMessage!.toJson();
    }
    data['is_price_expired'] = this.isPriceExpired;
    data['price_time_stamp'] = this.priceTimeStamp;
    data['timer_duration'] = this.timerDuration;
    if (this.selectedShippingAddress != null) {
      data['selected_shipping_address'] = this.selectedShippingAddress!.toJson();
    }
    if (this.selectedPaymentMethod != null) {
      data['selected_payment_method'] = this.selectedPaymentMethod!.toJson();
    }
    if (this.selectedBullionCardReward != null) {

      data['selected_bullion_card_rewards'] = this.selectedBullionCardReward!.toJson();
    }
    if (this.warnings != null) {
      data['warnings'] = this.warnings.toString();
    }
    if (this.selectedShippingOption != null) {
      data['selected_shipping_option'] = this.selectedShippingOption!.toJson();
    }
    data['quick_ship_eligible'] = this.quickShipEligible;
    data['total_items'] = this.totalItems;
    data['is_estimate'] = this.isEstimate;
    data['order_total'] = this.orderTotal;
    data['redirect_to'] = this.redirectUrl;
    data['redirect'] = this.redirect;
    data['formatted_order_total'] = this.formattedOrderTotal;
    if (this.orderTotalSummary != null) {
      data['order_total_summary'] =
          this.orderTotalSummary!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}