import 'package:bullion/core/enums/order_status.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/models/module/order.dart';
import '../../core/res/colors.dart';
import '../../core/res/styles.dart';
import '../../locator.dart';
import '../../router.dart';
import '../../services/shared/navigator_service.dart';
import 'my_orders_view_model.dart';

class MyOrdersPage extends VGTSBuilderWidget<MyOrdersViewModel> {
  final List<Order>? ordersList;
  final OrderStatus? orderStatus;

  const MyOrdersPage(this.ordersList, this.orderStatus, {super.key});

  @override
  MyOrdersViewModel viewModelBuilder(BuildContext context) {
    return MyOrdersViewModel(ordersList, orderStatus);
  }

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      MyOrdersViewModel viewModel, Widget? child) {
    return viewModel.filteredList == null
        ? const Center(child: Text("No data available"))
        : ListView.builder(
            itemCount: viewModel.filteredList?.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  locator<NavigationService>().pushNamed(Routes.myOrderDetails(
                      viewModel.filteredList?[index].orderId));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*const Text(
              "My Orders",
              style: AppTextStyle.titleLarge,
            ),*/
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              viewModel.filteredList?[index]
                                                      .orderId ??
                                                  "",
                                              style: AppTextStyle.bodyMedium,
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              viewModel.filteredList?[index]
                                                      .orderSummary?[2].value ??
                                                  "",
                                              style: AppTextStyle.labelMedium
                                                  .copyWith(
                                                      color: AppColor.cyanBlue),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios)
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Order Date",
                                              style: AppTextStyle.labelSmall,
                                            ),
                                            Text(
                                              viewModel.getDayCode(viewModel
                                                      .filteredList?[index]
                                                      .orderSummary?[0]
                                                      .value) ??
                                                  "",
                                              style: AppTextStyle.labelLarge,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const VerticalDivider(
                                            width: 2,
                                            indent: 16,
                                            endIndent: 16,
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Payment Method",
                                                    style:
                                                        AppTextStyle.labelSmall,
                                                  ),
                                                  Text(
                                                    viewModel
                                                            .filteredList?[
                                                                index]
                                                            .orderSummary?[3]
                                                            .value ??
                                                        "",
                                                    style:
                                                        AppTextStyle.labelLarge,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                ],
                                              ),
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
            });
  }
}
