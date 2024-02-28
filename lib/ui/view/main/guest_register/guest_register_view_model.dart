

import 'package:bullion/core/models/auth/auth_response.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

class GuestRegisterViewModel extends VGTSBaseViewModel {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  FormFieldController passwordController = FormFieldController(
    const ValueKey("txtPassword"),
      validator: (String? value) {
        if ((value?.length ?? 0) < 7) {
          return "Password should have minimum 7 characters";
        }
        return null;
      }
  );

  bool _rememberCheck = true;

  bool get rememberCheck => _rememberCheck;

  set rememberCheck(bool value) {
    _rememberCheck = value;
    notifyListeners();
  }

  register() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    if (passwordController.text.isEmpty == true) {
      return;
    }

    setBusy(true);
    AuthResponse? authResponse = await authenticationService.guestToAccount(passwordController.text, rememberCheck);
    setBusy(false);

    if (authResponse != null){
      locator<DialogService>().dialogComplete(AlertResponse(status: true), key: const ValueKey("bsGuestRegister"));
    }

  }

}