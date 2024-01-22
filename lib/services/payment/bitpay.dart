import 'package:bullion/core/models/module/checkout/bitpay_transcation_url.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/api_request/payment_request.dart';
import 'package:bullion/services/shared/analytics_service.dart';
import 'package:bullion/services/shared/api_base_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BitPayService {
  final ApiBaseService _apiBaseService = locator<ApiBaseService>();
  // final PaymentGatewayApi? _paymentGatewayApi = locator<PaymentGatewayApi>();

  openBitPayPayment() async {
    BitPayTranscationUrl transactionUrl = await _apiBaseService.request<BitPayTranscationUrl>(CheckOutPaymentRequest.createBitPayInvoice());

    if (transactionUrl.transcationUrl == null) {
      return null;
    }

    locator<AnalyticsService>().logScreenName("confirm/bitpay");

    return await locator<NavigationService>().push(MaterialPageRoute(builder: (context) => _BitPayPaymentGateway(transactionUrl.transcationUrl!)));
  }
}

class _BitPayPaymentGateway extends StatefulWidget {
  final String transactionUrl;

  const _BitPayPaymentGateway(this.transactionUrl);

  @override
  State<_BitPayPaymentGateway> createState() => _BitPayPaymentGatewayState();
}

class _BitPayPaymentGatewayState extends State<_BitPayPaymentGateway> {
  final WebViewController _controller = WebViewController();

  @override
  void initState() {
    _controller.loadRequest(Uri.parse(widget.transactionUrl));
    _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    _controller.setNavigationDelegate(NavigationDelegate(onUrlChange: (change) {
      if (change.url!.contains('bullion')) {
        locator<NavigationService>().pop(returnValue: true);
        NavigationDecision.prevent;
        return;
      }

      NavigationDecision.navigate;
      return;
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      child: SafeArea(
        child: WebViewWidget(
          controller: _controller,
        ),
      ),
    );
  }
}
