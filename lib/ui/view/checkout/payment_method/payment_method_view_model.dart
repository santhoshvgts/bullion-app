import 'package:bullion/services/api_request/checkout_request.dart';
import 'package:bullion/services/api_request/payment_request.dart';
import 'package:bullion/services/checkout/checkout_steam_service.dart';
import 'package:bullion/services/payment/braintree_service.dart';
import 'package:bullion/services/payment/payment_gateway_service.dart';
import 'package:bullion/services/payment/plaid_service.dart';
import 'package:bullion/ui/view/checkout/payment_method/echeck/add_echeck.dart';
import 'package:bullion/ui/view/checkout/payment_method/echeck/add_new_echeck_account.dart';
import 'package:bullion/ui/view/checkout/payment_method/user_payment_method_bottom_sheet.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:bullion/core/enums/viewstate.dart';
import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/models/module/checkout/checkout.dart';
import 'package:bullion/core/models/module/checkout/payment_method.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/core/enums/echeck_type.dart';
import '../../../../../helper/utils.dart';
import '../credit_card/credit_card_bottomsheet.dart';
import '../credit_card/credit_card_bottomsheet_view_model.dart';

class PaymentMethodViewModel extends VGTSBaseViewModel {
  final DialogService dialogService = locator<DialogService>();
  final PaymentGatewayService _paymentGatewayApi = locator<PaymentGatewayService>();
  final CheckoutStreamService _checkoutStreamService = locator<CheckoutStreamService>();

  bool _isUserPaymentLoading = false;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isUserPaymentLoading => _isUserPaymentLoading;

  set isUserPaymentLoading(bool value) {
    _isUserPaymentLoading = value;
    notifyListeners();
  }

  List<PaymentMethod>? _paymentMethodList;

  List<PaymentMethod>? get paymentMethodList =>
      _paymentMethodList ?? [];

  init() async {
    setBusy(true);
    _paymentMethodList = await requestList<PaymentMethod>(CheckoutRequest.getPaymentMethods());
    setBusy(false);
  }

  onPaymentClick(PaymentMethod paymentMethod) async {
    Util.cancelLockEvent();

    if (!paymentMethod.supportsUserPaymentMethod! &&
        !paymentMethod.requiresZda!) {
      await savePaymentMethod(paymentMethod.paymentMethodId,
          userPaymentMethodId: paymentMethod.userPaymentMethodId);
    } else {
      if (paymentMethod.hasUserPaymentMethod! || paymentMethod.requiresZda!) {
        AlertResponse alertResponse = await dialogService.showBottomSheet(
            key: const ValueKey("bsUserPaymentMethod"),
            title: paymentMethod.name,
            isDismissible: false,
            child: UserPaymentMethodBottomSheet(
                paymentMethod, paymentMethod.userPaymentMethods));
        if (alertResponse.status == true &&
            alertResponse.data == "REMOVE_PAYMENT") {
          init();
          return;
        }
      } else {
        switch (paymentMethod.paymentMethodId) {
          case 19: // eCheck
            await _addECheckBankInformation(paymentMethod);
            break;
          case 1: // Credit Card
            await _creditCardPage(paymentMethod);
            break;
          default:
            break;
        }
        return;
      }
    }
    navigationService.pop();
  }

  Future<Checkout?> savePaymentMethod(int? paymentMethodId,
      {int? userPaymentMethodId}) async {
    isLoading = true;
    var response = await _checkoutStreamService.savePaymentAndRefreshCheckout(
        paymentMethodId,
        userPaymentMethodId:
            userPaymentMethodId ?? 0);
    isLoading = false;
    return response;
  }

  _addECheckBankInformation(PaymentMethod paymentMethod) async {
    AlertResponse response = await dialogService.showBottomSheet(
        title: "Add ${paymentMethod.name}",
        isDismissible: false,
        child: AddECheckBottomSheet(
          allowManualACH: paymentMethod.allowManualACH,
          allowPlaidACH: paymentMethod.allowPlaidACH,
        ));

    if (response.status == null && response.data == null) {
      await Util.enableLockEvent();
      return;
    }

    isUserPaymentLoading = true;

    if (response.data == eCheckType.Plaid) {
      PlaidService plaidService = PlaidService(
          onSuccessCallback: onSuccessCallback,
          onEventCallback: onEventCallback,
          onExitCallback: onExitCallback
      );

      plaidService.openLinkToken();
    } else if (response.data == eCheckType.Manual) {
      await dialogService.showBottomSheet(
          title: "Add Bank Information",
          isDismissible: false,
          child: AddNewECheckPage(false));
      isUserPaymentLoading = false;
    }
  }

  _creditCardPage(PaymentMethod paymentMethod) async {
    AlertResponse _res = await locator<DialogService>().showBottomSheet(
        child: const CreditCardPageBottomSheet(),
        title: "Credit Card",
        key: const ValueKey("AddCreditCard"));
    if (_res.status == true) {
      _addCreditCardInformation(paymentMethod, _res.data);
    }
    notifyListeners();
  }

  _addCreditCardInformation(
      PaymentMethod paymentMethod, CreditCard card) async {
    isUserPaymentLoading = true;

    var data = await BraintreeService().openCreditCard(card);
    print(data);

    if (data['status'] == 'success') {
      PaymentMethod? _paymentMethod = await request<PaymentMethod>(PaymentRequest.addCreditCard(
        data['nonce'],
        paymentMethod.paymentMethodId,
      ));

      await savePaymentToCheckout(_paymentMethod, isNewAccount: true);
    }

    isUserPaymentLoading = false;

    await Util.enableLockEvent();

    notifyListeners();
  }

  // Plaid
  //
  onEventCallback(LinkEvent metadata) {
    print("onEvent: $metadata, metadata: ${metadata.metadata.description()}");
  }

  onSuccessCallback(LinkSuccess metadata) async {
    print("onSuccess: $metadata.publicToken, metadata: ${metadata.metadata.description()}");

    PaymentMethod? _paymentMethod = await request<PaymentMethod>(PaymentRequest.addBankAccountUsingPlaid(
            publicToken: metadata.publicToken, metadata: metadata.metadata));

    await savePaymentToCheckout(_paymentMethod, isNewAccount: true);
  }

  onExitCallback(LinkExit? metadata) async {
    print("onExit metadata: ${metadata!.metadata.description()}");
    isUserPaymentLoading = false;
    await Util.enableLockEvent();
    if (error != null) {
      print("onExit error: ${metadata.metadata.description()}");
    }
  }

  savePaymentToCheckout(PaymentMethod? _paymentMethod, { bool isNewAccount = false }) async {
    if (_paymentMethod == null) {
      isUserPaymentLoading = false;
      return;
    }

    await locator<CheckoutStreamService>().savePaymentAndRefreshCheckout(
        _paymentMethod.paymentMethodId,
        userPaymentMethodId: _paymentMethod.userPaymentMethodId,
      isNewAccount: isNewAccount
    );
    navigationService.pop();
    isUserPaymentLoading = false;
    await Util.enableLockEvent();
  }
}
