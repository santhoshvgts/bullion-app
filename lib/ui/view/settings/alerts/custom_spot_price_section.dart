import 'package:bullion/core/models/alert/alert_add_response_model.dart';
import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/staggered_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../core/res/colors.dart';
import '../../../../core/res/images.dart';
import '../../../../core/res/styles.dart';
import '../../../../locator.dart';
import '../../../../router.dart';
import '../../../../services/shared/navigator_service.dart';
import '../../../widgets/button.dart';
import 'alerts_view_model.dart';

class CustomSpotPricePage extends VGTSBuilderWidget<AlertsViewModel> {
  //final AlertGetResponse? viewModelalertResponse;
  final AlertsViewModel viewModel;

  const CustomSpotPricePage(this.viewModel, {super.key});

  @override
  AlertsViewModel viewModelBuilder(BuildContext context) {
    return viewModel;
  }

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, AlertsViewModel viewModel, Widget? child) {
    return viewModel.alertResponse?.alertResponseModels == null
        ? const Center(child: Text("No data available"))
        : Scaffold(body: viewModel.alertResponse!.alertResponseModels!.isNotEmpty
            ? SizedBox(
              child: AnimationLimiter(
                child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: viewModel.alertResponse?.alertResponseModels?.length ?? 0,
                    separatorBuilder: (context, index) {
                      return VerticalSpacing.d20px();
                    },
                    itemBuilder: (context, index) {
                      AlertResponseModel alertResponseModel = viewModel.alertResponse!.alertResponseModels![index];

                      return StaggeredAnimation.staggeredList(
                          index: index,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: AppStyle.elevatedGridShadow,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    "${viewModel.getMetalName(alertResponseModel.metal)}, ${(alertResponseModel.operatorName ?? '')}",
                                    style: AppTextStyle.bodyMedium
                                  ),

                                  VerticalSpacing.d5px(),

                                  Text(alertResponseModel.formattedPrice ?? '', style: AppTextStyle.titleLarge,),

                                  AppStyle.customDivider,

                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          AlertResponse response = await locator<DialogService>().showConfirmationDialog(
                                              title: "Delete",
                                              description: "Do you want to delete this Alert ?",
                                              buttonTitle: "Delete"
                                          );

                                          if (response.status == true) {
                                            viewModel.removeSpotPriceAlert(viewModel.productAlerts?[index].overview?.productId);
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
                                        onTap: () {
                                          locator<NavigationService>().pushNamed(
                                              Routes.editSpotPrice,
                                              arguments: {
                                                "alertResponse": viewModel
                                                    .alertResponse!
                                                    .alertResponseModels?[index]
                                              });
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

                                      Expanded(
                                        child: Text(alertResponseModel.formattedPostedDate ?? '',
                                          textAlign: TextAlign.right,
                                          style: AppTextStyle.labelMedium.copyWith(color: AppColor.secondaryText),
                                        ),
                                      )
                                    ],
                                  ),

                                ],
                              )
                            ),
                          ));
                    }),
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
                      "Spot Price alerts are empty",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.titleLarge,
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      "Our spot price notification tool makes it easy to know when the gold, silver, platinum, or palladium spot price has reached a certain price. You can sign up to be alerted on various price thresholds for the same metal type, as well as a variety of metal types. You can manage your spot price alerts on this page. We will send you an email and/or SMS when the spot price goes above or below your requested price.",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.bodySmall,
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: SafeArea(
          child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Button(
                "Create New Alert",
                valueKey: const Key("btnCreateAlert"),
                borderRadius: BorderRadius.circular(24),
                onPressed: () {
                  locator<NavigationService>()
                      .pushNamed(Routes.addEditAlert);
                },
              )),
        ),
      );
  }

  @override
  bool get disposeViewModel => false;
}
