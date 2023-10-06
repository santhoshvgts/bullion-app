import 'package:bullion/ui/view/vgts_base_view_model.dart';

import '../../../locator.dart';
import '../../../services/authentication_service.dart';

class SettingsViewModel extends VGTSBaseViewModel {
  // Logout Fuction
  logoutOnPressed() async {
    setBusy(true);
    await locator<AuthenticationService>().logout('Logged Out Successfully');
    notifyListeners();
    setBusy(false);
  }
}
