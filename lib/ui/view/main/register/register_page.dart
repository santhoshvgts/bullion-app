import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/navigator_service.dart';
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
  RegisterViewModel viewModelBuilder(BuildContext context) =>
      RegisterViewModel(fromMain, redirectRoute);

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      RegisterViewModel viewModel, Widget? child) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              onPressed: () => locator<NavigationService>().pop(),
              icon: const Icon(Icons.arrow_back)),
        ),
        body: SafeArea(
            child: TapOutsideUnFocus(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              VerticalSpacing.custom(value: 21),
              Text(
                'Create Account',
                style: AppTextStyle.bodyMedium
                    .copyWith(fontSize: 24, color: AppColor.text),
              ),
              VerticalSpacing.custom(value: 45),
              Form(
                  key: viewModel.formKey,
                  child: Column(
                    children: [
                      EditTextField(
                        "First Name",
                        viewModel.nameController,
                        placeholder: "",
                        onSubmitted: (value) {},
                        onChanged: (value) {},
                      ),
                      VerticalSpacing.custom(value: 28),
                      EditTextField(
                        "Last Name",
                        viewModel.lnameController,
                        placeholder: '',
                        onSubmitted: (value) {},
                        onChanged: (value) {},
                      ),
                      VerticalSpacing.custom(value: 28),
                      EditTextField(
                        "Email Address",
                        viewModel.emailController,
                        placeholder: "",
                        onSubmitted: (value) {},
                        onChanged: (value) {},
                      ),
                      VerticalSpacing.custom(value: 28),
                      EditTextField.password(
                        "Password",
                        viewModel.passwordController,
                        placeholder: "",
                        onSubmitted: (value) {
                          FocusScope.of(context).requestFocus(viewModel.confirmPasswordController.focusNode);
                        },
                        onChanged: (value) {},
                      ),
                      VerticalSpacing.custom(value: 28),

                      EditTextField.password(
                        "Confirm Password",
                        viewModel.confirmPasswordController,
                        placeholder: "",
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
                loading: viewModel.isBusy,
                onPressed: () => viewModel.register(context),
              ),
              VerticalSpacing.d15px(),
              Center(
                  child: Text(
                '--------   Or sign in with   --------',
                style: AppTextStyle.bodyMedium
                    .copyWith(color: AppColor.secondaryText, fontSize: 12),
              )),
              VerticalSpacing.d15px(),
              Button.outline(
                "Continue with Google",
                valueKey: const Key('btnGoogle'),
                progressColor: AppColor.primary,
                iconWidget: Image.asset(
                  Images.googleIcon,
                  height: 20,
                ),
                textStyle: AppTextStyle.titleSmall.copyWith(color: AppColor.text),
                onPressed: () {
                  viewModel.googleSignIn();
                },
              ),
            ],
          ),
        )));
  }
}
