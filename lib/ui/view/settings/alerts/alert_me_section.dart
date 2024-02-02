import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/view/settings/alerts/alerts_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/network_image_loader.dart';
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
                        ProductDetails priceAlert = viewModel.alertMeAlerts![index];

                        return StaggeredAnimation.staggeredList(
                            index: index,
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: AppStyle.elevatedCardShadow,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 55,
                                        height: 55,
                                        child: NetworkImageLoader(
                                          image: priceAlert.overview?.primaryImageUrl ?? '',
                                          fit: BoxFit.cover,
                                          height: 100,
                                          width: 100,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("${priceAlert.overview?.name}", style: AppTextStyle.titleSmall,),

                                            VerticalSpacing.custom(value: 7),

                                            Text("${priceAlert.overview?.pricing?.badgeText} : ${priceAlert.overview?.pricing?.formattedNewPrice.toString()}", style: AppTextStyle.titleSmall),

                                          ],
                                        ),
                                      ),

                                    ],
                                  ),

                                  VerticalSpacing.d15px(),

                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text("Your Alert Qty:", style: AppTextStyle.labelSmall,),

                                            Text("${priceAlert.requestedQty}", style: AppTextStyle.titleLarge),
                                          ],
                                        ),
                                      ),

                                      Text(
                                          "${priceAlert.formatedPostedDate}",
                                          style: AppTextStyle.bodyMedium.copyWith(color: AppColor.primaryText)
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4.0),


                                  AppStyle.customDivider,

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          AlertResponse response = await locator<DialogService>().showConfirmationDialog(
                                              title: "Delete",
                                              description: "Do you want to delete this Alert ?",
                                              buttonTitle: "Delete"
                                          );

                                          if (response.status == true) {
                                            viewModel.removeAlertMe(priceAlert.overview?.productId);
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
                                              style: AppTextStyle.titleSmall.copyWith(color: AppColor.red),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          var result = await locator<NavigationService>().pushNamed(Routes.editAlertMe, arguments: { "productDetails": priceAlert.overview });
                                          if (result != null) {
                                            viewModel.refreshAlertMe();
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  right: 4.0),
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        );
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
