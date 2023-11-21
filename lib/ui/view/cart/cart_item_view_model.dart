import 'package:bullion/core/models/module/cart/cart_item.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';

class CartItemViewModel extends VGTSBaseViewModel {
  CartItem? item;

  TextEditingController qtyController = TextEditingController(text: "0");
  FocusNode qtyFocus = FocusNode();

  init(CartItem item) {
    this.item = item;
    qtyController.text = item.quantity.toString();
  }
}
