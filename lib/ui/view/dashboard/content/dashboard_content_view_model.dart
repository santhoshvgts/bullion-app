import 'dart:async';

import 'package:bullion/core/models/auth/user.dart';
import 'package:bullion/core/models/module/page_settings.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';

import '../../../../services/authentication_service.dart';

class DashboardContentViewModel extends VGTSBaseViewModel {
  PageSettings? pageSettings;

  List<String> bullionPaths = [
    '/pages/bullion-club-non-club',
    '/pages/bullion-club'
  ];

  bool _resumeRefresh = false;

  bool get resumeRefresh => _resumeRefresh;

  User? get user => locator<AuthenticationService>().getUser;

  bool get isAuthenticated => locator<AuthenticationService>().isAuthenticated;

  set resumeRefresh(bool value) {
    _resumeRefresh = value;
    notifyListeners();
  }

  refreshPage() async {
    resumeRefresh = true;
    await Future.delayed(const Duration(milliseconds: 300));
    resumeRefresh = false;
  }

  Search() {
    navigationService.pushNamed(Routes.search);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void init() {
    notifyListeners();
  }

  accountPage() {
    navigationService.pushNamed(Routes.settings);
  }
}
