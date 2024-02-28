import 'package:bullion/services/authentication_service.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/view/main/guest_register/guest_register_bottom_sheet.dart';

import '../../../core/constants/module_type.dart';
import '../../../locator.dart';
import '../../../router.dart';
import '../../../services/shared/eventbus_service.dart';
import '../vgts_base_view_model.dart';

class SettingsUserViewModel extends VGTSBaseViewModel {
  bool _isAuthenticated = false;
  bool isGuestUser = false;
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
    _isAuthenticated = authenticationService.isAuthenticated;
    notifyListeners();
  }

  bool get isAuthenticated => _isAuthenticated;

  Future<void> refreshData() async {
    if (authenticationService.isAuthenticated) {
      await authenticationService.getUserInfo();
      isGuestUser = locator<AuthenticationService>().isGuestUser;
    }
    notifyListeners();
  }

  showIntroScreen() {
    navigationService.pushNamed(Routes.login, arguments: {"fromMain": false});
  }

  onGuestRegisterClick() async {
    var alertResponse = await locator<DialogService>().showBottomSheet(
        title: "Register As User",
        child: const GuestRegisterBottomSheet()
    );

    if (alertResponse.status == true) {
      refreshData();
    }
  }
}