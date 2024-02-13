import 'package:bullion/core/models/auth/auth_response.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/appconfig_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

class GuestLoginViewModel extends VGTSBaseViewModel {
  bool fromMain = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  EmailFormFieldController emailController = EmailFormFieldController(const ValueKey("txtEmail"));

  init(bool fromMain) {
    this.fromMain = fromMain;
  }

  forgotPassword() {
    launchUrl(Uri.parse(locator<AppConfigService>().config!.appLinks!.forgotPasswordUrl!));
  }

  register() {
    navigationService.pushReplacementNamed(Routes.register, arguments:  { "fromMain": fromMain });
  }

  Future<String> login() async {
    if (formKey.currentState?.validate() != true) {
      return "Success";
    }
    setBusy(true);
    AuthResponse? result = await authenticationService.registerAsGuest(emailController.text);

    if (result != null) {
      if (fromMain) {
        navigationService.popAllAndPushNamed(Routes.dashboard);
      } else {
        navigationService.pop(returnValue: true);
      }
    }
    setBusy(false);
    return "Success";
  }
}
