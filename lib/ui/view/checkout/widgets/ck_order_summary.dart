// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:bullion/core/models/module/cart/order_total_summary.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/shared/cart/cart_summary_help_text.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/view/checkout/checkout_view_model.dart';

class CkOrderSummary extends ViewModelWidget<CheckoutPageViewModel> {
  const CkOrderSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, CheckoutPageViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.only(top: 20, left: 15), child: Text('Order Summary', style: AppTextStyle.titleMedium)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Column(
            children: [
              VerticalSpacing.d5px(),
              ListView.separated(
                  itemCount: viewModel.orderSummaryList!.length,
                  primary: false,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return AppStyle.dottedDivider;
                  },
                  itemBuilder: (context, index) {
                    OrderTotalSummary item = viewModel.orderSummaryList![index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Text(item.key!, style: AppTextStyle.bodyMedium),
                              HorizontalSpacing.d5px(),
                              if (item.keyHelpText!.isNotEmpty)
                                InkWell(
                                    onTap: () => locator<DialogService>().showBottomSheet(title: item.key, child: CartSummaryHelpText(item.keyHelpText)),
                                    child: const Icon(
                                      Icons.error_outline,
                                      size: 15,
                                      color: Colors.black45,
                                    )),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(item.value!, style: AppTextStyle.bodyMedium.copyWith(color: item.textColor)),
                              VerticalSpacing.d5px(),
                              if (item.canRemove == true)
                                InkWell(
                                    onTap: () => viewModel.onRemoveFromOrderSummary(item.keyCode),
                                    child: Row(
                                      children: [
                                        Text("Remove", textAlign: TextAlign.left, textScaleFactor: 1, style: AppTextStyle.bodySmall.copyWith(color: AppColor.primary, fontSize: 8)),
                                      ],
                                    )),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
              AppStyle.dottedDivider,
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(children: [
                    const Text('Total', style: AppTextStyle.titleMedium),
                    const Spacer(),
                    Text(viewModel.checkout!.formattedOrderTotal!, style: AppTextStyle.titleMedium),
                  ])),
              VerticalSpacing.d5px(),
            ],
          ),
        ),
      ],
    );
  }
}

class _DefaultDivider extends StatelessWidget {
  const _DefaultDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColor.divider,
      thickness: 0.3,
      height: 5,
    );
  }
}
