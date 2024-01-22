import 'package:bullion/services/api_request/payment_request.dart';
import 'package:bullion/services/checkout/checkout_steam_service.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/view/checkout/payment_method/echeck/add_new_echeck_account.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:bullion/core/enums/viewstate.dart';
import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/models/module/checkout/payment_method.dart';
import 'package:bullion/services/shared/analytics_service.dart';
import 'package:flutter/services.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

import '../../../../../../locator.dart';

class AddNewECheckViewModel extends VGTSBaseViewModel {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final DialogService dialogService = locator<DialogService>();

  NameFormFieldController nameController = NameFormFieldController(const ValueKey("txtName"));
  NameFormFieldController bankNameController = NameFormFieldController(const ValueKey("txtBankName"));
  FormFieldController bankNoController = FormFieldController(const ValueKey("txtBankNo"),
      textInputType: TextInputType.number,
      inputFormatter: [
        FilteringTextInputFormatter.deny(RegExp("[ ]{2}")),
      ]
  );
  FormFieldController accountNoController = FormFieldController(const ValueKey("txtAccountNo"),
      textInputType: TextInputType.number,
      inputFormatter: [
        FilteringTextInputFormatter.deny(RegExp("[ ]{2}")),
      ]
  );
  FormFieldController confirmAccountController = FormFieldController(
    const ValueKey("txtConfirmAccountNo"),
    textInputType: TextInputType.number,
    inputFormatter: [
      FilteringTextInputFormatter.deny(RegExp("[ ]{2}")),
    ]
  );

  bool hasUserPaymentMethod = false;

  bool _permission = false ;

  bool get permission => _permission;

  ScrollController scroll = ScrollController();

  SelectAccount _selectAccount = SelectAccount.Checking;


  SelectAccount get selectAccount => _selectAccount;

  AddNewECheckViewModel(this.hasUserPaymentMethod);

  void setAccount(SelectAccount value) {
    _selectAccount = value;
  }

  void OnChange() {
    _permission = ! _permission;
    notifyListeners();
  }


  addBankAccount(BuildContext context) async {

    if (formKey.currentState?.validate() == true) {
      return;
    }


    setBusy(true);

    Map<String, dynamic> data = {};

    data['account_name']= nameController.text;
    data['account_number']= accountNoController.text;
    data['confirm_account_number']= confirmAccountController.text;
    data['bank_routing_number']= bankNoController.text;
    data['bank_name']= bankNameController.text;
    data['is_checking']= selectAccount == SelectAccount.Checking ? true : false;
    data['requesting_view']= "" ;

    setBusy(true);

    PaymentMethod? _paymentMethod = await request<PaymentMethod>(PaymentRequest.addNewAccount(data));

    if(_paymentMethod != null) {
        await locator<CheckoutStreamService>().savePaymentAndRefreshCheckout(
          _paymentMethod.paymentMethodId,
          userPaymentMethodId: _paymentMethod.userPaymentMethodId,
          isNewAccount: true
        );
        dialogService.dialogComplete(AlertResponse(status: true));
        if (hasUserPaymentMethod){
          dialogService.dialogComplete(AlertResponse(status: true));
        }
        navigationService.pop();
      }

    setBusy(false);

  }

}