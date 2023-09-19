import 'dart:async';
import 'dart:ui';
import 'package:bullion/core/models/auth/user.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:bullion/core/models/module/page_settings.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import '../../../../services/authentication_service.dart';

class DashboardContentViewModel extends VGTSBaseViewModel {

  PageSettings? pageSettings;

  List<String> bullionPaths = [
    '/pages/bullion-club-non-club' ,
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
    await Future.delayed(Duration(milliseconds: 300));
    resumeRefresh = false;
  }

  Search() {
    navigationService.pushNamed(Routes.search);
    notifyListeners();
  }


  final ScrollController scrollController = ScrollController();

  double currentExtent = 0.0;
  double get minExtent => 0.0;
  double get maxExtent => scrollController.position.maxScrollExtent;
  double get deltaExtent => maxExtent - minExtent;



  double titlePaddingHorizontal = 15;
  double titlePaddingTop = 15;

  final Tween<double> titlePaddingHorizontalTween = Tween(begin: 15, end: 60);
  final Tween<double> titlePaddingTopTween = Tween(begin: 15, end: 20);

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  _scrollListener() {
      currentExtent = scrollController.offset;
      titlePaddingHorizontal = _remapCurrentExtent(titlePaddingHorizontalTween);
      titlePaddingTop = _remapCurrentExtent(titlePaddingTopTween);
      notifyListeners();
  }

  double _remapCurrentExtent(Tween<double> target) {
    final double? deltaTarget = target.end! - target.begin!;

    double? currentTarget = (((currentExtent - minExtent) * deltaTarget!) / deltaExtent) + target.begin!;
    double? t = (currentTarget - target.begin!) / deltaTarget;

    double? curveT =  Curves.easeOutCubic.transform(t <= 1.0 ? t : 1.0);

    return lerpDouble(target.begin!, target.end!, curveT)!;
  }

  void init() {
    scrollController.addListener(_scrollListener);
    notifyListeners();
  }

  accountPage() {
    navigationService.pushNamed(Routes.settings);
  }
}
