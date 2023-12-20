import 'package:bullion/core/models/user_address.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/view/checkout/checkout_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CkAddress extends ViewModelWidget<CheckoutPageViewModel> {
  const CkAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, CheckoutPageViewModel viewModel) {
    UserAddress? userAddress = viewModel.checkout!.selectedShippingAddress!.address;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.only(top: 15, left: 15), child: Text('Shipping Address', style: AppTextStyle.titleMedium)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            // boxShadow: [
            //   BoxShadow(color: Colors.black.withOpacity(0.1), offset: const Offset(0, 2), blurRadius: 12),
            // ],
          ),
          child: InkWell(
               onTap: () => locator<NavigationService>().pushNamed(Routes.address),
          //  onTap: () {},
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 25, color: AppColor.primary),
                HorizontalSpacing.d15px(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            viewModel.checkout!.selectedShippingAddress!.isCitadel! ? "Secure Storage" : userAddress!.name,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.titleSmall,
                            maxLines: 1,
                            softWrap: true,
                          ),
                          Text(
                            'Edit',
                            style: AppTextStyle.bodySmall.copyWith(color: AppColor.primary),
                          )
                        ],
                      ),
                      VerticalSpacing.d2px(),
                      if (!viewModel.checkout!.selectedShippingAddress!.isCitadel!)
                        Text(
                          '${userAddress?.add1}',
                          style: AppTextStyle.bodyMedium.copyWith(color: Colors.black54),
                          maxLines: 1,
                          softWrap: true,
                        ),
                      if (viewModel.checkout!.selectedShippingAddress!.isCitadel!)
                        Text(
                          viewModel.checkout!.selectedShippingAddress!.citadelAccountNumber ?? 'Citadel Global Depository Services',
                          style: AppTextStyle.bodyMedium.copyWith(color: Colors.black54),
                          maxLines: 1,
                          softWrap: true,
                        ),
                      Text(
                        '${userAddress?.formattedSubAddress}',
                        style: AppTextStyle.bodyMedium.copyWith(color: Colors.black54),
                        maxLines: 1,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


