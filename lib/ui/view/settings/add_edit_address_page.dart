import 'package:bullion/core/models/user_address.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/navigator_service.dart';
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
import '../../widgets/loading_data.dart';
import 'add_edit_address_view_model.dart';

class AddEditAddressPage extends VGTSBuilderWidget<AddEditAddressViewModel> {
  final UserAddress? userAddress;
  final bool? fromCheckout;

  const AddEditAddressPage({super.key, this.userAddress, this.fromCheckout = false });

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
                  flexibleSpace: AnimatedFlexibleSpace.withoutTab(
                      title: userAddress != null ? "Edit Address" : "Add Address"),
                ),
                SliverToBoxAdapter(
                  child: viewModel.isBusy
                      ? LoadingData(loadingStyle: LoadingStyle.LOGO,) : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Form(
                              key: viewModel.addEditAddressGlobalKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  VerticalSpacing.d10px(),

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
                                    const EdgeInsets.only(top: 16.0),
                                    child: Text(
                                      "Address Details",
                                      style: AppTextStyle.titleMedium.copyWith(color: AppColor.primary),
                                    ),
                                  ),

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
                "Save Address",
                valueKey: const Key("btnConfirm"),
                onPressed: () async {
                  if (viewModel.addEditAddressGlobalKey.currentState!
                      .validate()) {
                    bool result = await viewModel.submitAddress();
                    if (result) {
                      Util.showSnackBar(context, "Address updated successfully");
                      locator<NavigationService>().pop(returnValue: true);
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
    return AddEditAddressViewModel(fromCheckout);
  }
}

class StreetAutoCompleteTextField
    extends VGTSBuilderWidget<AddEditAddressViewModel> {
  final AddEditAddressViewModel viewModel;

  const StreetAutoCompleteTextField(this.viewModel, {super.key});

  @override
  Widget viewBuilder(
      BuildContext context, AppLocalizations locale, viewModel, Widget? child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text("Street Address", style: AppTextStyle.labelMedium),
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
              errorStyle: AppTextStyle.bodySmall.copyWith(color: AppColor.error),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              fillColor: Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
              alignLabelWithHint: true,
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
                style: AppTextStyle.titleMedium,
              ),
              subtitle: Text(
                prediction.structuredFormatting!.secondaryText == null
                    ? ""
                    : prediction.structuredFormatting!.secondaryText!,
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