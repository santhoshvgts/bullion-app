
import 'package:bullion/core/models/auth/auth_response.dart';
import 'package:bullion/helper/utils.dart';
import 'package:bullion/services/api_request/account_request.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

class ChangeEmailViewModel extends VGTSBaseViewModel {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  EmailFormFieldController newEmailController = EmailFormFieldController(const ValueKey("txtEmail"));
  EmailFormFieldController confirmEmailController = EmailFormFieldController(const ValueKey("txtConfirmEmail"));
  EmailFormFieldController oldEmailController = EmailFormFieldController(const ValueKey("txtOldEmail"));

  @override
  Future onInit() async {
    setBusy(true);
    oldEmailController.text = authenticationService.getUser!.email!;
    setBusy(false);
    return super.onInit();
  }

  onSaveChangeEmail() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    isLoading = true;
    var response = await request<AuthResponse>(AccountRequest.changeEmail(oldEmailController.text, newEmailController.text, confirmEmailController.text));
    isLoading = false;

    if (response != null) {
      navigationService.pop(returnValue: true);
      Util.showSnackBar("Email Address Updated Successfully !");
    }

  }

}
