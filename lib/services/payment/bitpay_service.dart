
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/payment/payment_gateway_service.dart';
import 'package:bullion/services/shared/analytics_service.dart';
import 'package:bullion/services/shared/device_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BitPayService {

  final PaymentGatewayService _paymentGatewayApi = locator<PaymentGatewayService>();

  openBitPayPayment() async {
    var transactionUrl = await _paymentGatewayApi.createBitPayInvoice();

    if (transactionUrl == null) {
      return null;
    }

    locator<AnalyticsService>().logScreenName("confirm/bitpay");
    return await locator<NavigationService>().push(MaterialPageRoute(builder: (context) => _BitPayPaymentGateway(transactionUrl)));
  }

}

class _BitPayPaymentGateway extends StatefulWidget {

  final String transactionUrl;

  const _BitPayPaymentGateway(this.transactionUrl);

  @override
  State<_BitPayPaymentGateway> createState() => _BitPayPaymentGatewayState();
}

class _BitPayPaymentGatewayState extends State<_BitPayPaymentGateway> {

  late WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(locator<DeviceService>().getWebViewUserAgent())
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest navigation) {
            if (navigation.url.contains('bullion')) {
              locator<NavigationService>().pop(returnValue: true);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          }
        ),
      )
      ..loadRequest(Uri.parse(widget.transactionUrl));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      child: SafeArea(
        child: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}