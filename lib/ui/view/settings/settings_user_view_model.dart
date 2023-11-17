import '../../../core/constants/module_type.dart';
import '../../../locator.dart';
import '../../../router.dart';
import '../../../services/authentication_service.dart';
import '../../../services/shared/eventbus_service.dart';
import '../vgts_base_view_model.dart';

class SettingsUserViewModel extends VGTSBaseViewModel {
  bool _isAuthenticated = false;
  int pageNum = 1;

  SettingsUserViewModel() {
    init();
  }

  void init() {
    locator<EventBusService>()
        .eventBus
        .registerTo<RefreshDataEvent>()
        .listen((event) async {
      if (event.name == RefreshType.accountRefresh) {
        initialize();
      }
    });

    initialize();
    notifyListeners();
  }

  void initialize() {
    _isAuthenticated = locator<AuthenticationService>().isAuthenticated;
    notifyListeners();
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

  showIntroScreen() {
    navigationService.pushNamed(Routes.login, arguments: {"fromMain": false});
  }
}
