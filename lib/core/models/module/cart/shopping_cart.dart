import 'package:bullion/core/models/module/cart/cart_item.dart';
import 'package:bullion/core/models/module/cart/order_total_summary.dart';

class ShoppingCart {
  bool? isEditable;
  bool? canAddPromoCode;
  List<CartItem>? items;
  List<String>? warnings;
  List<String>? offers;
  List<String>? errors;
  String? potentialSavings;
  String? expiredCartMessage;
  bool? showPotentialSavings;
  int? totalItems;
  bool? isEstimate;
  double? orderTotal;
  String? formattedOrderTotal;
  List<OrderTotalSummary>? orderTotalSummary;

  bool? hasTaxableItems;
  String? formattedTaxableSubTotal;
  String? formattedTaxableItemsTax;
  String? formattedNonTaxableSubTotal;
  int? id;
  String? currency;

  ShoppingCart(
      {this.isEditable,
      this.canAddPromoCode,
      this.items,
      this.warnings,
      this.offers,
      this.errors,
      this.potentialSavings,
      this.expiredCartMessage,
      this.showPotentialSavings,
      this.totalItems,
      this.isEstimate,
      this.orderTotal,
      this.formattedOrderTotal,
      this.orderTotalSummary,
      this.currency,
      this.id});

  ShoppingCart.fromJson(Map<String, dynamic> json) {
    isEditable = json['is_editable'];
    canAddPromoCode = json['can_add_promo_code'];
    if (json['items'] != null) {
      items = <CartItem>[];
      json['items'].forEach((v) {
        items!.add(new CartItem.fromJson(v));
      });
    }

    if (json['warnings'] != null) {
      warnings = json['warnings'].cast<String>();
    }
    expiredCartMessage = json['expired_cart_message'];

    if (json['offers'] != null) {
      offers = json['offers'].cast<String>();
    }
    if (json['errors'] != null) {
      errors = json['errors'].cast<String>();
    }
    potentialSavings = json['potential_savings'];
    showPotentialSavings = json['show_potential_savings'];
    totalItems = json['total_items'];
    isEstimate = json['is_estimate'];
    orderTotal = double.tryParse(json['order_total'].toString());
    formattedOrderTotal = json['formatted_order_total'];
    if (json['order_total_summary'] != null) {
      orderTotalSummary = <OrderTotalSummary>[];
      json['order_total_summary'].forEach((v) {
        orderTotalSummary!.add(new OrderTotalSummary.fromJson(v));
      });
    }
    hasTaxableItems = json['has_taxable_items'];
    formattedTaxableSubTotal = json['formatted_taxable_sub_total'];
    formattedTaxableItemsTax = json['formatted_taxable_items_tax'];
    formattedNonTaxableSubTotal = json['formatted_non_taxable_sub_total'];
    currency = json['currency'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_editable'] = this.isEditable;
    data['can_add_promo_code'] = this.canAddPromoCode;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.warnings != null) {
      data['warnings'] = this.warnings.toString();
    }
    if (this.offers != null) {
      data['offers'] = this.offers.toString();
    }

    if (this.errors != null) {
      data['errors'] = this.errors.toString();
    }
    data['expired_cart_message'] = this.expiredCartMessage;

    data['potential_savings'] = this.potentialSavings;
    data['show_potential_savings'] = this.showPotentialSavings;
    data['total_items'] = this.totalItems;
    data['is_estimate'] = this.isEstimate;
    data['order_total'] = this.orderTotal;
    data['formatted_order_total'] = this.formattedOrderTotal;
    if (this.orderTotalSummary != null) {
      data['order_total_summary'] =
          this.orderTotalSummary!.map((v) => v.toJson()).toList();
    }
    data['has_taxable_items'] = this.hasTaxableItems;
    data['formatted_taxable_sub_total'] = this.formattedTaxableSubTotal;
    data['formatted_taxable_items_tax'] = this.formattedTaxableItemsTax;
    data['formatted_non_taxable_sub_total'] = this.formattedNonTaxableSubTotal;
    data['currency'] = currency;
    data['id'] = id;
    return data;
  }
}
