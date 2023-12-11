import 'package:bullion/core/enums/order_status.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/staggered_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
  Widget viewBuilder(
    BuildContext context,
    AppLocalizations locale,
    MyOrdersViewModel viewModel,
    Widget? child,
  ) {
    return viewModel.filteredList == null
        ? const Center(child: Text("No data available"))
        : AnimationLimiter(
            child: ListView.separated(
              itemCount: viewModel.filteredList?.length ?? 0,
              padding: const EdgeInsets.all(15),
              separatorBuilder: (context, index) {
                return VerticalSpacing.d10px();
              },
              itemBuilder: (context, index) {
                return StaggeredAnimation.staggeredList(
                    index: index,
                    child: GestureDetector(
                      onTap: () {
                        locator<NavigationService>().pushNamed(
                            Routes.myOrderDetails(
                                viewModel.filteredList?[index].orderId));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: AppColor.border),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Row(
                                    children: [
                                      //Receipt icon with decoration
                                      /*Container(
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
                                          ),*/
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "#${viewModel.filteredList?[index].orderId}",
                                              style: AppTextStyle.bodyMedium,
                                            ),
                                            VerticalSpacing.d5px(),
                                            Text(
                                              viewModel.filteredList?[index]
                                                      .orderSummary?[2].value ??
                                                  "",
                                              style: AppTextStyle.labelMedium
                                                  .copyWith(
                                                color: AppColor.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: AppColor.secondaryBackground,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
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
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("Payment Method",
                                                style: AppTextStyle.labelSmall),
                                            Text(
                                              viewModel.filteredList?[index]
                                                      .orderSummary?[3].value ??
                                                  "",
                                              style: AppTextStyle.labelLarge,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ));
              },
            ),
          );
  }
}
