import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

class CartItem {
  int? productId;
  String? primaryImageUrl;
  String? productName;
  String? targetUrl;
  double? unitPrice;
  String? formattedUnitPrice;
  double? subTotal;
  String? formattedSubTotal;
  int? quantity;
  List<String>? warnings;
  List<String>? offers;
  bool? isTaxable;
  double? tax;
  String? formattedTax;
  bool? showTax;

  bool loading = false;
  bool enabled = true;

  late NumberFormFieldController qtyController;

  // NumberFormFieldController get qtyController {
  //
  //   qtyController.text = quantity.toString();
  //   qtyController.textEditingController.selection = TextSelection.fromPosition(
  //       TextPosition(offset: quantity.toString().length));
  //   return qtyController;
  // }

  FocusNode qtyFocus = new FocusNode();

  CartItem(
      {this.productId,
      this.primaryImageUrl,
      this.productName,
      this.targetUrl,
      this.unitPrice,
      this.formattedUnitPrice,
      this.subTotal,
      this.formattedSubTotal,
      this.quantity,
      this.warnings,
      this.offers,
      this.isTaxable,
      this.tax,
      this.formattedTax,
      this.showTax});

  CartItem.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    primaryImageUrl = json['primary_image_url'];
    productName = json['product_name'];
    targetUrl = json['target_url'];
    unitPrice = json['unit_price'];
    formattedUnitPrice = json['formatted_unit_price'];
    subTotal = json['sub_total'];
    formattedSubTotal = json['formatted_sub_total'];
    quantity = json['quantity'];

    if (json['warnings'] != null) {
      warnings = json['warnings'].cast<String>();
    }

    if (json['offers'] != null) {
      offers = json['offers'].cast<String>();
    }

    isTaxable = json['is_taxable'];
    tax = double.parse(json['tax'].toString());
    formattedTax = json['formatted_tax'];
    showTax = json['show_tax'];


    qtyController = NumberFormFieldController(ValueKey("txtQty$productId"));
    qtyController.text = quantity.toString();
    // qtyController.textEditingController.selection = TextSelection.fromPosition(
    //     TextPosition(offset: quantity.toString().length));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['primary_image_url'] = this.primaryImageUrl;
    data['product_name'] = this.productName;
    data['target_url'] = this.targetUrl;
    data['unit_price'] = this.unitPrice;
    data['formatted_unit_price'] = this.formattedUnitPrice;
    data['sub_total'] = this.subTotal;
    data['formatted_sub_total'] = this.formattedSubTotal;
    data['quantity'] = this.quantity;

    if (this.warnings != null) {
      data['warnings'] = this.warnings.toString();
    }
    if (this.offers != null) {
      data['offers'] = this.offers.toString();
    }

    data['is_taxable'] = this.isTaxable;
    data['tax'] = this.tax;
    data['formatted_tax'] = this.formattedTax;
    data['show_tax'] = this.showTax;
    return data;
  }
}
