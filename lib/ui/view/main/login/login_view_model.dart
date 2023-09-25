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

  final AuthenticationService _authenticationService = locator<AuthenticationService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  EmailFormFieldController emailController = EmailFormFieldController(const ValueKey("txtEmail"));
  PasswordFormFieldController passwordController = PasswordFormFieldController(const ValueKey("txtPassword"));

  bool _rememberCheck = false;

  bool get rememberCheck => _rememberCheck;

  set rememberCheck(bool value) {
    _rememberCheck = value;
    notifyListeners();
  }

  init(bool fromMain, String? redirectRoute) {
    this.fromMain = fromMain;
    this.redirectRoute = redirectRoute;
  }

  forgotPassword() {
    navigationService.pushReplacementNamed(Routes.forgotPassword, arguments: fromMain);
  }

  register() {
    navigationService.pushNamed(Routes.register, arguments: {'fromMain': fromMain, 'redirectRoute': redirectRoute});
  }



  continueWithoutLogin() {
    preferenceService.setFirstTimeAppOpen(false);
    navigationService.pushReplacementNamed(Routes.dashboard);
    locator<EventBusService>().eventBus.fire(RefreshDataEvent(RefreshType.homeRefresh));
  }

  Future<String> login() async {
    if (formKey.currentState?.validate() != true) {
      return "Invalid Information";
    }

    setBusy(true);
    AuthResponse? result = await _authenticationService.login(emailController.text, passwordController.text);

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
    return "Success";
  }
}
