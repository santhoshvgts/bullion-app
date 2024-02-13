import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:bullion/ui/widgets/loading_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/shared/loading_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/tap_outside_unfocus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'guest_login_view_model.dart';

class GuestLoginPage extends VGTSBuilderWidget<GuestLoginViewModel> {
  final bool fromMain;

  GuestLoginPage({this.fromMain = true});

  @override
  void onViewModelReady(GuestLoginViewModel viewModel) {
    viewModel.init(fromMain);
    super.onViewModelReady(viewModel);
  }


  @override
  GuestLoginViewModel viewModelBuilder(BuildContext context) => GuestLoginViewModel();

  @override
  Widget builder(BuildContext context, GuestLoginViewModel viewModel, Widget? child) {
  return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                viewModel.navigationService.pop(returnValue: false);
              }),
        ),
        body: viewModel.isBusy
            ? const LoadingSection()
            : Form(
          key: viewModel.formKey,
          child: SafeArea(
            child: TapOutsideUnFocus(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      Images.appLogo,
                      height: 40.0,
                    ),
                  ),

                  const Padding(padding: EdgeInsets.only(top: 35)),

                  const Text(
                    "Proceed to checkout and you will have an opportunity to create an account at the end if one does not already exist for you.",
                    style: AppTextStyle.bodyMedium,
                  ),

                  EditTextField(
                    "Email Address",
                    viewModel.emailController,
                    margin: const EdgeInsets.only(top: 30),
                    autoFocus: true,
                  ),

                  const Padding(padding: EdgeInsets.only(top: 20)),

                  Button(
                    "Continue as Guest",
                    valueKey: const Key("btnSignIn"),
                    onPressed: () => viewModel.login(),
                  ),

                  const Padding(padding: EdgeInsets.only(top: 10)),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Don't have an Account?",
                        style: AppTextStyle.bodySmall,
                      ),
                      TextButton(
                          key: const Key("btnRegister"),
                          child: const Text("Register",
                              style: AppTextStyle.bodyMedium),
                          onPressed: () => viewModel.register()),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      );
  }

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, GuestLoginViewModel viewModel, Widget? child) {
    // TODO: implement viewBuilder
    throw UnimplementedError();
  }
}
