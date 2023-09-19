import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:bullion/core/models/module/module_settings.dart';
import 'package:bullion/core/models/module/page_settings.dart';
import 'package:bullion/locator.dart';
// import 'package:bullion/services/cart_service.dart';

class CartButtonViewModel extends VGTSBaseViewModel {
  PageSettings? cart;

  // final CartService? _cartService = locator<CartService>();

  int? get totalCartItem => cart == null ? 0 : cart!.shoppingCart!.totalItems;

  init() async {
    // cart = await _cartService!.getCart();
    // notifyListeners();
    //
    // _cartService!.stream?.listen((PageSettings? data) {
    //   cart = data;
    //   notifyListeners();
    // });
  }
}
