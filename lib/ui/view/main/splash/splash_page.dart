import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'splash_view_model.dart';

class SplashPage extends VGTSBuilderWidget<SplashViewModel> {
  const SplashPage({Key? key}) : super(key: key);

  @override
  SplashViewModel viewModelBuilder(BuildContext context) => SplashViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, SplashViewModel viewModel, Widget? child) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light),
          toolbarHeight: 0,
          backgroundColor: AppColor.primary,
        ),
        backgroundColor: AppColor.primary,
        body: Center(
          child: Image.asset(Images.appLogo, fit: BoxFit.fitWidth, width: MediaQuery.of(context).size.width / 2),
        ));
  }
}
