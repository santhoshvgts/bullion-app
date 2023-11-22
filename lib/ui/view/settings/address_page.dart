import 'package:bullion/core/res/colors.dart';
import 'package:bullion/ui/widgets/animated_flexible_space.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/res/styles.dart';
import '../../../helper/utils.dart';
import '../../../locator.dart';
import '../../../router.dart';
import '../../../services/shared/navigator_service.dart';
import '../../widgets/loading_data.dart';
import '../vgts_builder_widget.dart';
import 'address_view_model.dart';

class AddressPage extends VGTSBuilderWidget<AddressViewModel> {
  const AddressPage({super.key});

  @override
  void onViewModelReady(AddressViewModel viewModel) {
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
              icon: Util.showArrowBackward(),
              onPressed: () {
                Navigator.of(context).maybePop();
              },
            ),
            actions: <Widget>[
              Button(
                "Add Address",
                valueKey: const Key("addAddress"),
                onPressed: () {
                  locator<NavigationService>().pushNamed(Routes.addEditAddress);
                },
                iconWidget: Icon(Icons.add, color: AppColor.cyanBlue),
                color: AppColor.white,
                borderColor: AppColor.white,
                textStyle:
                    AppTextStyle.titleSmall.copyWith(color: AppColor.cyanBlue),
              )
            ],
            expandedHeight: 100,
            pinned: true,
            flexibleSpace: const AnimatedFlexibleSpace(title: "Address"),
          ),
          SliverToBoxAdapter(
            child: viewModel.isBusy
                ? LoadingData(
              loadingStyle: LoadingStyle.LOGO,
            )
                : viewModel.hasNoData
                    ? const Center(child: Text("No data available"))
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(viewModel.defaultAddress != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      "Default Address",
                                      style: AppTextStyle.titleSmall
                                          .copyWith(color: AppColor.primaryText),
                                    ),
                                  ),
                                  getAddressLayout(viewModel, 0, context,
                                      isDefault: true),
                                ],
                              ),
                              if(viewModel.userAddress != null && viewModel.userAddress!.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      "Other Address",
                                      style: AppTextStyle.titleSmall
                                          .copyWith(color: AppColor.primaryText),
                                    ),
                                  ),
                                  Column(
                                      children:
                                      getAddressLayoutList(viewModel, context))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
          )
        ],
      )),
    );
  }

  @override
  viewModelBuilder(BuildContext context) {
    return AddressViewModel();
  }

  Widget getAddressLayout(
      AddressViewModel viewModel, int index, BuildContext context,
      {bool isDefault = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        //height: isDefault ? 192 : 176,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: AppColor.border),
          boxShadow: AppStyle.elevatedCardShadow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: isDefault,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  //height: 32,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: AppColor.mintGreen,
                    //boxShadow: AppStyle.elevatedCardShadow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Default",
                    style:
                        AppTextStyle.titleSmall.copyWith(color: AppColor.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                isDefault
                    ? viewModel.defaultAddress?.name ?? ""
                    : viewModel.userAddress?[index].name ?? "",
                style: AppTextStyle.titleSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                isDefault
                    ? viewModel.defaultAddress?.formattedFullAddress ?? ""
                    : viewModel.userAddress?[index].formattedFullAddress ?? "",
                style: AppTextStyle.titleSmall
                    .copyWith(color: AppColor.primaryText),
              ),
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.phone_outlined, size: 20),
                ),
                Text(isDefault
                    ? viewModel.defaultAddress?.primaryPhone ?? ""
                    : viewModel.userAddress?[index].primaryPhone ?? ""),
              ],
            ),
            const Divider(
              thickness: 1,
              color: AppColor.border,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text('Delete'),
                        content:
                            const Text("Do you want to delete this Address?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              isDefault ? viewModel.deleteAddress(
                                  viewModel.defaultAddress!.id!) :
                              viewModel.deleteAddress(
                                  viewModel.userAddress![index].id!);
                              Navigator.pop(context, 'OK');
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 4.0),
                        child: Icon(
                          Icons.delete,
                          color: AppColor.redOrange,
                        ),
                      ),
                      Text(
                        "Delete",
                        style: AppTextStyle.titleSmall
                            .copyWith(color: AppColor.redOrange),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                InkWell(
                  onTap: () {
                    locator<NavigationService>().pushNamed(Routes.addEditAddress, arguments: isDefault ? viewModel.defaultAddress : viewModel.userAddress![index]);
                  },
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 4.0),
                        child: Icon(
                          Icons.edit,
                          color: AppColor.cyanBlue,
                        ),
                      ),
                      Text(
                        "Edit",
                        style: AppTextStyle.titleSmall
                            .copyWith(color: AppColor.cyanBlue),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
/*
                Visibility(
                  visible: !isDefault,
                  child: Text(
                    "Mark Default",
                    style: AppTextStyle.titleSmall
                        .copyWith(color: AppColor.cyanBlue),
                  ),
                )
*/
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> getAddressLayoutList(
      AddressViewModel viewModel, BuildContext context) {
    List<Widget> widgets = [];
    for (int i = 0; i < viewModel.userAddress!.length; i++) {
      widgets.add(getAddressLayout(viewModel, i, context));
    }
    return widgets;
  }
}
