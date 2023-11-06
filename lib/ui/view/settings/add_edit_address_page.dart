import 'dart:io';

import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/res/colors.dart';
import '../../../core/res/styles.dart';
import '../../widgets/animated_flexible_space.dart';
import 'add_edit_address_view_model.dart';

class AddEditAddressPage extends VGTSBuilderWidget<AddEditAddressViewModel> {
  @override
  void onViewModelReady(AddEditAddressViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget viewBuilder(
      BuildContext context, AppLocalizations locale, viewModel, Widget? child) {
    return Scaffold(
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
            flexibleSpace: const AnimatedFlexibleSpace(title: "Add Address"),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              "Contact Details",
                              style: AppTextStyle.titleMedium
                                  .copyWith(color: AppColor.turtleGreen),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: EditTextField(
                                  "Name",
                                  viewModel.addressFormController,
                                  key: Key("txtName"),
                                ),
                              ),
                              const SizedBox(
                                width: 16.0,
                              ),
                              Expanded(
                                child: EditTextField(
                                  "Contact Number",
                                  viewModel.addressFormController,
                                  key: Key("txtNumber"),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              "Address Details",
                              style: AppTextStyle.titleMedium
                                  .copyWith(color: AppColor.turtleGreen),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: EditTextField(
                                  "Pincode",
                                  viewModel.addressFormController,
                                  key: Key("txtName"),
                                ),
                              ),
                              const SizedBox(
                                width: 16.0,
                              ),
                              Expanded(
                                child: EditTextField(
                                  "City",
                                  viewModel.addressFormController,
                                  key: Key("txtCity"),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          EditTextField(
                            "State",
                            viewModel.addressFormController,
                            key: Key("txtState"),
                          ),
                          const SizedBox(height: 16.0),
                          EditTextField(
                            "Locality / Area / Street",
                            viewModel.addressFormController,
                            key: Key("txtLocality"),
                          ),
                          const SizedBox(height: 16.0),
                          EditTextField(
                            "Flat no / Building Name",
                            viewModel.addressFormController,
                            key: Key("txtBuilding"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                          ),
                          InkWell(
                            onTap: () {
                              FocusManager.instance.primaryFocus!.unfocus();
                              //viewModel.selectDefaultAddress();
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
              valueKey: Key("btnConfirm"),
              borderRadius: BorderRadius.circular(8),
              onPressed: () {},
              disabled: viewModel.isBusy,
            )),
      ),
    );
  }

  @override
  viewModelBuilder(BuildContext context) {
    return AddEditAddressViewModel();
  }
}

enum AddressType { home, office, others }
