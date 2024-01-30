import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/models/user_address.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/widgets/animated_flexible_space.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../core/res/styles.dart';
import '../../../../helper/utils.dart';
import '../../../../locator.dart';
import '../../../../router.dart';
import '../../../../services/shared/navigator_service.dart';
import '../../../widgets/loading_data.dart';
import '../../vgts_builder_widget.dart';
import 'address_view_model.dart';

class AddressPage extends VGTSBuilderWidget<AddressViewModel> {

  bool fromCheckout = false;

  AddressPage({super.key, this.fromCheckout = false});

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,AddressViewModel viewModel, Widget? child) {
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
              expandedHeight: 100,
              pinned: true,
              flexibleSpace: const AnimatedFlexibleSpace.withoutTab(title: "Address"),
            ),
            SliverToBoxAdapter(
              child: viewModel.isBusy
                ? LoadingData(loadingStyle: LoadingStyle.LOGO,)
                : viewModel.userAddressList.isEmpty
                    ? Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 1.5,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              Images.cartIcon,
                              width: 150,
                            ),
                            const SizedBox(height: 32.0),
                            Button("+ Create Address", width: 200, valueKey: const ValueKey("btnAddress"), onPressed: () async {
                              var result = await locator<NavigationService>().pushNamed(Routes.addEditAddress);
                              if (result != null) {
                                viewModel.refresh();
                              }
                            })
                          ],
                        ),
                      )
                    : AnimationLimiter(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                shrinkWrap: true,
                                itemCount: viewModel.userAddressList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: _AddressItemCard(
                                          viewModel.userAddressList[index],
                                          onTap: !fromCheckout ? null : () {
                                            viewModel.onAddressSelect(viewModel.userAddressList[index]);
                                          },
                                          onDelete: () {
                                            viewModel.deleteAddress(viewModel.userAddressList[index].id!);
                                          },
                                          onEdit: () async {
                                            int? result = await  locator<NavigationService>().pushNamed(Routes.addEditAddress, arguments: { "userAddress": viewModel.userAddressList[index] });
                                            if (result != null) {
                                              viewModel.refresh();
                                            }
                                          },
                                          showAction: !fromCheckout,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),

                              VerticalSpacing.d5px(),

                              Button(
                                "+ Create Address",
                                valueKey: const Key("addAddress"),
                                onPressed: () async {
                                  int? result = await locator<NavigationService>().pushNamed(Routes.addEditAddress);
                                  if (result != null) {
                                    viewModel.refresh();
                                  }
                                },
                                color: AppColor.white,
                                borderColor: AppColor.white,
                                textStyle: AppTextStyle.titleSmall.copyWith(color: AppColor.blue),
                              ),

                              VerticalSpacing.d10px(),

                            ],
                          ),
                        ),
                      )
            )
          ],
        )
      ),
    );
  }

  @override
  viewModelBuilder(BuildContext context) {
    return AddressViewModel();
  }
}

class _AddressItemCard extends StatelessWidget {

  UserAddress address;
  Function? onTap;
  Function onDelete;
  Function onEdit;

  bool showAction = true;

  _AddressItemCard(this.address, { required this.onTap, required this.onEdit, required this.onDelete, required this.showAction });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          //height: isDefault ? 192 : 176,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: AppStyle.elevatedCardShadow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: address.isDefault == true,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: AppColor.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Default",
                      style: AppTextStyle.titleSmall
                          .copyWith(color: AppColor.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(address.name,
                  style: AppTextStyle.titleSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(address.formattedFullAddress,
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
                  Text(address.primaryPhone ?? '-'),
                ],
              ),

              if (showAction)
                Column(
                  children: [

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
                          onTap: () async {
                            AlertResponse response = await locator<DialogService>().showConfirmationDialog(
                                title: "Delete",
                                description: "Do you want to delete this Address ?",
                                buttonTitle: "Delete"
                            );

                            if (response.status == true) {
                              onDelete();
                            }
                          },
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 4.0),
                                child: Icon(
                                  Icons.close,
                                  size: 18,
                                  color: AppColor.red,
                                ),
                              ),
                              Text(
                                "Delete",
                                style: AppTextStyle.titleSmall
                                    .copyWith(color: AppColor.red),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        InkWell(
                          onTap: () {
                            onEdit();
                          },
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 4.0),
                                child: Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: AppColor.blue,
                                ),
                              ),
                              Text(
                                "Edit",
                                style: AppTextStyle.titleSmall.copyWith(color: AppColor.blue),
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
                )

            ],
          ),
        ),
      ),
    );
  }

}