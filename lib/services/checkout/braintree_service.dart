import 'package:bullion/core/models/module/checkout/checkout.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/api_request/payment_request.dart';
import 'package:bullion/services/shared/api_base_service.dart';
import 'package:flutter_braintree/flutter_braintree.dart';

class BraintreeService {
//  final PaymentGatewayApi? _paymentGatewayApi = locator<PaymentGatewayApi>();

  final ApiBaseService _apiBaseService = locator<ApiBaseService>();

  // openCreditCard(CreditCard card, {String currency = "USD"}) async {

  //   // String? token = await _apiBaseService.request<String>(   .getBrainTreeClientToken();

  //   // final request = BraintreeCreditCardRequest(
  //   //     cardNumber: card.cardNumber ?? '',
  //   //     expirationMonth: card.expirationMonth ?? '',
  //   //     expirationYear: card.expirationYear ?? '',
  //   //     cvv: card.cvv ?? ''
  //   // );

  //   // BraintreePaymentMethodNonce? result = await Braintree.tokenizeCreditCard(
  //   //   token,
  //   //   request,
  //   // );

  //   // if (result != null) {
  //   //   return {
  //   //     'status': 'success',
  //   //     'nonce': result.nonce
  //   //   };
  //   // }
  //   // return {
  //   //   'status': 'failed'
  //   // };

  // }

  Future<Map> openPayPal(double? amount, {String currency = "USD"}) async {
    String? token = await _apiBaseService.request<Checkout>(BraintreeRequest.getBrainTreeClientToken());// _paymentGatewayApi!.getBrainTreeClientToken();

    try {
      BraintreePaymentMethodNonce? result = await Braintree.requestPaypalNonce(
        token,
        BraintreePayPalRequest(displayName: 'Apmex', amount: amount.toString(), currencyCode: currency, isShippingAddressRequired: true),
      );

      if (result != null) {
        return {"nonce": result.nonce};
      }
    } catch (ex) {
      return {};
    }

    return {};
  }
}
