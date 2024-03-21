import 'package:bullion/core/models/auth/auth_response.dart';
import 'package:bullion/helper/utils.dart';
import 'package:bullion/services/api_request/account_request.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

class ChangePasswordViewModel extends VGTSBaseViewModel {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String passwordErrorMessage = "Required New Password";

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  FormFieldController newPasswordController = FormFieldController(
      const ValueKey("txtPassword"),
      validator: (String? value) {
        if ((value?.length ?? 0) < 7) {
          return "Password should have minimum 7 characters";
        }
        return null;
      }
  );
  FormFieldController confirmPasswordController = FormFieldController(
      const ValueKey("txtCPassword"),
      validator: (String? value) {
        if ((value?.length ?? 0) < 7) {
          return "Password should have minimum 7 characters";
        }
        return null;
      }
  );
  TextFormFieldController oldPasswordController = TextFormFieldController(const ValueKey("txtOldPassword"));

  onSaveChangePassword() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    isLoading = true;
    var response = await request<AuthResponse>(AccountRequest.changePassword(oldPasswordController.text, newPasswordController.text, confirmPasswordController.text));
    isLoading = false;

    if (response != null) {
      navigationService.pop(returnValue: true);
      Util.showSnackBar("Password Updated Successfully !");
    }

  }

}