import 'package:bullion/core/models/alert/alert_request.dart';
import 'package:bullion/router.dart';
import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/shared/sign_in_bottomsheet.dart';

import '../../locator.dart';

Future<bool> signInRequest(String image, {String? title, String? content, bool showGuestLogin = false}) async {
  AlertResponse? alertResponse = await locator<DialogService>().showBottomSheet(title: title, child: SignInBottomSheet(image, title: title, content: content, showGuestLogin: showGuestLogin,));

  if (alertResponse == null) {
    return false;
  }

  var authResponse;
  switch(alertResponse.data) {
    case SignInBottomSheetResult.LOGIN:
      authResponse = await locator<NavigationService>().pushNamed(Routes.login, arguments: { 'fromMain': false });
      break;
    case SignInBottomSheetResult.REGISTER:
      authResponse = await locator<NavigationService>().pushNamed(Routes.register, arguments: { 'fromMain': false });
      break;
    case SignInBottomSheetResult.GUEST:
      authResponse = await locator<NavigationService>().pushNamed(Routes.registerGuest, arguments: false);
      break;
  }

  return authResponse == true;

}
