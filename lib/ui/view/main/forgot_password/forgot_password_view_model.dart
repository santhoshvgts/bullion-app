import 'package:bullion/core/models/auth/forgot_password.dart';
import 'package:bullion/core/models/module/dynamic.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/api_request/auth_request.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

class ForgotPasswordViewModel extends VGTSBaseViewModel {
  bool fromMain = true;

  EmailFormFieldController emailController = EmailFormFieldController(const ValueKey("txtEmail"));

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  init(bool fromMain) {
    this.fromMain = fromMain;
  }

  Future<void> submit() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    setBusy(true);
    ForgotPasswordResult? result = await request<ForgotPasswordResult>(AuthRequest.forgotPassword(emailController.text));

    if (result != null) {
      navigationService.pushReplacementNamed(Routes.forgotPasswordSuccess, arguments: result.message);
    }

    setBusy(false);
    return;
  }
}
