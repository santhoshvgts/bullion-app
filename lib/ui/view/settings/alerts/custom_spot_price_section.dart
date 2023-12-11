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
  void onViewModelReady(AlertsViewModel viewModel) {
    //viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  AlertsViewModel viewModelBuilder(BuildContext context) {
    return viewModel;
  }

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      AlertsViewModel viewModel, Widget? child) {
    return viewModel.alertResponse?.alertResponseModels == null
        ? const Center(child: Text("No data available"))
        : Scaffold(
            body: viewModel.alertResponse!.alertResponseModels!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 16.0, right: 16.0),
                    child: SizedBox(
                      child: AnimationLimiter(
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
                            itemCount: viewModel
                                .alertResponse!.alertResponseModels!.length,
                            itemBuilder: (context, index) {
                              return StaggeredAnimation.staggeredGrid(
                                  index: index,
                                  isList: false,
                                  columnCount: 2,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: InkWell(
                                      onTap: () async {
                                        locator<NavigationService>().pushNamed(
                                            Routes.editSpotPrice,
                                            arguments: {
                                              "alertResponse": viewModel
                                                  .alertResponse!
                                                  .alertResponseModels?[index]
                                            });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 1, color: AppColor.border),
                                          boxShadow:
                                              AppStyle.elevatedGridShadow,
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                                          viewModel
                                                              .alertResponse!
                                                              .alertResponseModels![
                                                                  index]
                                                              .metal),
                                                      style: AppTextStyle
                                                          .titleMedium),
                                                ],
                                              ),
                                            ),

                                            Positioned(
                                              top: 16,
                                              right: 16,
                                              child: Column(
                                                children: [
                                                  InkWell(
                                                      onTap: () {
                                                        showDialog<String>(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            title: const Text(
                                                                'Delete'),
                                                            content: const Text(
                                                                "Do you want to delete this Alert?"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context,
                                                                        'Cancel'),
                                                                child: const Text(
                                                                    'Cancel'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  viewModel.removeSpotPriceAlert(viewModel
                                                                      .alertResponse
                                                                      ?.alertResponseModels?[
                                                                          index]
                                                                      .id);
                                                                  Navigator.pop(
                                                                      context,
                                                                      'OK');
                                                                },
                                                                child: const Text(
                                                                    'Delete'),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      child: const Icon(
                                                        Icons.delete_forever,
                                                        color:
                                                            AppColor.redOrange,
                                                        size: 22,
                                                      ))
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4.0),
                                                    child: Text(
                                                      viewModel
                                                              .alertResponse!
                                                              .alertResponseModels?[
                                                                  index]
                                                              .operatorName ??
                                                          "",
                                                      style: AppTextStyle
                                                          .bodyMedium,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      viewModel
                                                                      .alertResponse!
                                                                      .alertResponseModels![
                                                                          index]
                                                                      .operatorId ==
                                                                  5 ||
                                                              viewModel
                                                                      .alertResponse!
                                                                      .alertResponseModels![
                                                                          index]
                                                                      .operatorId ==
                                                                  7
                                                          ? const Icon(
                                                              Icons
                                                                  .arrow_upward,
                                                              color: AppColor
                                                                  .green,
                                                            )
                                                          : const Icon(
                                                              Icons
                                                                  .arrow_downward,
                                                              color: Colors.red,
                                                            ),
                                                      const SizedBox(width: 2),
                                                      Text(
                                                          viewModel
                                                              .alertResponse!
                                                              .alertResponseModels![
                                                                  index]
                                                              .formattedPrice
                                                              .toString(),
                                                          style: viewModel
                                                                          .alertResponse!
                                                                          .alertResponseModels![
                                                                              index]
                                                                          .operatorId ==
                                                                      5 ||
                                                                  viewModel
                                                                          .alertResponse!
                                                                          .alertResponseModels![
                                                                              index]
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
                                  ));
                            }),
                      ),
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
                    color: AppColor.turtleGreen,
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
