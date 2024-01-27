import 'package:bullion/core/models/auth/user.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:bullion/services/page_storage_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/shared/account_button.dart';
import 'package:bullion/ui/shared/cart/cart_button.dart';
import 'package:bullion/ui/shared/search_card_section.dart';
import 'package:bullion/ui/view/core/content_wrapper.dart';
import 'package:bullion/ui/view/dashboard/content/dashboard_content_view_model.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/page_will_pop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

class DashboardContentPage extends StatelessWidget {
  final String? path;

  DashboardContentPage({key, this.path}) : super(key: key);

  // final double _searchBarHeight = 35;
  // final double _appBarCollapsedHeight = kToolbarHeight;
  double? _appBarExtendedHeight;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardContentViewModel>.reactive(
      onViewModelReady: (viewModel) {
        viewModel.init();
      },
      onDispose: (viewModel) {},
      builder: (context, viewModel, child) {
        if (path == '/pages/home') {
          return PageWillPop(
            child: Scaffold(
              backgroundColor: AppColor.secondaryBackground,
              floatingActionButton: StreamBuilder(
                initialData: locator<AuthenticationService>().getUser,
                stream: locator<AuthenticationService>().userController.stream,
                builder: (context, snapshot) {
                  if (locator<AuthenticationService>().isAuthenticated) {
                    return Container();
                  }
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColor.black.withOpacity(0.8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            "Sign in for the best experience.",
                            textScaleFactor: 1,
                            style: AppTextStyle.bodySmall.copyWith(
                              color: AppColor.white,
                            ),
                          ),
                        ),
                        Button(
                          "Sign In",
                          width: 90,
                          height: 30,
                          textStyle: AppTextStyle.bodySmall.copyWith(
                            color: AppColor.white,
                          ),
                          valueKey: const ValueKey("btnSignIn"),
                          onPressed: () {
                            locator<NavigationService>().pushNamed(
                              Routes.login,
                              arguments: {"fromMain": false},
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return <Widget>[
                    SliverLayoutBuilder(builder: (context, constraints) {
                      return SliverAppBar(
                        backgroundColor: AppColor.white,
                        titleSpacing: 0,
                        expandedHeight: 105,
                        floating: false,
                        pinned: true,
                        forceElevated: true,
                        elevation: 1,
                        shadowColor: AppColor.secondaryBackground,
                        flexibleSpace: FlexibleSpaceBar.createSettings(
                          currentExtent: 60,
                          minExtent: 60,
                          toolbarOpacity: 1.0,
                          child: LayoutBuilder(
                            builder: (
                              context,
                              constraints,
                            ) {
                              _appBarExtendedHeight ??=
                                  80 - constraints.biggest.height;

                              return FlexibleSpaceBar(
                                centerTitle: true,
                                titlePadding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 10.0,
                                ),
                                title: SearchCardSection(
                                  rightPadding: 45 -
                                      ((15 - 45) *
                                          ((constraints.biggest.height - 80) /
                                              _appBarExtendedHeight!)),
                                ),
                                background: AppBar(
                                  backgroundColor: AppColor.white,
                                  centerTitle: false,
                                  elevation: 1,
                                  shadowColor: AppColor.secondaryBackground,
                                  title: Image.asset(
                                    Images.appLogo,
                                    height: 20,
                                  ),
                                  systemOverlayStyle:
                                      const SystemUiOverlayStyle(
                                    statusBarIconBrightness: Brightness.dark,
                                    statusBarColor: AppColor.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        actions: const [
                          CartButton.light()
                        ],
                      );
                    })
                  ];
                },
                body: _BodyContent(path ?? '', key!),
              ),
            ),
          );
        } else {
          return PageWillPop(
            child: Scaffold(
              appBar: _AppBar(path: path ?? ''),
              body: _BodyContent(path ?? '', key!),
            ),
          );
        }
      },
      viewModelBuilder: () => DashboardContentViewModel(),
    );
  }
}

class _AppBar extends PreferredSize {
  final String path;

  _AppBar({
    required this.path,
  }) : super(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBar(
              backgroundColor: AppColor.white,
              titleSpacing: 0,
              elevation: 1,
              shadowColor: AppColor.secondaryBackground,
              title: SearchCardSection(
                rightPadding: 0,
              ),
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.dark,
                statusBarColor: AppColor.white,
              ),
              actions: const [  CartButton.light() ],
            ));
}

class _BodyContent extends ViewModelWidget<DashboardContentViewModel> {
  String path;
  Key pageKey;

  _BodyContent(this.path, this.pageKey);

  @override
  Widget build(BuildContext context, DashboardContentViewModel viewModel) {
    return ContentWrapper(path,
        enableController: false,
        initialValue: locator<PageStorageService>().read(context, pageKey),
        backgroundColor: path == "/spot-prices" ? AppColor.primary : null,
        onPageFetched: (pageSetting) {
          viewModel.pageSettings = pageSetting;
          locator<PageStorageService>()
              .write(context, pageKey, viewModel.pageSettings);
          viewModel.notifyListeners();
        });
  }
}

class CustomFloatingActionButtonAnimator extends FloatingActionButtonAnimator {
  @override
  Offset getOffset(
      {required Offset begin, required Offset end, required double progress}) {
    // You can customize the animation here
    double curveValue = Curves.easeInOut.transform(progress);
    return Offset.lerp(begin, end, curveValue)!;
  }

  @override
  Animation<double> getRotationAnimation({required Animation<double> parent}) {
    // You can customize the rotation animation here
    return CurvedAnimation(parent: parent, curve: Curves.easeInOut);
  }

  @override
  Animation<double> getScaleAnimation({required Animation<double> parent}) {
    // You can customize the scale animation here
    return CurvedAnimation(parent: parent, curve: Curves.easeInOut);
  }
}
