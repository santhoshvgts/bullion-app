import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/fontsize.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/view/main/login/login_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:bullion/ui/widgets/tap_outside_unfocus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends VGTSBuilderWidget<LoginViewModel> {
  final bool fromMain;
  final String? redirectRoute;

  LoginPage({this.fromMain = true, this.redirectRoute});

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel(fromMain, redirectRoute);

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, viewModel, Widget? child) {
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
      body: SafeArea(
        child: TapOutsideUnFocus(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  Images.appLogo,
                  height: 30.0,
                ),
              ),

              const Padding(padding: EdgeInsets.only(top: 15)),

              const Text(
                "Welcome back",
                textScaleFactor: 1,
                style: AppTextStyle.header,
              ),

              const Padding(padding: EdgeInsets.only(top: 40)),

              AutofillGroup(
                  child: Column(
                children: [
                  EditTextField(
                    "Email Address",
                    viewModel.emailController,
                    placeholder: "john@bullion.com",
                    onSubmitted: (value) {},
                    onChanged: (value) {},
                  ),
                  EditTextField.password(
                    "Password",
                    viewModel.passwordController,
                    placeholder: "********",
                    margin: const EdgeInsets.only(top: 25),
                    onSubmitted: (value) {},
                    onChanged: (value) {},
                  ),
                ],
              )),

              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                    key: const Key("btnForgotPassword"),
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: const Text("Forgot your Password?", textScaleFactor: 1, style: AppTextStyle.buttonSecondary),
                    ),
                    onTap: () => viewModel.forgotPassword()),
              ),

              const Padding(padding: EdgeInsets.only(top: 20)),

              Button(
                "Login",
                valueKey: const Key("btnSignIn"),
                onPressed: () => viewModel.login(),
              ),

              VerticalSpacing.d15px(),

              Button.outline(
                "Continue with Google",
                valueKey: const Key('btnGoogle'),
                iconWidget: Image.asset(
                  Images.googleIcon,
                  height: 20,
                ),
                textStyle: AppTextStyle.buttonSecondary.copyWith(color: AppColor.text),
                onPressed: () => viewModel.continueWithoutLogin(),
              ),

              VerticalSpacing.d15px(),

              Button.outline(
                "Continue with Facebook",
                valueKey: const Key('btnFacebook'),
                iconWidget: Image.asset(
                  Images.googleIcon,
                  height: 20,
                ),
                textStyle: AppTextStyle.buttonSecondary.copyWith(color: AppColor.text),
                onPressed: () => viewModel.continueWithoutLogin(),
              ),

              const Padding(padding: EdgeInsets.only(top: 10)),

              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     const Text(
              //       "Don't have an Account?",
              //       textScaleFactor: 1,
              //       style: AppTextStyle.text,
              //     ),
              //     TextButton(
              //         key: const Key("btnRegister"),
              //         child: const Text("Register",
              //             textScaleFactor: 1,
              //             style: AppTextStyle.buttonSecondary),
              //         onPressed: () => viewModel.register()),
              //   ],
              // ),

              if (fromMain)
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    key: const Key("btnContinueAsGuest"),
                    onTap: () => viewModel.continueWithoutLogin(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: const Text("Explore as Guest", textScaleFactor: 1, style: AppTextStyle.buttonSecondary),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
