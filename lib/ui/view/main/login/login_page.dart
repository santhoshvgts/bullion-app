import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/navigator_service.dart';
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
    BuildContext context,
    AppLocalizations locale,
    viewModel,
    Widget? child,
  ) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 85,
        child: Column(
          children: [
            Visibility(
              visible: fromMain,
              child: InkWell(
                key: const Key("btnContinueAsGuest"),
                onTap: () => viewModel.continueWithoutLogin(),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text("Explore as Guest",
                      
                      style: AppTextStyle.titleSmall
                          .copyWith(color: AppColor.primary)),
                ),
              ),
            ),
            VerticalSpacing.custom(value: 16),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text("@2023 Bullion.com All rights reserved",
                  
                  style: AppTextStyle.bodyMedium.copyWith(
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
            onPressed: () => locator<NavigationService>().pop(),
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
                      
                      style: AppTextStyle.headlineSmall,
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
                            placeholder: "",
                            key: const Key("txtEmailAddress"),
                            onChanged: (value) {},
                          ),
                          VerticalSpacing.custom(value: 7),
                          EditTextField.password(
                            "Password",
                            viewModel.passwordController,
                            placeholder: "",
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
                                style: AppTextStyle.titleSmall
                                    .copyWith(color: AppColor.primary)),
                          ),
                          onTap: () => viewModel.forgotPassword()),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 24)),
                    Button(
                      "Login",
                      loading: viewModel.isBusy,
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
                      progressColor: AppColor.primary,
                      loading: viewModel.busy("GOOGLE"),
                      textStyle: AppTextStyle.titleSmall
                          .copyWith(color: AppColor.text),
                      onPressed: () {
                        viewModel.googleSignIn();
                      },
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
                              style: AppTextStyle.bodyMedium.copyWith(
                                color: AppColor.text,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            HorizontalSpacing.custom(value: 8),
                            Text(
                              'Sign Up',
                              style: AppTextStyle.bodyMedium.copyWith(
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
