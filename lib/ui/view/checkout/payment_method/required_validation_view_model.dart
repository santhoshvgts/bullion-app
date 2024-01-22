import 'package:bullion/services/api_request/payment_request.dart';
import 'package:bullion/services/checkout/checkout_steam_service.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/models/module/checkout/payment_method.dart';
import 'package:bullion/locator.dart';
import 'package:flutter/services.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

class RequiredValidationViewModel extends VGTSBaseViewModel {

  final DialogService dialogService = locator<DialogService>();

  FormFieldController accountNoController = FormFieldController(const ValueKey("txtAccountNo"),
      textInputType: TextInputType.number,
      inputFormatter: [
        FilteringTextInputFormatter.deny(RegExp("[ ]{2}")),
      ]
  );

  void validateAccountNumber(int? userPaymentMethodId) async {
    setBusy(true);
    PaymentMethod? response = await request<PaymentMethod>(PaymentRequest.validateBankAccount(userPaymentMethodId.toString(), accountNoController.text));
    setBusy(false);

    if (response != null) {
      setBusy(true);
      await locator<CheckoutStreamService>().savePaymentAndRefreshCheckout(response.paymentMethodId, userPaymentMethodId: response.userPaymentMethodId,);
      setBusy(false);

      dialogService.dialogComplete(AlertResponse(status: true));
      dialogService.dialogComplete(AlertResponse(status: true));
      navigationService.pop();
    }
  }


}