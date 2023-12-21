// import 'package:bullion/core/res/colors.dart';
// import 'package:bullion/locator.dart';
// import 'package:bullion/services/shared/navigator_service.dart';
// import 'package:flutter/widgets.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class BitPayService {

//   final PaymentGatewayApi? _paymentGatewayApi = locator<PaymentGatewayApi>();
//   final AppConfigService? _appConfigService = locator<AppConfigService>();

//   openBitPayPayment() async {
//     var transactionUrl = await _paymentGatewayApi!.createBitPayInvoice();

//     if (transactionUrl == null) {
//       return null;
//     }

//     locator<AnalyticsService>().logScreenName("confirm/bitpay");

//     return await locator<NavigationService>().push(MaterialPageRoute(builder: (context) => _BitPayPaymentGateway(transactionUrl)));
//   }

// }

// class _BitPayPaymentGateway extends StatelessWidget {

//   WebViewController _controller =  WebViewController();

//   final String transactionUrl;

//   _BitPayPaymentGateway(this.transactionUrl);

  

//   @override
//   Widget build(BuildContext context) {


//     return Container(
//       color: AppColor.white,
//       child: SafeArea(
//         child: WebView(
//           controller: _controller,
//           initialUrl: transactionUrl,

//           javascriptMode: JavascriptMode.unrestricted,
//           navigationDelegate: (NavigationRequest navigation) {

//             if (navigation.url.contains('apmex')) {
//               locator<NavigationService>().pop(returnValue: true);
//               return NavigationDecision.prevent;
//             }

//             return NavigationDecision.navigate;
//           },
//         ),
//       ),
//     );
//   }

// }