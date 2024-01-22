import 'package:bullion/services/shared/api_model/request_settings.dart';
import 'package:bullion/services/shared/request_method.dart';


class CheckOutPaymentRequest {
  //
  static RequestSettings getPlaidLinkToken() {
    return RequestSettings("/payment-method/get-plaid-link-token", RequestMethod.GET, params: null, authenticated: true);
  }

  //

  static RequestSettings getBrainTreeClientToken() {
    return RequestSettings("/payment-method/get-brain-tree-client-token", RequestMethod.GET, params: null, authenticated: true);
  }

  //

  static RequestSettings createBitPayInvoice() {
    return RequestSettings("/checkout/create-bitpay-invoice", RequestMethod.POST, params: null, authenticated: true);
  }

  

  // static RequestSettings addBankAccountUsingPlaid({String? publicToken, required LinkSuccessMetadata metadata}) {

  //   print(metadata.toString());

  //    LinkAccount account = metadata.accounts[0];

  //   Map<String, dynamic> params = new Map();
  //   params['public_token'] = publicToken;
  //   params['account_name'] = account.name;
  //   params['account_number'] = account.mask;
  //   params['bank_account_type'] = account.type;
  //   params['institution_name'] = metadata.institution?.name;
  //   params['payment_provider_account_id'] = account.id;
  //   params['verification_status'] = account.verificationStatus;
  //   params['routing_number'] = "";
  //   params['requesting_view'] = "";

  //   return RequestSettings("/payment-method/add-bank-account-using-plaid", RequestMethod.POST, params: null, authenticated: true);
  // }

 
  
}
