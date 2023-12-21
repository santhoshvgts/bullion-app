import 'dart:async';

import 'package:bullion/core/models/module/checkout/checkout.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/api_request/checkout_request.dart';
import 'package:bullion/services/shared/api_base_service.dart';

class CheckoutStreamService {
  Checkout? _checkout;
  final ApiBaseService _apiBaseService = locator<ApiBaseService>();

  Checkout? get checkout => _checkout;

  final StreamController<Checkout?> _streamController = StreamController<Checkout?>.broadcast();

  Stream<Checkout?>? get stream => _streamController.stream;

  clear() {
    _checkout = null;
    _streamController.add(null);
  }

  savePaymentAndRefreshCheckout(int? paymentMethodId, {int? userPaymentMethodId}) async {
    Checkout? checkout = await _apiBaseService.request<Checkout>(CheckOutRequest.savePaymentMethod(paymentMethodId: paymentMethodId, userPaymentMethodId: userPaymentMethodId ?? 0));
    _refreshCheckout(checkout);
  }

  _refreshCheckout(Checkout? checkout) {
    if (checkout != null) {
      _checkout = checkout;
      _streamController.add(checkout);
    }
  }

  refresh() async {
    Checkout? checkout = await _apiBaseService.request<Checkout>(CheckOutRequest.validatePrice());
    _refreshCheckout(checkout);
  }
}
