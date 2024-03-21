
import 'package:bullion/locator.dart';
import 'package:bullion/services/appconfig_service.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:bullion/services/payment/payment_gateway_service.dart';
import 'package:plaid_flutter/plaid_flutter.dart';

class PlaidService {

  Function(LinkSuccess)? onSuccessCallback;
  Function(LinkEvent)? onEventCallback;
  Function(LinkExit)? onExitCallback;

  final PaymentGatewayService _paymentGatewayApi = locator<PaymentGatewayService>();

  PlaidService({this.onSuccessCallback, this.onEventCallback, this.onExitCallback});

  openLinkToken() async {
    String token = await _paymentGatewayApi.getPlaidLinkToken();

    LinkConfiguration linkTokenConfiguration = LinkTokenConfiguration(
      token: token,
    );

    PlaidLink.onSuccess.listen(onSuccessCallback!);
    PlaidLink.onEvent.listen(onEventCallback!);
    PlaidLink.onExit.listen(onExitCallback!);
    PlaidLink.open(configuration: linkTokenConfiguration);
  }

}