import 'package:bullion/core/models/user_address.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:bullion/ui/widgets/tap_outside_unfocus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../core/models/google/place_autocomplete.dart';
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
                icon: Util.showArrowBackward(),
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
                              /*EditTextField(
                                "Street Address",
                                viewModel.streetFormFieldController,
                                key: const Key("txtStreet"),
                              ),*/
                              StreetAutoCompleteTextField(viewModel),
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
                                      onTap: viewModel.stateEnable
                                          ? null
                                          : () => viewModel.showStates(),
                                      child: EditTextField(
                                        "State",
                                        viewModel.stateFormFieldController,
                                        key: const Key("txtState"),
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

class StreetAutoCompleteTextField
    extends VGTSBuilderWidget<AddEditAddressViewModel> {
  AddEditAddressViewModel viewModel;

  StreetAutoCompleteTextField(this.viewModel, {super.key});

  @override
  Widget viewBuilder(
      BuildContext context, AppLocalizations locale, viewModel, Widget? child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text("Street Address",
            textScaleFactor: 1, style: AppTextStyle.labelMedium),
        const Padding(
          padding: EdgeInsets.only(top: 10),
        ),
        TypeAheadFormField<Predictions>(
          key: const Key("txtStreetAddress"),
          textFieldConfiguration: TextFieldConfiguration(
            controller: viewModel.streetTextEditingController,
            focusNode: viewModel.streetFocus,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp("[ ]{2}")),
              FilteringTextInputFormatter.deny(RegExp("[.]{2}")),
              FilteringTextInputFormatter.deny(RegExp("[,]{2}")),
            ],
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              errorText:
                  viewModel.streetValidate ? "Required Street Address" : null,
              errorMaxLines: 2,
              errorStyle:
                  AppTextStyle.bodySmall.copyWith(color: AppColor.error),
              hintStyle: const TextStyle(color: Colors.black54),
              labelStyle: (viewModel.streetFocus.hasFocus
                  ? const TextStyle(color: AppColor.primary)
                  : const TextStyle(color: Colors.black54)),
              fillColor: AppColor.white,
              filled: true,
              contentPadding: const EdgeInsets.only(
                  top: 16, bottom: 16, left: 12, right: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.black54),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.black12),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.black12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: AppColor.primary, width: 2),
              ),
              prefixStyle: AppTextStyle.bodyMedium,
            ),
          ),
          noItemsFoundBuilder: (context) {
            return Container(
              height: 0,
            );
          },
          suggestionsCallback: (pattern) async {
            List<Predictions>? predictions = await viewModel.googlePlaceApi!
                .getPredictions(
                    pattern, viewModel.shippingAddress?.availableCountries);
            return predictions!;
          },
          itemBuilder: (context, Predictions prediction) {
            return ListTile(
              title: Text(
                prediction.structuredFormatting!.mainText!,
                textScaleFactor: 1,
                style: AppTextStyle.titleMedium,
              ),
              subtitle: Text(
                prediction.structuredFormatting!.secondaryText == null
                    ? ""
                    : prediction.structuredFormatting!.secondaryText!,
                textScaleFactor: 1,
                style: AppTextStyle.bodyMedium,
              ),
            );
          },
          onSuggestionSelected: (Predictions suggestion) {
            viewModel.onStreetNameSelect(suggestion);
          },
          validator: (value) {
            if (value!.trim().isEmpty) {
              return "Street address can't be empty";
            }

            if (value.trim().length < 5) {
              return "Street address should be more than 4 letters";
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  viewModelBuilder(BuildContext context) {
    return viewModel;
  }

  @override
  bool get disposeViewModel => false;
}

enum AddressType { home, office, others }
