import 'package:bullion/ui/view/settings/alerts/alerts_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/staggered_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../core/res/colors.dart';
import '../../../../core/res/images.dart';
import '../../../../core/res/spacing.dart';
import '../../../../core/res/styles.dart';
import '../../../../locator.dart';
import '../../../../router.dart';
import '../../../../services/shared/navigator_service.dart';

class AlertMePage extends VGTSBuilderWidget<AlertsViewModel> {
  //List<ProductAlert>? alertMeAlerts;
  final AlertsViewModel viewModel;

  const AlertMePage(this.viewModel, {super.key});

  @override
  AlertsViewModel viewModelBuilder(BuildContext context) {
    return viewModel;
  }

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      AlertsViewModel viewModel, Widget? child) {
    return viewModel.alertMeAlerts == null
        ? const Center(child: Text("No data available"))
        : Scaffold(
            body: viewModel.alertMeAlerts!.isNotEmpty
                ? AnimationLimiter(
                    child: ListView.separated(
                      itemCount: viewModel.alertMeAlerts?.length ?? 0,
                      padding: const EdgeInsets.all(15),
                      separatorBuilder: (context, index) {
                        return VerticalSpacing.d10px();
                      },
                      itemBuilder: (context, index) {
                        return StaggeredAnimation.staggeredList(
                            index: index,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1, color: AppColor.border),
                                    boxShadow: AppStyle.elevatedCardShadow,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColor.iconBG,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            width: 56,
                                            height: 56,
                                            child: Image.network(viewModel
                                                    .alertMeAlerts![index]
                                                    .overview
                                                    ?.primaryImageUrl ??
                                                ""),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${viewModel.alertMeAlerts?[index].overview?.name}",
                                                  style:
                                                      AppTextStyle.titleMedium,
                                                ),
                                                VerticalSpacing.d5px(),
                                              ],
                                            ),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                          "Current Price: \$${viewModel.alertMeAlerts?[index].overview?.pricing?.newPrice}",
                                          style: AppTextStyle.bodyMedium
                                              .copyWith(
                                                  color: AppColor.primaryText)),
                                      const SizedBox(height: 4.0),
                                      Text(
                                          "${viewModel.alertMeAlerts?[index].requestedQty}",
                                          style: AppTextStyle.titleLarge),
                                      const SizedBox(height: 4.0),
                                      Text(
                                          "${viewModel.alertMeAlerts?[index].formatedPostedDate}",
                                          style: AppTextStyle.bodyMedium
                                              .copyWith(
                                                  color: AppColor.primaryText)),
                                      const Divider(
                                        thickness: 1,
                                        color: AppColor.border,
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  title: const Text('Delete'),
                                                  content: const Text(
                                                      "Do you want to delete this Alert?"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(context,
                                                              'Cancel'),
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        viewModel.removeAlertMe(
                                                            viewModel
                                                                .alertMeAlerts?[
                                                                    index]
                                                                .overview
                                                                ?.productId);
                                                        Navigator.pop(
                                                            context, 'OK');
                                                      },
                                                      child:
                                                          const Text('Delete'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 4.0),
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: AppColor.redOrange,
                                                  ),
                                                ),
                                                Text(
                                                  "Delete",
                                                  style: AppTextStyle.titleSmall
                                                      .copyWith(
                                                          color: AppColor
                                                              .redOrange),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 16,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              locator<NavigationService>()
                                                  .pushNamed(Routes.editAlertMe,
                                                      arguments: {
                                                    "productAlert": viewModel
                                                        .alertMeAlerts![index]
                                                  });
                                            },
                                            child: Row(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 4.0),
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: AppColor.cyanBlue,
                                                  ),
                                                ),
                                                Text(
                                                  "Edit",
                                                  style: AppTextStyle.titleSmall
                                                      .copyWith(
                                                          color: AppColor
                                                              .cyanBlue),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 16,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ));
                      },
                    ),
                  )
                : Container(
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
                        const Text(
                          "No Alerts found",
                          textAlign: TextAlign.center,
                          style: AppTextStyle.titleLarge,
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          "You can manage your product back-in-stock notifications on this page. We will send you an email and/or SMS when the product is available to purchase. Sign up to be notified when a product comes back in-stock by clicking the “Notify Me” button on a product page.",
                          textAlign: TextAlign.center,
                          style: AppTextStyle.bodySmall,
                        ),
                      ],
                    ),
                  ));
  }

  @override
  bool get disposeViewModel => false;
}
