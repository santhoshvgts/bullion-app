import 'package:bullion/services/shared/api_model/request_settings.dart';
import 'package:bullion/services/shared/request_method.dart';
import 'package:plaid_flutter/plaid_flutter.dart';


class PaymentRequest {

  static RequestSettings getPlaidLinkToken() {
    return RequestSettings("/payment-method/get-plaid-link-token", RequestMethod.GET, params: null, authenticated: true);
  }

  static RequestSettings getBrainTreeClientToken() {
    return RequestSettings("/payment-method/get-brain-tree-client-token", RequestMethod.GET, params: null, authenticated: true);
  }

  static RequestSettings createBitPayInvoice() {
    return RequestSettings("/checkout/create-bitpay-invoice", RequestMethod.POST, params: null, authenticated: true);
  }

  static RequestSettings addBankAccountUsingPlaid({String? publicToken, required LinkSuccessMetadata metadata}) {
    print(metadata.toString());
    LinkAccount account = metadata.accounts[0];

    Map<String, dynamic> params = {};
    params['public_token'] = publicToken;
    params['account_name'] = account.name;
    params['account_number'] = account.mask;
    params['bank_account_type'] = account.type;
    params['institution_name'] = metadata.institution?.name;
    params['payment_provider_account_id'] = account.id;
    params['verification_status'] = account.verificationStatus;
    params['routing_number'] = "";
    params['requesting_view'] = "";

    return RequestSettings("/payment-method/add-bank-account-using-plaid", RequestMethod.POST, params: params, authenticated: true);
  }

  static RequestSettings addCreditCard(String? paymentNonce, int? paymentMethodId, {String deviceData = ''}) {

    Map<String, dynamic> params = {};
    params['payment_method_nounce'] = paymentNonce;
    params['payment_method_device_data'] = deviceData;
    params['payment_method_id'] = paymentMethodId;
    return RequestSettings("/payment-method/add-credit-card", RequestMethod.POST, params: params, authenticated: true);
  }


  static RequestSettings removePaymentMethod(int? userPaymentMethodId) {
    String queryParams = "?userPaymentMethodId=$userPaymentMethodId";
    return RequestSettings("/payment-method/remove-payment-method$queryParams", RequestMethod.POST, params: null, authenticated: true);
  }

  static RequestSettings validateBankAccount(String id, String accountNumber) {
    String queryParams = "?userPaymentMethodId=$id&accountNumber=$accountNumber";
    return RequestSettings("/payment-method/validate-bank-account-number$queryParams", RequestMethod.POST, params: null, authenticated: true);
  }

  static RequestSettings addNewAccount(data) {
    return RequestSettings("/payment-method/add-bank-account", RequestMethod.POST, params: data, authenticated: true);
  }



}
