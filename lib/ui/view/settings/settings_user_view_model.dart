import '../../../locator.dart';
import '../../../services/authentication_service.dart';
import '../vgts_base_view_model.dart';

class SettingsUserViewModel extends VGTSBaseViewModel {
  bool _isAuthenticated = false;

  SettingsUserViewModel() {
    init();
  }

  void init() {
    _isAuthenticated = locator<AuthenticationService>().isAuthenticated;
  }

  bool get isAuthenticated => _isAuthenticated;
}
