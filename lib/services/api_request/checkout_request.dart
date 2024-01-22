import 'package:bullion/core/models/module/checkout/selected_payment_method.dart';
import 'package:bullion/core/models/module/checkout/shipping_address.dart';
import 'package:bullion/services/shared/api_model/request_settings.dart';
import 'package:bullion/services/shared/request_method.dart';

class CheckOutRequest {
  //

  static RequestSettings getCheckout() {
    return RequestSettings("/checkout/get", RequestMethod.GET, params: null, authenticated: true);
  }

  //

  static RequestSettings validatePrice() {
    return RequestSettings("/checkout/validate-cart", RequestMethod.GET, params: null, authenticated: true);
  }

  //

  static RequestSettings getPaymentMethods() {
    return RequestSettings("/checkout/get-payment-methods", RequestMethod.GET, params: null, authenticated: true);
  }

  //

  // static RequestSettings savePaymentAndRefreshCheckout(int? paymentMethodId, {int? userPaymentMethodId}) {
  //    return RequestSettings("/checkout/get-payment-methods", RequestMethod.GET, params: null, authenticated: true);
  //   Checkout? checkout = await _checkoutApi!.savePaymentMethod(paymentMethodId: paymentMethodId, userPaymentMethodId: userPaymentMethodId == null ? 0 : userPaymentMethodId);
  //   _refreshCheckout(checkout);
  // }

  //

  static RequestSettings saveDeliveryAddress({int? addressId, String? citadelAccount}) {
    String queryString = "?";
    queryString += "addressId=$addressId";
    queryString += "&citadelAccount=$citadelAccount";

    return RequestSettings("/checkout/save-address$queryString", RequestMethod.POST, params: null, authenticated: true);
  }

  //

  static RequestSettings saveShippingOption({int? shippingId, double? shipCharge}) {
    String queryString = "?";

    queryString += "shippingId=$shippingId";
    queryString += "&shipCharge=$shipCharge";

    return RequestSettings("/checkout/save-shipping-option$queryString", RequestMethod.POST, params: null, authenticated: true);
  }

  //

  static RequestSettings placeOrder(ShippingAddress? shippingAddress, SelectedPaymentMethod? paymentMethod, String? paymentMethodNonce, String? paymentMethodDeviceData) {
    Map<String, dynamic> params = {};
    params['selected_address_id'] = shippingAddress == null
        ? null
        : shippingAddress.isCitadel!
            ? null
            : shippingAddress.address!.id;
    params['is_citadel'] = shippingAddress == null ? false : shippingAddress.isCitadel;
    params['selected_payment_id'] = paymentMethod?.paymentMethodId;
    params['payment_method_nounce'] = paymentMethodNonce;
    params['payment_method_device_data'] = paymentMethodDeviceData;

    return RequestSettings("/checkout/place-order", RequestMethod.POST, params: params, authenticated: true);
  }

  //

  static RequestSettings removeDiscountByKey(String? keyCode) {
    String queryString = "?";

    queryString += "keycode=$keyCode";

    return RequestSettings("/checkout/remove-discounts-by-key$queryString", RequestMethod.POST, params: null, authenticated: true);
  }

  //

  static RequestSettings savePaymentMethod({int? paymentMethodId, int? userPaymentMethodId}) {
    String queryString = "?";

    queryString += "paymentMethodId=$paymentMethodId";
    queryString += "&userPaymentMethodId=$userPaymentMethodId";

    return RequestSettings("/checkout/save-payment$queryString", RequestMethod.POST, params: null, authenticated: true);
  }

  //
}
