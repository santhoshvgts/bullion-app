import 'dart:async';

import 'package:bullion/core/models/module/checkout/checkout.dart';
import 'package:bullion/core/models/user_address.dart';
import 'package:bullion/helper/logger.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/api_request/checkout_request.dart';
import 'package:bullion/services/checkout/cart_service.dart';
import 'package:bullion/services/shared/analytics_service.dart';
import 'package:bullion/services/shared/api_base_service.dart';

class CheckoutStreamService {

  final ApiBaseService _apiBaseService = locator<ApiBaseService>();

  Checkout? _checkout;

  Checkout? get checkout => _checkout;

  final StreamController<Checkout?> _streamController = StreamController<Checkout?>.broadcast();

  Stream<Checkout?>? get stream => _streamController.stream;

  clear() {
    _checkout = null;
    _streamController.add(null);
  }

  savePaymentAndRefreshCheckout(int? paymentMethodId, {int? userPaymentMethodId, bool isNewAccount = false }) async {
    Checkout? checkout = await _apiBaseService.request<Checkout>(CheckoutRequest.savePaymentMethod(paymentMethodId: paymentMethodId, userPaymentMethodId: userPaymentMethodId ?? 0));
    _refreshCheckout(checkout);

    if (isNewAccount) {
      try {
        locator<AnalyticsService>().logAddPaymentInfo(
            currency: "USD",
            orderTotal: checkout.orderTotal,
            paymentType: checkout.selectedPaymentMethod?.displayName ?? '',
            cartItem: locator<CartService>().cartItems
        );
      } catch (ex, s) {
        Logger.e(ex.toString(), s: s);
      }
    }
  }

  saveAddressAndRefreshCheckout(int id) async {
    Checkout? checkout = await _apiBaseService.request<Checkout>(CheckoutRequest.saveDeliveryAddress(addressId: id,));
    _refreshCheckout(checkout);
  }

  _refreshCheckout(Checkout? checkout){
    if (checkout != null) {
      _checkout = checkout;
      _streamController.add(checkout);
    }
  }

  refresh() async {
    Checkout? checkout = await _apiBaseService.request<Checkout>(CheckoutRequest.validatePrice());
    _refreshCheckout(checkout);
  }

}