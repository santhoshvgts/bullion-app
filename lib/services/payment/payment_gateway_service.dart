import 'package:bullion/core/models/module/dynamic.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/api_request/payment_request.dart';
import 'package:bullion/services/shared/api_base_service.dart';

class PaymentGatewayService {

  final ApiBaseService _apiBaseService = locator<ApiBaseService>();

  Future<String> getBrainTreeClientToken() async {
    DynamicModel model = await _apiBaseService.request<DynamicModel>(PaymentRequest.getBrainTreeClientToken());
    String token = model.json['token'];
    return token;
  }

  Future<String> createBitPayInvoice() async {
    DynamicModel model = await _apiBaseService.request<DynamicModel>(PaymentRequest.createBitPayInvoice());
    String url = model.json['transaction_url'];
    return url;
  }

  Future<String> getPlaidLinkToken() async {
    DynamicModel model = await _apiBaseService.request<DynamicModel>(PaymentRequest.getPlaidLinkToken());
    String url = model.json['token'];
    return url;
  }

}