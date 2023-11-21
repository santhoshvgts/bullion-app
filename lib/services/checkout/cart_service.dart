import 'dart:async';

import 'package:bullion/core/models/module/page_settings.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/api_request/cart_request.dart';
import 'package:bullion/services/shared/api_base_service.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/services/shared/preference_service.dart';
import 'package:bullion/ui/view/cart/display_message_toast.dart';

class CartService {
  final ApiBaseService _apiBaseService = locator<ApiBaseService>();

  final StreamController<PageSettings?> _streamController =
      StreamController<PageSettings?>.broadcast();

  Stream<PageSettings?>? get stream => _streamController.stream;

  PageSettings? _cart;

  Future<PageSettings?> addItemToCart(int? productId, int qtyValue) async {
    PageSettings? response = await _apiBaseService.request(
      CartRequest.addShoppingCart(productId, qtyValue),
    );
    return _assignAndAddToStream(response);
  }

  Future<PageSettings?> getCart({bool refresh = false}) async {
    if (_cart == null || refresh) {
      _cart = await _apiBaseService.request(
        CartRequest.getShoppingCart(),
      );
    }
    return _assignAndAddToStream(_cart);
  }

  Future<PageSettings?> removeItemFromCart(int? productId) async {
    PageSettings? response = await _apiBaseService.request(
      CartRequest.removeShoppingCart(productId),
    );
    return _assignAndAddToStream(response);
  }

  Future<PageSettings?> applyCoupon(String coupon) async {
    PageSettings? response = await _apiBaseService.request(
      CartRequest.applyCoupon(coupon),
    );

    if (response?.isSuccess == false) return response;

    return _assignAndAddToStream(response);
  }

  Future<PageSettings?> modifyItem(int? productId, int qty) async {
    PageSettings? response = await _apiBaseService.request(
      CartRequest.modifyShoppingCart(productId, qty),
    );
    return _assignAndAddToStream(response);
  }

  clear() {
    _cart = null;
    _streamController.add(null);
    locator<PreferenceService>().removeCartId();
  }

  _assignAndAddToStream(PageSettings? response) {
    if (response != null) {
      if (response.isSuccess == false) {
        if (response.displayMessage != null) {
          locator<DialogService>().showBottomSheet(
              title: response.displayMessage!.title ?? '',
              child: DisplayMessageBottomSheet(response.displayMessage));
        }

        return null;
      }

      _cart = response;
      _streamController.add(response);
      return _cart;
    }
    return null;
  }
}
