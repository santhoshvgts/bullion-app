import 'package:bullion/helper/logger.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/payment/payment_gateway_service.dart';
import 'package:bullion/ui/view/checkout/credit_card/credit_card_bottomsheet_view_model.dart';
import 'package:flutter_braintree/flutter_braintree.dart';

class BraintreeService {

  final PaymentGatewayService _paymentGatewayApi = locator<PaymentGatewayService>();

  openCreditCard(CreditCard card, {String currency = "USD"}) async {

    String? token = await _paymentGatewayApi.getBrainTreeClientToken();

    final request = BraintreeCreditCardRequest(
        cardNumber: card.cardNumber ?? '',
        expirationMonth: card.expirationMonth ?? '',
        expirationYear: card.expirationYear ?? '',
        cvv: card.cvv ?? ''
    );

    BraintreePaymentMethodNonce? result = await Braintree.tokenizeCreditCard(
      token,
      request,
    );

    if (result != null) {
      return {
        'status': 'success',
        'nonce': result.nonce
      };
    }
    return {
      'status': 'failed'
    };
  }

  Future<Map> openPayPal(double? amount, {String currency = "USD"}) async {
    String? token = await _paymentGatewayApi.getBrainTreeClientToken();

    try {
      BraintreePaymentMethodNonce? result = await Braintree.requestPaypalNonce(
        token,
        BraintreePayPalRequest(
            displayName: 'Bullion',
            amount: amount.toString(),
            currencyCode: currency,
            isShippingAddressRequired: true
        ),
      );

      if (result != null) {
        return {
          "nonce": result.nonce
        };
      }
    } catch (ex, s) {
      Logger.d(ex.toString(), s: s);
    }

    return {};
  }

}