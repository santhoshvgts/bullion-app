import 'package:bullion/core/res/colors.dart';
import 'package:bullion/ui/view/main/register/register_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends VGTSBuilderWidget<RegisterViewModel> {
  final bool fromMain;
  final String? redirectRoute;

  const RegisterPage({ super.key,  this.fromMain = true, this.redirectRoute });

  @override
  RegisterViewModel viewModelBuilder(BuildContext context) => RegisterViewModel(fromMain, redirectRoute);

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, RegisterViewModel viewModel, Widget? child) {
    return const Scaffold(
      body: Center(child: Text("Register"),),
    );
  }

}
