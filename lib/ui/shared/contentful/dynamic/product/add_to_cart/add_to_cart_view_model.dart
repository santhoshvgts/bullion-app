import 'package:bullion/core/models/module/page_settings.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/helper/utils.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/checkout/cart_service.dart';
import 'package:bullion/services/shared/analytics_service.dart';
import 'package:bullion/services/shared/eventbus_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

import '../../../../../../core/models/module/cart/cart_item.dart';

class AddToCartViewModel extends VGTSBaseViewModel {

  final CartService _cartService = locator<CartService>();
  ProductDetails? _productDetails;

  ProductDetails? get productDetails => _productDetails;


  NumberFormFieldController qtyController = NumberFormFieldController(const ValueKey("txtQty"));

  int get qtyValue => qtyController.text.isEmpty ? 0 : int.parse(qtyController.text);
  FocusNode qtyFocus = FocusNode();

  bool _qtyValidate = false;

  bool get qtyValidate => _qtyValidate;

  set qtyValidate(bool value) {
    _qtyValidate = value;
    notifyListeners();
  }

  bool get showQty {
    if (qtyController.text.isEmpty) {
      return false;
    }
    return int.parse(qtyController.text) != 0;
  }

  init(ProductDetails? detail){
    _productDetails = detail;
    qtyController.text = detail?.overview?.orderMin?.toString() ?? '1';
    notifyListeners();
  }

  increase() {
    if (qtyValue >= 9999){
      return;
    }

    int qty = qtyValue + 1;
    qtyController.text = qty.toString();
    qtyController.textEditingController.selection = TextSelection(baseOffset: qtyController.text.length, extentOffset: qtyController.text.length);
    notifyListeners();
  }

  decrease() {
    if (qtyValue <= (productDetails?.overview?.orderMin ?? 0)){
      return;
    }

    int qty = qtyValue - 1;
    qtyController.text = qty.toString();
    qtyController.textEditingController.selection = TextSelection(baseOffset: qtyController.text.length, extentOffset: qtyController.text.length);
    notifyListeners();
  }

  addProduct(vm) async {
    qtyFocus.unfocus();

    setBusy(true);
    PageSettings? response = await _cartService!.addItemToCart(
        _productDetails!.overview!.productId, qtyValue);
    setBusy(false);

    if (response == null) {
      return;
    }

    if (response.isSuccess!) {
      locator<AnalyticsService>().logAddToCart(
        itemId: _productDetails!.overview!.productId.toString(),
        itemName: _productDetails!.overview!.name!,
        quantity: qtyValue,
        currency: response.shoppingCart!.currency ?? 'USD',
        itemCategory: '',
      );

      CartItem? item = response.shoppingCart!.items!.where((element) =>
      element.productId == productDetails!.overview!.productId).firstOrNull;
      // AlertResponse result = await locator<DialogService>().showBottomSheet(title: "Added to Cart", child: AddToCartSuccessBottomSheet(vm, item));

      Util.showProductCheckout(productDetails!.overview!);
    }
  }

  triggerProductUpdateEvent(int qty) {
    // try {
    //   locator<EventBusService>().eventBus.fire(
    //       ProductQtyUpdateEvent(productDetails!.overview!.productId!, qty));
    //   print("TRIGGERED EVENT $qty");
    // } catch (ex, s) {
    //   Logger.e(ex.toString(), s: s);
    // }
  }
}

