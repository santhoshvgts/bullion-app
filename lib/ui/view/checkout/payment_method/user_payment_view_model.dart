import 'package:bullion/core/models/module/dynamic.dart';
import 'package:bullion/services/api_request/payment_request.dart';
import 'package:bullion/services/checkout/checkout_steam_service.dart';
import 'package:bullion/services/payment/braintree_service.dart';
import 'package:bullion/services/payment/payment_gateway_service.dart';
import 'package:bullion/services/payment/plaid_service.dart';
import 'package:bullion/ui/view/checkout/payment_method/echeck/add_echeck.dart';
import 'package:bullion/ui/view/checkout/payment_method/echeck/add_new_echeck_account.dart';
import 'package:bullion/ui/view/checkout/payment_method/user_payment_method_bottom_sheet.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/models/module/checkout/payment_method.dart';
import 'package:bullion/core/models/module/checkout/user_payment_method.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/helper/utils.dart';
import 'package:bullion/core/enums/echeck_type.dart';
import '../../../../../locator.dart';
import '../../../../../services/shared/dialog_service.dart';
import '../credit_card/credit_card_bottomsheet.dart';
import '../credit_card/credit_card_bottomsheet_view_model.dart';

class UserPaymentViewModel extends VGTSBaseViewModel {

  final DialogService dialogService = locator<DialogService>();

  final PaymentGatewayService _paymentGatewayApi = locator<PaymentGatewayService>();

  PaymentMethod paymentMethod;
  List<UserPaymentMethod>? userPaymentMethodList;

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  UserPaymentViewModel(this.paymentMethod, this.userPaymentMethodList);

  onUserPaymentMethodSelect(UserPaymentMethod userPaymentMethod) async {
    print("userPaymentMethod.requiresValidation${userPaymentMethod.requiresValidation}");
    if (userPaymentMethod.requiresValidation!) {
      var response = await dialogService.showBottomSheet(
          key: const ValueKey("bsUserPaymentMethodValidation"),
          title: userPaymentMethod.name,
          isDismissible: false,
          iconWidget: Icon(FAIcon(userPaymentMethod.icon), color: AppColor.primary,),
          child: paymentMethod.paymentMethodId == 19 ?
          RequiredECheckValidationBottomSheet(userPaymentMethod) :
          RequiredCreditCardValidationBottomSheet(userPaymentMethod)
      );

      print(response.toString());

      if (response.status == true) {
        dialogService.dialogComplete(AlertResponse(status: true), key: const ValueKey("bsUserPaymentMethodValidation"));
      }
      return;
    }

    loading = true;
    await locator<CheckoutStreamService>().savePaymentAndRefreshCheckout(paymentMethod.paymentMethodId, userPaymentMethodId: userPaymentMethod.userPaymentMethodId);
    loading = false;

    dialogService.dialogMaybeComplete(AlertResponse(status: true), key: const ValueKey("bsUserPaymentMethod"));
  }

  onAddNewClick() async {
    print(paymentMethod.paymentMethodId);

    Util.cancelLockEvent();

    switch(paymentMethod.paymentMethodId){

    case 19: // eCheck
        await _addECheckBankInformation();
        break;
      case 1: // Credit Card
      // case 2: // Bank Wire
        await _creditCardPage();
        break;
      default:
        if (paymentMethod.requiresZda!) {
          await _creditCardPage();
        }
        break;
    }

    Util.enableLockEvent();

  }

  onDeleteUserPaymentMethod(UserPaymentMethod userPaymentMethod) async  {
    AlertResponse alertResponse = await dialogService.showConfirmationDialog(title: "Remove Payment Method", description: "Are you sure to remove Payment Method ?", buttonTitle: "REMOVE");
     if (!alertResponse.status!) {
       return;
     }

     loading = true;
     var response = await request<DynamicModel>(PaymentRequest.removePaymentMethod(userPaymentMethod.userPaymentMethodId));
     if (response != null) {
       userPaymentMethodList!.removeWhere((element) => element.userPaymentMethodId == userPaymentMethod.userPaymentMethodId);
       loading = false;
       notifyListeners();

       locator<CheckoutStreamService>().refresh();

       if (userPaymentMethodList!.isEmpty) {
        dialogService.dialogComplete(AlertResponse(status: true, data: "REMOVE_PAYMENT"), key: const ValueKey("bsUserPaymentMethod"),);
      }
     }
  }

  _addECheckBankInformation() async {
    AlertResponse response = await dialogService.showBottomSheet(title: "Add ${paymentMethod.name}", isDismissible: false, child: AddECheckBottomSheet(allowManualACH: paymentMethod.allowManualACH, allowPlaidACH: paymentMethod.allowPlaidACH,));

    if (response == null){
      return;
    }

    if (response.data == eCheckType.Plaid) {
      PlaidService _plaidService = PlaidService(
        onSuccessCallback: onSuccessCallback,
        onEventCallback: onEventCallback,
        onExitCallback: onExitCallback
      );

      loading = true;
      _plaidService.openLinkToken();

    } else if (response.data == eCheckType.Manual) {
      await dialogService.showBottomSheet(title: "Add Bank Information", isDismissible: false, child: AddNewECheckPage(true));
    }

  }


  _creditCardPage() async {
    AlertResponse _res = await locator<DialogService>().showBottomSheet(child: const CreditCardPageBottomSheet(),title:"Add Credit Card",key: const ValueKey("AddCreditCard"));
    if(_res.status == true){
      _addCreditCardInformation(_res.data);
    }
  }

  _addCreditCardInformation(CreditCard card) async {

    loading = true;

    var data = await BraintreeService().openCreditCard(card);
    print(data);

    loading = false;

    if (data['status'] == 'success'){
      loading = true;
      print(paymentMethod.paymentMethodId);
      PaymentMethod? _paymentMethod = await request<PaymentMethod>(PaymentRequest.addCreditCard(data['nonce'], paymentMethod.paymentMethodId,));
      loading = false;

      await savePaymentToCheckout(paymentMethod.paymentMethodId, _paymentMethod, isNewAccount: true);
    }

  }

  // Plaid
  //
  onEventCallback(LinkEvent metadata) {
    print("onEvent: $metadata, metadata: ${metadata.metadata.description()}");
  }

  onSuccessCallback(LinkSuccess metadata) async {
    print("onSuccess: $metadata, metadata: ${metadata.metadata.description()}");

    loading = true;
    PaymentMethod? _paymentMethod = await request<PaymentMethod>(PaymentRequest.addBankAccountUsingPlaid(publicToken:metadata.publicToken, metadata: metadata.metadata));
    loading = false;

    savePaymentToCheckout(paymentMethod.paymentMethodId, _paymentMethod ,isNewAccount: true);
    // navigationService.pop();
  }

  onExitCallback(LinkExit? metadata) {
    print("onExit metadata: ${metadata!.metadata.description()}");
    loading  = false;
    print("onExit error: ${metadata.metadata.description()}");
    }

  savePaymentToCheckout(int? paymentMethodId, PaymentMethod? _paymentMethod, { bool isNewAccount = false }) async {
    loading = true;
    if (_paymentMethod == null){
      loading = false;
      return;
    }
     locator<CheckoutStreamService>().savePaymentAndRefreshCheckout(paymentMethodId, userPaymentMethodId: _paymentMethod.userPaymentMethodId, isNewAccount: isNewAccount);
     dialogService.dialogMaybeComplete(AlertResponse(status: true), key: const ValueKey("bsUserPaymentMethod"));
    loading = false;
  }


}