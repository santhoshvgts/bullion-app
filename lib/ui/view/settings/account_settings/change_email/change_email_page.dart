

import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/tap_outside_unfocus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked/stacked.dart';

import 'change_email_view_model.dart';

class ChangeEmailPage extends VGTSBuilderWidget<ChangeEmailViewModel> {

  @override
  ChangeEmailViewModel viewModelBuilder(BuildContext context) => ChangeEmailViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, ChangeEmailViewModel viewModel, Widget? child) {

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text("Change Email", style: AppTextStyle.titleMedium.copyWith(color: AppColor.text, fontFamily: AppTextStyle.fontFamily)),
      ),
      body: viewModel.isBusy ? SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const Center(
          child: SizedBox(
            height: 80,
            width: 80,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColor.primary),
            ),
          ),
        ),
      ) : TapOutsideUnFocus(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              children: [

                EditTextField(
                  "Current Email Address",
                  viewModel.oldEmailController,
                  margin: const EdgeInsets.only(top: 20),
                  enabled: false,
                ),

                EditTextField(
                  "New Email Address",
                  viewModel.newEmailController,
                  margin: const EdgeInsets.only(top: 20),
                ),

                EditTextField(
                  "Confirm Email Address",
                  viewModel.confirmEmailController,
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
            "Update Email",
            valueKey: const Key("btnSaveChangeEmail"),
            width: double.infinity,
            loading: viewModel.isLoading,
            onPressed: (){
              FocusScope.of(context).requestFocus(FocusNode());
              viewModel.onSaveChangeEmail();
            },
          ),
        ),
      ) : null,
    );
  }

}

