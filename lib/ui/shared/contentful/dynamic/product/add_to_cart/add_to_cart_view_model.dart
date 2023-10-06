import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

class AddToCartViewModel extends VGTSBaseViewModel {

  // final CartService? _cartService = locator<CartService>();
  ProductDetails? _productDetails;

  ProductDetails? get productDetails => _productDetails;


  NumberFormFieldController qtyController = NumberFormFieldController(const ValueKey("txtQty"));

  // TextEditingController qtyController = new TextEditingController(text: "1");
  int get qtyValue => qtyController.text.isEmpty ? 0 : int.parse(qtyController.text);
  FocusNode qtyFocus = new FocusNode();

  bool _qtyValidate = false;

  bool get qtyValidate => _qtyValidate;

  set qtyValidate(bool value) {
    _qtyValidate = value;
    notifyListeners();
  }

  bool get showQty {
    if (qtyController.text.isEmpty)
      return false;
    return int.parse(qtyController.text) != 0;
  }

  init(ProductDetails? detail){
    _productDetails = detail;
    notifyListeners();
  }

  increase() {
    // if (qtyValue >= 9999){
    //   return;
    // }
    //
    // int qty = qtyValue + 1;
    // qtyController.text = qty.toString();
    // qtyController.selection = TextSelection(baseOffset: qtyController.text.length, extentOffset: qtyController.text.length);
    // notifyListeners();
  }

  decrease() {
    // if (qtyValue <= 1){
    //   return;
    // }
    //
    // int qty = qtyValue - 1;
    // qtyController.text = qty.toString();
    // qtyController.selection = TextSelection(baseOffset: qtyController.text.length, extentOffset: qtyController.text.length);
    // notifyListeners();
  }

  addProduct(vm) async {
    // qtyFocus.unfocus();
    //
    // busy(true);
    // PageSettings? response = await _cartService!.addItemToCart(_productDetails!.overview!.productId, qtyValue);
    // busy(false);
    //
    // if (response == null) {
    //   return;
    // }
    //
    // if (response.isSuccess!) {
    //   locator<AnalyticsService>().logAddToCart(
    //       itemId: _productDetails!.overview!.productId.toString(),
    //       itemName: _productDetails!.overview!.name!,
    //       quantity: qtyValue,
    //       currency: response.shoppingCart!.currency ?? 'USD',
    //       itemCategory: '',
    //   );
    //
    //   print(productDetails!.productId);
    //   CartItem? item = response.shoppingCart!.items!.firstWhereOrNull((element) => element.productId == productDetails!.overview!.productId);
    //   AlertResponse result = await locator<DialogService>().showBottomSheet(title: "Added to Cart", child: AddToCartSuccessBottomSheet(vm, item));
    }

}