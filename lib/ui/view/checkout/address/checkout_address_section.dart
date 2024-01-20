

import 'package:bullion/core/models/module/checkout/checkout.dart';
import 'package:bullion/core/models/user_address.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/view/checkout/address/checkout_address_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckoutAddressSection extends VGTSBuilderWidget<CheckoutAddressViewModel> {

  Checkout? checkout;

  CheckoutAddressSection(this.checkout);

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, CheckoutAddressViewModel viewModel, Widget? child) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.divider, width: 0.5),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
              padding: EdgeInsets.only(left: 15, top: 10),
              child: Text('Shipping Address', style: AppTextStyle.titleMedium)
          ),
          Padding(
              padding: const EdgeInsets.only(left: 15, top: 2),
              child: Text('We require your shipping and billing address to match to avoid additional order processing time.', style: AppTextStyle.labelMedium.copyWith(fontWeight: FontWeight.w400,color: AppColor.secondaryText))
          ),

          Stack(
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  ListView.separated(
                    itemCount: viewModel.userAddressList.length,
                    primary: false,
                    shrinkWrap: true,
                    separatorBuilder: (context, index){
                      return AppStyle.customDivider;
                    },
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    itemBuilder: (context, index) {
                      UserAddress userAddress = viewModel.userAddressList[index];
                      return _AddressItemCard(userAddress,
                        checkout?.selectedShippingAddress?.address?.id == userAddress.id,
                        onTap: () {
                          viewModel.onSelectShippingAddress(userAddress);
                        },
                      );
                    },
                  ),

                  Button("+ Add Shipping Address",
                      borderColor: AppColor.white,
                      width: 200,
                      color: AppColor.white,
                      textStyle: AppTextStyle.titleSmall.copyWith(color: AppColor.primary),
                      valueKey: const ValueKey("btnAddShippingAddress"),
                      onPressed: () {
                        locator<NavigationService>().pushNamed(Routes.addEditAddress, arguments: { "fromCheckout": true });
                      }
                  ),

                ],
              ),

              if (viewModel.isBusy)
                Positioned.fill(
                  child: Container(
                    color: AppColor.white.withOpacity(0.7),
                    child: const Center(
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(AppColor.primary),
                        ),
                      ),
                    ),
                  ),
                )

            ],
          ),

          VerticalSpacing.d10px(),
        ],
      ),
    );
  }

  @override
  CheckoutAddressViewModel viewModelBuilder(BuildContext context) {
    return CheckoutAddressViewModel();
  }
}

class _AddressItemCard extends StatelessWidget {

  UserAddress address;
  Function onTap;
  bool selected;

  _AddressItemCard(this.address, this.selected, { required this.onTap, });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        onTap();
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.only(left: 0, right: 5, top: 0, bottom: 5),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Radio(
                value: selected,
                activeColor: AppColor.primary,
                onChanged: (value) {
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, groupValue: true,
              ),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(address.name,
                          style: AppTextStyle.titleSmall,
                        ),
                      ),

                      IconButton(onPressed: (){
                        locator<NavigationService>().pushNamed(Routes.addEditAddress, arguments: { "fromCheckout": true, "userAddress": address });
                      }, icon: const Icon(Icons.open_in_new, size: 16,))
                    ],
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

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}