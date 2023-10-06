// ignore_for_file: avoid_print

import 'package:bullion/core/models/auth/auth_response.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:bullion/services/shared/eventbus_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

import '../../../../core/constants/module_type.dart';

class LoginViewModel extends VGTSBaseViewModel {
  bool fromMain = true;
  String? redirectRoute;

  LoginViewModel(this.fromMain, this.redirectRoute);

  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  EmailFormFieldController emailController = EmailFormFieldController(
      const ValueKey("txtEmail"),
      required: true,
      requiredText: 'Required Email Address !');
  TextFormFieldController passwordController = TextFormFieldController(
      const ValueKey("txtPassword"),
      required: true,
      requiredText: 'Required Password !');

  init(bool fromMain, String? redirectRoute) {
    this.fromMain = fromMain;
    this.redirectRoute = redirectRoute;
  }

  forgotPassword() {
    navigationService.pushNamed(Routes.forgotPassword, arguments: fromMain);
  }

  register() {
    navigationService.pushNamed(Routes.register,
        arguments: {'fromMain': fromMain, 'redirectRoute': redirectRoute});
  }

  login() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }
    setBusy(true);
    AuthResponse? result = await _authenticationService.login(
      emailController.text,
      passwordController.text,
    );
    if (result != null) {
      if (fromMain) {
        navigationService.popAllAndPushNamed(Routes.dashboard);
      } else if (redirectRoute != null) {
        navigationService.pushReplacementNamed(redirectRoute!);
      } else {
        navigationService.pop(returnValue: true);
      }
      preferenceService.setFirstTimeAppOpen(false);
    }
    notifyListeners();
    setBusy(false);
  }

  continueWithoutLogin() {
    preferenceService.setFirstTimeAppOpen(false);
    navigationService.pushReplacementNamed(Routes.dashboard);
    locator<EventBusService>()
        .eventBus
        .fire(RefreshDataEvent(RefreshType.homeRefresh));
  }
}
