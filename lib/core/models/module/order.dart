import 'package:flutter/material.dart';
import 'package:bullion/core/models/module/cart/cart_item.dart';
import 'package:bullion/core/models/module/cart/order_total_summary.dart';
import 'package:bullion/core/models/module/checkout/payment_method.dart';
import 'package:bullion/core/models/module/checkout/shipping_address.dart';
import 'package:bullion/core/models/module/order/simple_image_cta.dart';
import 'package:bullion/core/models/module/tracking_info_module.dart';
import 'package:bullion/core/res/colors.dart';

class Order {
  String? orderId;
  String? currency;
  String? orderStatus;

  bool? hasShipmentInfo;
  bool? requestRating;

  Color get orderStatusColor {
    if (orderStatus == null) {
      return AppColor.text;
    }

    if (orderStatus!.contains("Success")) {
      return AppColor.green;
    }
    return AppColor.title;
  }

  String? formattedPostedDate;

  ShippingAddress? shippingAddress;
  PaymentMethod? paymentMethod;
  bool? quickShipEligible;
  int? totalItems;
  double? orderTotal;
  String? formattedOrderTotal;
  bool? hasTaxableItems;
  String? formattedTaxableSubTotal;
  String? formattedTaxableItemsTax;
  String? formattedNonTaxableSubTotal;
  List<OrderTotalSummary>? orderTotalSummary;
  List<OrderTotalSummary>? orderSummary;
  bool? showPaymentAcknowledge;
  List<String>? paymentInstructions;
  List<String>? warnings;
  List<CartItem>? orderLineItems;
  List<SimpleImageCTA>? simpleImageCTAs;
  List<TrackingInfo>? shipmentTracking;
  String? coupon;
  String? customerType;
  double? predictiveMargin;
  double? shippingAmount;
  double? tax;
  String? primaryImage;
  int? itemsCount;
  String? subTitle;
  String? title;
  String? colorCode;
  int? step;
  bool? actionRequired;

  Order(
      {this.orderId,
      this.currency,
      this.orderStatus,
      this.formattedPostedDate,
      this.shippingAddress,
      this.paymentMethod,
      this.quickShipEligible,
      this.totalItems,
      this.orderTotal,
      this.formattedOrderTotal,
      this.hasTaxableItems,
      this.formattedTaxableSubTotal,
      this.formattedTaxableItemsTax,
      this.formattedNonTaxableSubTotal,
      this.orderTotalSummary,
      this.showPaymentAcknowledge,
      this.paymentInstructions,
      this.warnings,
      this.orderLineItems,
      this.shipmentTracking,
      this.coupon,
      this.customerType,
      this.predictiveMargin,
      this.shippingAmount,
      this.tax,
        this.primaryImage,
        this.itemsCount,
        this.subTitle,
        this.title,
        this.colorCode,
        this.step,
        this.actionRequired});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'].toString();
    currency = json['currency'];
    orderStatus = json['order_status'];
    formattedPostedDate = json['formatted_posted_date'];
    shippingAddress = json['shipping_address'] != null
        ? new ShippingAddress.fromJson(json['shipping_address'])
        : null;
    paymentMethod = json['payment_method'] != null
        ? new PaymentMethod.fromJson(json['payment_method'])
        : null;
    quickShipEligible = json['quick_ship_eligible'];
    totalItems = json['total_items'];
    orderTotal = json['order_total'];
    formattedOrderTotal = json['formatted_order_total'];
    requestRating = json['request_rating'];
    hasTaxableItems = json['has_taxable_items'];
    formattedTaxableSubTotal = json['formatted_taxable_sub_total'];
    formattedTaxableItemsTax = json['formatted_taxable_items_tax'];
    formattedNonTaxableSubTotal = json['formatted_non_taxable_sub_total'];
    if (json['order_total_summary'] != null) {
      orderTotalSummary = <OrderTotalSummary>[];
      json['order_total_summary'].forEach((v) {
        orderTotalSummary!.add(new OrderTotalSummary.fromJson(v));
      });
    }
    if (json['order_summary'] != null) {
      orderSummary = <OrderTotalSummary>[];
      json['order_summary'].forEach((v) {
        orderSummary!.add(new OrderTotalSummary.fromJson(v));
      });
    }
    showPaymentAcknowledge = json['show_payment_acknowledge'];
    hasShipmentInfo = json['has_shipment_info'];
    if (json['payment_instructions'] != null) {
      paymentInstructions = <String>[];
      json['payment_instructions'].forEach((v) {
        paymentInstructions!.add(v);
      });
    }
    if (json['warnings'] != null) {
      warnings = <String>[];
      json['warnings'].forEach((v) {
        warnings!.add(v);
      });
    }
    if (json['order_line_items'] != null) {
      orderLineItems = <CartItem>[];
      json['order_line_items'].forEach((v) {
        orderLineItems!.add(new CartItem.fromJson(v));
      });
    }

    if (json['simple_image_ctas'] != null) {
      simpleImageCTAs = <SimpleImageCTA>[];
      json['simple_image_ctas'].forEach((v) {
        simpleImageCTAs!.add(new SimpleImageCTA.fromJson(v));
      });
    }

    if (json['shipment_tracking'] != null) {
      shipmentTracking = <TrackingInfo>[];
      json['shipment_tracking'].forEach((v) {
        shipmentTracking!.add(new TrackingInfo.fromJson(v));
      });
    }
    // shipmentTracking = json[''];
    coupon = json['coupon'];
    customerType = json['customer_type'];
    predictiveMargin = json['predictive_margin'];
    shippingAmount = json['shipping_amount'];
    tax = json['tax'];
    primaryImage = json['primary_image'];
    itemsCount = json['items_count'];
    subTitle = json['sub_title'];
    title = json['title'];
    colorCode = json['color_code'];
    step = json['step'];
    actionRequired = json['action_required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['currency'] = this.currency;
    data['order_status'] = this.orderStatus;
    data['formatted_posted_date'] = this.formattedPostedDate;
    if (this.shippingAddress != null) {
      data['shipping_address'] = this.shippingAddress!.toJson();
    }
    if (this.paymentMethod != null) {
      data['payment_method'] = this.paymentMethod!.toJson();
    }
    data['quick_ship_eligible'] = this.quickShipEligible;
    data['total_items'] = this.totalItems;
    data['order_total'] = this.orderTotal;
    data['request_rating'] = this.requestRating;
    data['formatted_order_total'] = this.formattedOrderTotal;
    data['has_taxable_items'] = this.hasTaxableItems;
    data['formatted_taxable_sub_total'] = this.formattedTaxableSubTotal;
    data['formatted_taxable_items_tax'] = this.formattedTaxableItemsTax;
    data['formatted_non_taxable_sub_total'] = this.formattedNonTaxableSubTotal;
    if (this.orderTotalSummary != null) {
      data['order_total_summary'] =
          this.orderTotalSummary!.map((v) => v.toJson()).toList();
    }
    if (this.orderSummary != null) {
      data['order_summary'] =
          this.orderTotalSummary!.map((v) => v.toJson()).toList();
    }
    data['show_payment_acknowledge'] = this.showPaymentAcknowledge;
    data['has_shipment_info'] = this.hasShipmentInfo;
    if (this.paymentInstructions != null) {
      data['payment_instructions'] = this.paymentInstructions!.toList();
    }
    if (this.warnings != null) {
      data['warnings'] = this.warnings!.toList();
    }
    if (this.orderLineItems != null) {
      data['order_line_items'] =
          this.orderLineItems!.map((v) => v.toJson()).toList();
    }

    if (this.simpleImageCTAs != null) {
      data['simple_image_ctas'] =
          this.simpleImageCTAs!.map((v) => v.toJson()).toList();
    }

    if (this.shipmentTracking != null) {
      data['shipment_tracking'] =
          this.shipmentTracking!.map((v) => v.toJson()).toList();
    }
    data['coupon'] = coupon;
    data['customer_type'] = customerType;
    data['predictive_margin'] = predictiveMargin;
    data['shippingAmount'] = shippingAmount;
    data['tax'] = tax;
    data['primary_image'] = this.primaryImage;
    data['items_count'] = this.itemsCount;
    data['sub_title'] = this.subTitle;
    data['title'] = this.title;
    data['color_code'] = this.colorCode;
    data['step'] = this.step;
    data['action_required'] = this.actionRequired;
    return data;
  }
}
