import 'package:bullion/ui/view/settings/account_settings/change_password/change_password_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:bullion/ui/widgets/loading_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:bullion/core/enums/viewstate.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/tap_outside_unfocus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked/stacked.dart';

class ChangePasswordPage extends VGTSBuilderWidget<ChangePasswordViewModel> {

  @override
  ChangePasswordViewModel viewModelBuilder(BuildContext context) => ChangePasswordViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, ChangePasswordViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text("Change Password", style: AppTextStyle.titleMedium.copyWith(color: AppColor.text, fontFamily: AppTextStyle.fontFamily)),
      ),
      body: viewModel.isBusy ? LoadingData(loadingStyle: LoadingStyle.LOGO,) : TapOutsideUnFocus(
        child: Form(
          key: viewModel.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [

                EditTextField.password(
                  "Current Password",
                  viewModel.oldPasswordController,
                  margin: const EdgeInsets.only(top: 20),
                ),

                EditTextField.password(
                  "New Password",
                  viewModel.newPasswordController,
                  margin: const EdgeInsets.only(top: 20),
                ),

                EditTextField(
                  "Confirm Password",
                  viewModel.confirmPasswordController,
                  margin: const EdgeInsets.only(top: 20),
                ),

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: !viewModel.isBusy ? SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              boxShadow: AppStyle.topShadow,
              color: AppColor.white
          ),
          child: Button(
            "Update Password",
            valueKey: const Key("btnSaveChangePassword"),
            width: double.infinity,
            loading: viewModel.isLoading,
            onPressed: () {
              viewModel.onSaveChangePassword();
            },
          ),
        ),
      ) : null,
    );
  }

}