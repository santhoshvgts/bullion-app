import 'package:bullion/core/models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:bullion/core/models/module/cart/cart_item.dart';
import 'package:bullion/core/models/module/cart/order_total_summary.dart';
import 'package:bullion/core/models/module/checkout/payment_method.dart';
import 'package:bullion/core/models/module/checkout/shipping_address.dart';
import 'package:bullion/core/models/module/order/simple_image_cta.dart';
import 'package:bullion/core/models/module/tracking_info_module.dart';
import 'package:bullion/core/res/colors.dart';

class Order extends BaseModel {
  String? orderId;
  String? currency;
  String? orderStatus;

  bool? hasShipmentInfo;
  bool? requestRating;

  String? formattedPostedDate;

  ShippingAddress? shippingAddress;
  PaymentMethod? paymentMethod;
  bool? quickShipEligible;
  int? totalItems;
  num? orderTotal;
  String? formattedOrderTotal;
  String? shippingDate;
  String? formattedShippingDate;
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
  num? predictiveMargin;
  num? shippingAmount;
  num? tax;
  String? primaryImage;
  int? itemsCount;
  String? subTitle;
  String? title;
  String? colorCode;
  int? step;
  bool? actionRequired;
  String? lifeCycleSegment;
  int? customerScore;

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
      this.actionRequired,
        this.lifeCycleSegment,
        this.customerScore});

  Order fromJson(json) => Order.fromJson(json);

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    currency = json['currency'];
    orderStatus = json['order_status'];
    formattedPostedDate = json['formatted_posted_date'];
    shippingDate = json['shipping_date'];
    formattedShippingDate = json['formatted_shipping_date'];
    shippingAddress = json['shipping_address'] != null
        ? ShippingAddress.fromJson(json['shipping_address'])
        : null;
    paymentMethod = json['payment_method'] != null
        ? PaymentMethod.fromJson(json['payment_method'])
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
        orderTotalSummary!.add(OrderTotalSummary.fromJson(v));
      });
    }
    if (json['order_summary'] != null) {
      orderSummary = <OrderTotalSummary>[];
      json['order_summary'].forEach((v) {
        orderSummary!.add(OrderTotalSummary.fromJson(v));
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
        orderLineItems!.add(CartItem.fromJson(v));
      });
    }

    if (json['simple_image_ctas'] != null) {
      simpleImageCTAs = <SimpleImageCTA>[];
      json['simple_image_ctas'].forEach((v) {
        simpleImageCTAs!.add(SimpleImageCTA.fromJson(v));
      });
    }

    if (json['shipment_tracking'] != null) {
      shipmentTracking = <TrackingInfo>[];
      json['shipment_tracking'].forEach((v) {
        shipmentTracking!.add(TrackingInfo.fromJson(v));
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
    lifeCycleSegment = json['life_cycle_segment'];
    customerScore = json['customer_score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['order_id'] = orderId;
    data['currency'] = currency;
    data['order_status'] = orderStatus;
    data['formatted_posted_date'] = formattedPostedDate;
    data['formatted_shipping_date'] = formattedShippingDate;
    data['shipping_date'] = shippingDate;
    if (shippingAddress != null) {
      data['shipping_address'] = shippingAddress!.toJson();
    }
    if (paymentMethod != null) {
      data['payment_method'] = paymentMethod!.toJson();
    }
    data['quick_ship_eligible'] = quickShipEligible;
    data['total_items'] = totalItems;
    data['order_total'] = orderTotal;
    data['request_rating'] = requestRating;
    data['formatted_order_total'] = formattedOrderTotal;
    data['has_taxable_items'] = hasTaxableItems;
    data['formatted_taxable_sub_total'] = formattedTaxableSubTotal;
    data['formatted_taxable_items_tax'] = formattedTaxableItemsTax;
    data['formatted_non_taxable_sub_total'] = formattedNonTaxableSubTotal;
    if (orderTotalSummary != null) {
      data['order_total_summary'] =
          orderTotalSummary!.map((v) => v.toJson()).toList();
    }
    if (orderSummary != null) {
      data['order_summary'] =
          orderSummary!.map((v) => v.toJson()).toList();
    }
    data['show_payment_acknowledge'] = showPaymentAcknowledge;
    data['has_shipment_info'] = hasShipmentInfo;
    if (paymentInstructions != null) {
      data['payment_instructions'] = paymentInstructions!.toList();
    }
    if (warnings != null) {
      data['warnings'] = warnings!.toList();
    }
    if (orderLineItems != null) {
      data['order_line_items'] =
          orderLineItems!.map((v) => v.toJson()).toList();
    }

    if (simpleImageCTAs != null) {
      data['simple_image_ctas'] =
          simpleImageCTAs!.map((v) => v.toJson()).toList();
    }

    if (shipmentTracking != null) {
      data['shipment_tracking'] =
          shipmentTracking!.map((v) => v.toJson()).toList();
    }
    data['coupon'] = coupon;
    data['customer_type'] = customerType;
    data['predictive_margin'] = predictiveMargin;
    data['shippingAmount'] = shippingAmount;
    data['tax'] = tax;
    data['primary_image'] = primaryImage;
    data['items_count'] = itemsCount;
    data['sub_title'] = subTitle;
    data['title'] = title;
    data['color_code'] = colorCode;
    data['step'] = step;
    data['action_required'] = actionRequired;
    data['life_cycle_segment'] = this.lifeCycleSegment;
    data['customer_score'] = this.customerScore;
    return data;
  }

  Color get orderStatusColor {
    if (orderStatus == null) {
      return AppColor.text;
    }

    if (orderStatus!.contains("Success")) {
      return AppColor.green;
    }
    return AppColor.title;
  }
}
