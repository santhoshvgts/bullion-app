import 'package:bullion/core/models/auth/auth_response.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:bullion/services/shared/eventbus_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

import '../../../../core/constants/module_type.dart';

class RegisterViewModel extends VGTSBaseViewModel {
  bool fromMain = true;
  String? redirectRoute;

  RegisterViewModel(this.fromMain, this.redirectRoute);

  final AuthenticationService _authenticationService = locator<AuthenticationService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  NameFormFieldController nameController = NameFormFieldController(const ValueKey("txtName"));
  NameFormFieldController lnameController = NameFormFieldController(const ValueKey("txtLastName"));
  EmailFormFieldController emailController = EmailFormFieldController(const ValueKey("txtEmail"));
  PasswordFormFieldController passwordController = PasswordFormFieldController(const ValueKey("txtPassword"));

  register(BuildContext context) async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    setBusy(true);
    AuthResponse? result = await _authenticationService.register(
        nameController.text,
        lnameController.text,
        emailController.text,
        passwordController.text);

    if (result != null) {
      if (fromMain) {
        navigationService.popAllAndPushNamed(Routes.dashboard);
      } else if (redirectRoute != null) {
        navigationService.pushReplacementNamed(redirectRoute!);
      } else {
        navigationService.pop(returnValue: true);
        locator<EventBusService>().eventBus.fire(RefreshDataEvent(RefreshType.homeRefresh));
      }
      preferenceService.setFirstTimeAppOpen(false);
    }
    setBusy(false);
  }

  continueWithoutLogin() {
    preferenceService.setFirstTimeAppOpen(false);
    locator<EventBusService>().eventBus.fire(RefreshDataEvent(RefreshType.homeRefresh));
    navigationService.pushReplacementNamed(Routes.dashboard);
  }

  login() async {
    locator<EventBusService>().eventBus.fire(RefreshDataEvent(RefreshType.homeRefresh));
    await navigationService.pushReplacementNamed(Routes.login, arguments: { 'fromMain':fromMain, 'redirectRoute': redirectRoute });
  }

}
