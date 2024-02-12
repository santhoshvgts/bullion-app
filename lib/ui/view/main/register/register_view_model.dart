import 'package:bullion/core/models/auth/auth_response.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:bullion/services/shared/api_model/error_response_exception.dart';
import 'package:bullion/services/shared/api_model/request_settings.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/services/shared/eventbus_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

import '../../../../core/constants/module_type.dart';

class RegisterViewModel extends VGTSBaseViewModel {
  bool fromMain = true;
  String? redirectRoute;

  RegisterViewModel(this.fromMain, this.redirectRoute);

  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  NameFormFieldController nameController = NameFormFieldController(
    const ValueKey("txtName"),
  );
  TextFormFieldController lnameController = TextFormFieldController(
    const ValueKey("txtLastName"),
  );
  EmailFormFieldController emailController = EmailFormFieldController(
    const ValueKey("txtEmail"),
  );
  FormFieldController passwordController = FormFieldController(
    const ValueKey("txtPassword"),
    validator: (String? value) {
      if ((value?.length ?? 0) < 7) {
        return "Password should have minimum 7 characters";
      }
      return null;
    }
  );
  late FormFieldController confirmPasswordController;

  @override
  Future onInit() {
    confirmPasswordController = FormFieldController(
        const ValueKey("txtConfirmPassword"),
        textCapitalization: TextCapitalization.none,
        validator: (String? value) {
          return confirmPasswordValidator(value);
        }
    );
    return super.onInit();
  }

  String? confirmPasswordValidator(String? value) {
    if (passwordController.text != value) {
      return "Password does not match";
    }

    return null;
  }

  register(BuildContext context) async {
    if (formKey.currentState?.validate() != true) {
      return;
    }
    setBusy(true);
    AuthResponse? result = await _authenticationService.register(
      nameController.text,
      lnameController.text,
      emailController.text,
      passwordController.text,
      confirmPasswordController.text,
    );
    handleAuthResponse(result);
     setBusy(false);
  }

  continueWithoutLogin() {
    preferenceService.setFirstTimeAppOpen(false);
    locator<EventBusService>()
        .eventBus
        .fire(RefreshDataEvent(RefreshType.homeRefresh));
    navigationService.pushReplacementNamed(Routes.dashboard);
  }

  login() async {
    locator<EventBusService>()
        .eventBus
        .fire(RefreshDataEvent(RefreshType.homeRefresh));
    await navigationService.pushReplacementNamed(Routes.login,
        arguments: {'fromMain': fromMain, 'redirectRoute': redirectRoute
    });
  }
  googleSignIn() async {
    setBusyForObject("GOOGLE", true);
    AuthResponse? result = await _authenticationService.signInWithGoogle();
    handleAuthResponse(result);
    setBusyForObject("GOOGLE", false);
  }

  @override
  void handleErrorResponse(
    RequestSettings settings,
    ErrorResponseException exception,
  ) {
    locator<DialogService>().showDialog(description: exception.error?.message);
    super.handleErrorResponse(settings, exception);
  }

  handleAuthResponse(AuthResponse? result) {
    if (result != null) {
      if (fromMain) {
        navigationService.popAllAndPushNamed(Routes.dashboard);
      } else if (redirectRoute != null) {
        navigationService.pushReplacementNamed(redirectRoute!);
      } else {
        navigationService.pop(returnValue: true);
        locator<EventBusService>()
            .eventBus
            .fire(RefreshDataEvent(RefreshType.homeRefresh));
      }
      preferenceService.setFirstTimeAppOpen(false);
    }
  }
}
