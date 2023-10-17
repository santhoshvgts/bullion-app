import '../../../locator.dart';
import '../../../services/authentication_service.dart';
import '../vgts_base_view_model.dart';

class SettingsUserViewModel extends VGTSBaseViewModel {
  bool _isAuthenticated = false;
  int pageNum = 1;

  SettingsUserViewModel() {
    init();
  }

  void init() {
    _isAuthenticated = locator<AuthenticationService>().isAuthenticated;
    //_pageNo = 1 ;

  }

  bool get isAuthenticated => _isAuthenticated;

  Future<void> refreshData() async {
    //setState(ViewState.Busy);

    if (locator<AuthenticationService>().isAuthenticated) {
      await locator<AuthenticationService>().getUserInfo();
    }
    notifyListeners();

    //setState(ViewState.Idle);
  }
}
