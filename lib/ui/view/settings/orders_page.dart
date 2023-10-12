import 'package:bullion/core/res/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/res/colors.dart';
import '../vgts_builder_widget.dart';
import 'orders_view_model.dart';

class OrdersPage extends VGTSBuilderWidget<OrdersViewModel> {
  const OrdersPage({super.key});

  @override
  OrdersViewModel viewModelBuilder(BuildContext context) {
    return OrdersViewModel();
  }

  @override
  void onViewModelReady(OrdersViewModel viewModel) {
    super.onViewModelReady(viewModel);
  }

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      OrdersViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My Orders",
              style: AppTextStyle.titleLarge,
            ),
            const SizedBox(
              height: 16.0,
            ),
            Container(
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppColor.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColor.iconBG,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: 56,
                            height: 56,
                            child: const Icon(
                              Icons.receipt_long_outlined,
                              size: 32,
                              color: AppColor.turtleGreen,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "#7161760",
                                    style: AppTextStyle.bodyMedium,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "Processing Payment",
                                    style: AppTextStyle.labelMedium
                                        .copyWith(color: AppColor.cyanBlue),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_outlined)
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColor.snowDrift,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Order Date",
                                    style: AppTextStyle.labelSmall,
                                  ),
                                  Text(
                                    "June 5, 2023",
                                    style: AppTextStyle.labelLarge,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                VerticalDivider(
                                  width: 2,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Payment Method",
                                        style: AppTextStyle.labelSmall,
                                      ),
                                      Text(
                                        "Bank Wire",
                                        style: AppTextStyle.labelLarge,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
