import 'dart:io';

import 'package:bullion/core/models/user_address.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:bullion/ui/widgets/tap_outside_unfocus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/res/colors.dart';
import '../../../core/res/styles.dart';
import '../../../helper/utils.dart';
import '../../widgets/animated_flexible_space.dart';
import 'add_edit_address_view_model.dart';

class AddEditAddressPage extends VGTSBuilderWidget<AddEditAddressViewModel> {
  final UserAddress? userAddress;

  const AddEditAddressPage({super.key, this.userAddress});

  @override
  void onViewModelReady(AddEditAddressViewModel viewModel) {
    viewModel.init(userAddress);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget viewBuilder(
      BuildContext context, AppLocalizations locale, viewModel, Widget? child) {
    return TapOutsideUnFocus(
      child: Scaffold(
        body: SafeArea(
            child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                icon: Platform.isAndroid
                    ? const Icon(Icons.arrow_back)
                    : const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
              ),
              expandedHeight: 100,
              pinned: true,
              flexibleSpace: AnimatedFlexibleSpace(
                  title: userAddress != null ? "Edit Address" : "Add Address"),
            ),
            SliverToBoxAdapter(
              child: viewModel.isBusy
                  ? const Align(
                      alignment: Alignment.bottomCenter,
                      child: LinearProgressIndicator())
                  /*: viewModel.userAddress == null
                      ? const Center(child: Text("No data available"))*/
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Form(
                          key: viewModel.addEditAddressGlobalKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  "Contact Details",
                                  style: AppTextStyle.titleMedium
                                      .copyWith(color: AppColor.turtleGreen),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: EditTextField(
                                      "First Name",
                                      viewModel.firstNameFormFieldController,
                                      key: const Key("txtFirstName"),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                  Expanded(
                                    child: EditTextField(
                                      "Last Name",
                                      viewModel.lastNameFormFieldController,
                                      key: const Key("txtLastName"),
                                    ),
                                  )
                                  /*Expanded(
                                    child: EditTextField(
                                      "Contact Number",
                                      viewModel.phoneFormFieldController,
                                      key: const Key("numContact"),
                                    ),
                                  )*/
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: EditTextField(
                                  "Company Name",
                                  viewModel.companyFormFieldController,
                                  key: const Key("txtCompany"),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  "Address Details",
                                  style: AppTextStyle.titleMedium
                                      .copyWith(color: AppColor.turtleGreen),
                                ),
                              ),
                              EditTextField(
                                "Street Address",
                                viewModel.streetFormFieldController,
                                key: const Key("txtStreet"),
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: EditTextField(
                                      "City",
                                      viewModel.cityFormFieldController,
                                      key: const Key("txtCity"),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        viewModel.showCountries();
                                      },
                                      child: EditTextField(
                                        "Country",
                                        viewModel.countryFormFieldController,
                                        key: const Key("txtCountry"),
                                        suffixIcon:
                                            const Icon(Icons.arrow_drop_down),
                                        enabled: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: viewModel.stateEnable ? null : () => viewModel.showStates(),
                                      child: EditTextField(
                                        "State",
                                        viewModel.stateFormFieldController,
                                        key: const Key("txtCity"),
                                        suffixIcon: viewModel.stateEnable
                                            ? Container()
                                            : const Icon(Icons.arrow_drop_down),
                                        enabled: viewModel.stateEnable,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                  Expanded(
                                    child: EditTextField(
                                      "Pin code",
                                      viewModel.pinFormFieldController,
                                      key: const Key("txtPincode"),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              EditTextField(
                                "Contact Number",
                                viewModel.phoneFormFieldController,
                                key: const Key("txtContact"),
                              ),
                              const SizedBox(height: 16.0),

                              /* //Address types - Home, Office, and Others
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                                child: Text(
                                  "Type of Address",
                                  style: AppTextStyle.titleMedium
                                      .copyWith(color: AppColor.turtleGreen),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Radio(
                                        value: AddressType.home,
                                        groupValue: viewModel.selectedAddressType,
                                        onChanged: (value) {
                                          viewModel.selectedAddressType = value!;
                                        },
                                      ),
                                      const Text("Home",
                                          style: AppTextStyle.titleSmall),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                        value: AddressType.office,
                                        groupValue: viewModel.selectedAddressType,
                                        onChanged: (value) {
                                          viewModel.selectedAddressType = value!;
                                        },
                                      ),
                                      const Text("Office",
                                          style: AppTextStyle.titleSmall),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                        value: AddressType.others,
                                        groupValue: viewModel.selectedAddressType,
                                        onChanged: (value) {
                                          viewModel.selectedAddressType = value!;
                                        },
                                      ),
                                      const Text("Others",
                                          style: AppTextStyle.titleSmall),
                                    ],
                                  ),
                                ],
                              ),*/
                              InkWell(
                                onTap: () {
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  viewModel.selectDefaultAddress();
                                },
                                child: Row(
                                  children: [
                                    Checkbox(
                                        checkColor: AppColor.white,
                                        value: viewModel.isDefaultAddress,
                                        activeColor: AppColor.primary,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        onChanged: (val) =>
                                            viewModel.selectDefaultAddress()),
                                    const SizedBox(width: 4.0),
                                    const Text(
                                      "Make this my default shipping address.",
                                      style: AppTextStyle.titleSmall,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
            )
          ],
        )),
        bottomNavigationBar: SafeArea(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                  boxShadow: AppStyle.topShadow, color: AppColor.white),
              child: Button(
                color: AppColor.sherwoodGreen,
                "Confirm and continue",
                valueKey: const Key("btnConfirm"),
                borderRadius: BorderRadius.circular(8),
                onPressed: () async {
                  if (viewModel.addEditAddressGlobalKey.currentState!
                      .validate()) {
                    bool result = await viewModel.submitAddress();
                    if (result) {
                      Util.showSnackBar(context, "Submitted successfully");
                      Navigator.of(context).pop();
                    }
                  } else {
                    Util.showSnackBar(context, "Fill all the required fields");
                  }
                },
                disabled: viewModel.isBusy,
              )),
        ),
      ),
    );
  }

  @override
  viewModelBuilder(BuildContext context) {
    return AddEditAddressViewModel();
  }
}

enum AddressType { home, office, others }
