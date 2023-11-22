import 'package:bullion/core/models/alert_add_response_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/res/colors.dart';
import '../../../../core/res/images.dart';
import '../../../../core/res/styles.dart';
import '../../../../locator.dart';
import '../../../../router.dart';
import '../../../../services/shared/navigator_service.dart';
import '../../../widgets/button.dart';
import 'custom_spot_price_view_model.dart';

class CustomSpotPricePage extends VGTSBuilderWidget<AlertsViewModel> {
  AlertGetResponse? alertResponse;

  CustomSpotPricePage(this.alertResponse, {super.key});

  @override
  void onViewModelReady(AlertsViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  AlertsViewModel viewModelBuilder(BuildContext context) {
    return AlertsViewModel();
  }

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      AlertsViewModel viewModel, Widget? child) {
    return alertResponse?.alertResponseModels == null
        ? const Center(child: Text("No data available"))
        : Scaffold(
            body: alertResponse!.alertResponseModels!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 16.0, right: 16.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          shrinkWrap: true,
                          physics: const PageScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  mainAxisExtent: 160),
                          itemCount: alertResponse!.alertResponseModels!.length,
                          itemBuilder: (BuildContext ctx, gridIndex) {
                            return SizedBox(
                              width: MediaQuery.of(ctx).size.width,
                              child: InkWell(
                                onTap: () async {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1, color: AppColor.border),
                                    boxShadow: AppStyle.elevatedGridShadow,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // To place an image with opacity on background
                                      Positioned(
                                        right: -72,
                                        bottom: 20,
                                        child: Opacity(
                                          opacity: 0.20,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                              Images.gold,
                                              width: 144,
                                              height: 144,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      /*const Positioned(
                                        top: 16,
                                        right: 16,
                                        child: CircleAvatar(
                                          radius: 16, // Half of 12px size
                                          backgroundImage: AssetImage(Images.gold),
                                        )
                                      ),*/

                                      // Metal name text
                                      Positioned(
                                        top: 16,
                                        left: 16,
                                        child: Column(
                                          children: [
                                            Text(
                                                viewModel.getMetalName(
                                                    alertResponse!
                                                        .alertResponseModels![
                                                            gridIndex]
                                                        .metal),
                                                style:
                                                    AppTextStyle.titleMedium),
                                          ],
                                        ),
                                      ),

                                      Positioned(
                                        bottom: 16,
                                        left: 16,
                                        //right: 16,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4.0),
                                              child: Text(
                                                alertResponse!
                                                        .alertResponseModels?[
                                                            gridIndex]
                                                        .operatorName ??
                                                    "",
                                                style: AppTextStyle.bodyMedium,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                alertResponse!
                                                                .alertResponseModels![
                                                                    gridIndex]
                                                                .operatorId ==
                                                            5 ||
                                                        alertResponse!
                                                                .alertResponseModels![
                                                                    gridIndex]
                                                                .operatorId ==
                                                            7
                                                    ? const Icon(
                                                        Icons.arrow_upward,
                                                        color: AppColor.green,
                                                      )
                                                    : const Icon(
                                                        Icons.arrow_downward,
                                                        color: Colors.red,
                                                      ),
                                                const SizedBox(width: 2),
                                                Text(
                                                    alertResponse!
                                                        .alertResponseModels![
                                                            gridIndex]
                                                        .formattedPrice
                                                        .toString(),
                                                    style: alertResponse!
                                                                    .alertResponseModels![
                                                                        gridIndex]
                                                                    .operatorId ==
                                                                5 ||
                                                            alertResponse!
                                                                    .alertResponseModels![
                                                                        gridIndex]
                                                                    .operatorId ==
                                                                7
                                                        ? AppTextStyle
                                                            .titleLarge
                                                            .copyWith(
                                                                color: AppColor
                                                                    .green)
                                                        : AppTextStyle
                                                            .titleLarge
                                                            .copyWith(
                                                                color: Colors
                                                                    .red)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
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
                          textScaleFactor: 1,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.titleLarge,
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          "Our spot price notification tool makes it easy to know when the gold, silver, platinum, or palladium spot price has reached a certain price. You can sign up to be alerted on various price thresholds for the same metal type, as well as a variety of metal types. You can manage your spot price alerts on this page. We will send you an email and/or SMS when the spot price goes above or below your requested price.",
                          textScaleFactor: 1,
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
                    color: AppColor.turtleGreen,
                    "Create New Alert",
                    valueKey: const Key("btnCreateAlert"),
                    borderRadius: BorderRadius.circular(24),
                    onPressed: () {
                      locator<NavigationService>()
                          .pushNamed(Routes.createAlerts);
                    },
                    //disabled: viewModel.isBusy,
                  )),
            ),
          );
  }
}
