import 'package:bullion/core/models/module/selected_item_list.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/view/settings/account_settings/profile/profile_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/dropdown.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:bullion/ui/widgets/loading_data.dart';
import 'package:flutter/material.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/tap_outside_unfocus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends VGTSBuilderWidget<ProfileViewModel> {

  @override
  ProfileViewModel viewModelBuilder(BuildContext context) => ProfileViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, ProfileViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text("Profile", style: AppTextStyle.titleMedium.copyWith(color: AppColor.text, fontFamily: AppTextStyle.fontFamily)),
      ),
      body: viewModel.isBusy ? LoadingData(loadingStyle: LoadingStyle.LOGO,) : TapOutsideUnFocus(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: viewModel.formKey,
            child: AutofillGroup(
              child: Column(
                children: [

                  DropdownField<SelectedItemList>(
                    "Salutation *",
                    viewModel.salutationController,
                    margin: const EdgeInsets.only(top: 30),
                    onChange: (SelectedItemList? data) {
                    },
                  ),

                  EditTextField(
                    "First Name *",
                    viewModel.nameController,
                    margin: const EdgeInsets.only(top: 20),

                  ),

                  EditTextField(
                    "Last Name *",
                    viewModel.lnameController,
                    margin: const EdgeInsets.only(top: 20),

                  ),

                  EditTextField(
                    "Phone No",
                    viewModel.phoneNoController,
                    margin: const EdgeInsets.only(top: 20),

                  ),

                  EditTextField(
                    "Alternative Phone No",
                    viewModel.alternativePhoneNoController,
                    margin: const EdgeInsets.only(top: 20),

                  ),

                  EditTextField(
                    "Company Name",
                    viewModel.companyNameController,
                    margin: const EdgeInsets.only(top: 20),

                  ),

                ],
              ),
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
            "Save Profile",
            valueKey: const Key("btnSaveProfile"),
            width: double.infinity,
            loading: viewModel.isLoading,
            onPressed: ()=> viewModel.onSaveProfile(),
          ),
        ),
      ) : null,
    );
  }

}