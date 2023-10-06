import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/view/main/login/login_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:bullion/ui/widgets/tap_outside_unfocus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends VGTSBuilderWidget<LoginViewModel> {
  final bool fromMain;
  final String? redirectRoute;

  const LoginPage({super.key, this.fromMain = true, this.redirectRoute});

  @override
  LoginViewModel viewModelBuilder(BuildContext context) =>
      LoginViewModel(fromMain, redirectRoute);

  @override
  Widget viewBuilder(
      BuildContext context, AppLocalizations locale, viewModel, Widget? child) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 85,
        child: Column(
          children: [
            InkWell(
              key: const Key("btnContinueAsGuest"),
              onTap: () => viewModel.continueWithoutLogin(),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text("Explore as Guest",
                    textScaleFactor: 1,
                    style: AppTextStyle.buttonSecondary
                        .copyWith(color: AppColor.primary)),
              ),
            ),
            VerticalSpacing.custom(value: 16),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text("@2023 Bullion.com All rights reserved",
                  textScaleFactor: 1,
                  style: AppTextStyle.normal.copyWith(
                      fontSize: 12,
                      color: AppColor.primaryText,
                      fontWeight: FontWeight.w500)),
            ),
            VerticalSpacing.custom(value: 5),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () => navigationService.pop(),
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: TapOutsideUnFocus(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        Images.appLogo,
                        height: 30.0,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 12)),
                    const Text(
                      "Welcome back",
                      textScaleFactor: 1,
                      style: AppTextStyle.header,
                    ),
                    VerticalSpacing.custom(value: 70),
                    Form(
                      key: viewModel.formKey,
                      child: AutofillGroup(
                          child: Column(
                        children: [
                          EditTextField(
                            "Email Address",
                            viewModel.emailController,
                            placeholder: "john@bullion.com",
                            key: const Key("txtEmailAddress"),
                            onChanged: (value) {},
                          ),
                          VerticalSpacing.custom(value: 14),
                          EditTextField.password(
                            "Password",
                            viewModel.passwordController,
                            placeholder: "********",
                            margin: const EdgeInsets.only(top: 25),
                            onSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (value) {},
                          ),
                        ],
                      )),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                          key: const Key("btnForgotPassword"),
                          child: Container(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Text("Forgot your Password?",
                                textScaleFactor: 1,
                                style: AppTextStyle.buttonSecondary
                                    .copyWith(color: AppColor.primary)),
                          ),
                          onTap: () => viewModel.forgotPassword()),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 24)),
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
                      textStyle: AppTextStyle.buttonSecondary
                          .copyWith(color: AppColor.text),
                      onPressed: () {},
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15)),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        onTap: viewModel.register,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don’t have an account ?',
                              style: AppTextStyle.normal.copyWith(
                                color: AppColor.text,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            HorizontalSpacing.custom(value: 8),
                            Text(
                              'Sign Up',
                              style: AppTextStyle.normal.copyWith(
                                color: AppColor.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              VerticalSpacing.custom(value: 5),
            ],
          ),
        ),
      ),
    );
  }
}
