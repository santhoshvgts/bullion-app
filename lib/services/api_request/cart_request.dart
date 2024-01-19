import 'package:bullion/services/shared/api_model/request_settings.dart';
import 'package:bullion/services/shared/request_method.dart';

class CartRequest {
  static RequestSettings getShoppingCart() {
    return RequestSettings(
      "/shopping-cart/get",
      RequestMethod.GET,
      params: null,
      authenticated: false,
    );
  }

  static RequestSettings addShoppingCart(int? productId, int qty) {
    return RequestSettings(
      "/shopping-cart/add?productId=$productId&qty=$qty",
      RequestMethod.POST,
      params: null,
      authenticated: false,
    );
  }

  static RequestSettings removeShoppingCart(int? productId) {
    return RequestSettings(
      "/shopping-cart/remove?productId=$productId",
      RequestMethod.POST,
      params: null,
      authenticated: false,
    );
  }

  static RequestSettings applyCoupon(String coupon) {
    return RequestSettings(
      "/shopping-cart/validate-coupon?coupon=$coupon",
      RequestMethod.POST,
      params: null,
      authenticated: false,
    );
  }

  static RequestSettings modifyShoppingCart(int? productId, int qty) {
    return RequestSettings(
      "/shopping-cart/modify?productId=$productId&qty=$qty",
      RequestMethod.POST,
      params: null,
      authenticated: false,
    );
  }
}
