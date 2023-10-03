import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/shared/loading_widget.dart';
import 'package:bullion/ui/view/main/register/register_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:bullion/ui/widgets/tap_outside_unfocus.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends VGTSBuilderWidget<RegisterViewModel> {
  final bool fromMain;
  final String? redirectRoute;

  const RegisterPage({super.key, this.fromMain = true, this.redirectRoute});

  @override
  RegisterViewModel viewModelBuilder(BuildContext context) => RegisterViewModel(fromMain, redirectRoute);

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, RegisterViewModel viewModel, Widget? child) {
    return viewModel.isBusy
        ? LoadingWidget(
            message: "Registering..",
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(onPressed: () => locator<NavigationService>().pop(), icon: const Icon(Icons.arrow_back)),
            ),
            body: SafeArea(
                child: TapOutsideUnFocus(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  VerticalSpacing.custom(value: 21),
                  Text(
                    'Create Account',
                    style: AppTextStyle.normal.copyWith(fontSize: 24, color: AppColor.text),
                  ),
                  VerticalSpacing.custom(value: 45),
                  Form(
                      key: viewModel.formKey,
                      child: Column(
                        children: [
                          EditTextField(
                            "First Name",
                            viewModel.nameController,
                            placeholder: "john",
                            onSubmitted: (value) {},
                            onChanged: (value) {},
                          ),
                          VerticalSpacing.custom(value: 40),
                          EditTextField(
                            "Last Name",
                            viewModel.lnameController,
                            placeholder: 'Paul',
                            onSubmitted: (value) {},
                            onChanged: (value) {},
                          ),
                          VerticalSpacing.custom(value: 40),
                          EditTextField(
                            "Email Address",
                            viewModel.emailController,
                            placeholder: "john@bullion.com",
                            onSubmitted: (value) {},
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
                  VerticalSpacing.custom(value: 28),
                  Button(
                    "Create Account",
                    valueKey: const Key("btnSignIn"),
                    onPressed: () => viewModel.register(context),
                  ),
                  VerticalSpacing.d15px(),
                  Center(
                      child: Text(
                    '--------   Or sign in with   --------',
                    style: AppTextStyle.normal.copyWith(color: AppColor.secondaryText, fontSize: 12),
                  )),
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
                ],
              ),
            )));
  }
}
