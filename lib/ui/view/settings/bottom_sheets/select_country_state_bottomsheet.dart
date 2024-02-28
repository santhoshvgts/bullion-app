import 'package:bullion/ui/view/settings/select_country_state_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../../../../locator.dart';
import '../../../../core/models/alert/alert_response.dart';
import '../../../../core/models/module/checkout/shipping_address.dart';
import '../../../../core/res/colors.dart';
import '../../../../core/res/images.dart';
import '../../../../core/res/spacing.dart';
import '../../../../core/res/styles.dart';
import '../../../../services/shared/dialog_service.dart';

class SelectCountryStateBottomSheet
    extends VGTSBuilderWidget<SelectCountryStateViewModel> {
  final ShippingAddress? _shippingAddress;
  final bool isCountry;

  const SelectCountryStateBottomSheet(this._shippingAddress, this.isCountry,
      {super.key});

  @override
  void onViewModelReady(SelectCountryStateViewModel viewModel) {
    viewModel.init(_shippingAddress);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget viewBuilder(BuildContext context, locale, viewModel, Widget? child) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: ListView(
        children: [
          const SearchBar(),
          ListView.separated(
            itemCount: isCountry
                ? viewModel.countryList!.length
                : viewModel.stateList!.length,
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.only(bottom: 10.0),
            separatorBuilder: (context, index) {
              return Container(
                child: AppStyle.customDivider,
              );
            },
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if (isCountry) {
                    for (var data in viewModel.countryList!) {
                      if (data.value == viewModel.countryList![index].value) {
                        viewModel.countryList![index].selected = true;
                      } else {
                        data.selected = false;
                      }
                    }
                  } else {
                    for (var data in viewModel.stateList!) {
                      if (data.value == viewModel.stateList![index].value) {
                        viewModel.stateList![index].selected = true;
                      } else {
                        data.selected = false;
                      }
                    }
                  }

                  viewModel.notifyListeners();

                  locator<DialogService>().dialogComplete(AlertResponse(
                      data: isCountry
                          ? viewModel.countryList![index]
                          : viewModel.stateList![index]));
                },
                child: Container(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 15.0, right: 15.0, bottom: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                              isCountry
                                  ? viewModel.countryList![index].text!
                                  : viewModel.stateList![index].text!,
                              
                              style: AppTextStyle.bodyMedium,
                              textAlign: TextAlign.start,
                            )),
                        if (isCountry
                            ? viewModel.countryList![index].selected!
                            : viewModel.stateList![index].selected!)
                          const Icon(
                            Icons.check,
                            color: AppColor.primary,
                            size: 22,
                          ),
                      ],
                    )),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  SelectCountryStateViewModel viewModelBuilder(BuildContext context) {
    return SelectCountryStateViewModel();
  }
}

class SearchBar extends ViewModelWidget<SelectCountryStateViewModel> {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context, SelectCountryStateViewModel viewModel) {
    return Container(
      height: 35,
      margin: const EdgeInsets.only(
          right: 15.0, left: 10.0, bottom: 10.0, top: 5.0),
      padding: const EdgeInsets.only(left: 10.0),
      decoration: const BoxDecoration(
          color: AppColor.secondaryBackground,
          borderRadius: BorderRadius.all(Radius.circular(7.0))),
      child: Row(
        children: [
          Image.asset(
            Images.search,
            width: 15,
          ),
          HorizontalSpacing.d10px(),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search',
                fillColor: AppColor.secondaryBackground,
                hintStyle: AppTextStyle.titleSmall.copyWith(fontSize: 15),
                contentPadding: const EdgeInsets.only(bottom: 13.0),
              ),
              controller: viewModel.searchController,
              focusNode: viewModel.searchFocus,
              autofocus: true,
              textAlign: TextAlign.start,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.search,
              onChanged: (val) {
                viewModel.notifyListeners();
              },
              onSubmitted: (val) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
          ),
        ],
      ),
    );
  }
}