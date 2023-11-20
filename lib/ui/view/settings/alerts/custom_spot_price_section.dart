import 'package:bullion/core/models/alert_add_response_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/res/colors.dart';
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
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 16,
                        ),
/*
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              //height: 168,
              decoration: BoxDecoration(
                color: AppColor.eggSour,
                border: Border.all(width: 1, color: AppColor.orangePeel),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                  children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColor.orangePeel,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Advantage of Custom Spot Price",
                        style: AppTextStyle.labelLarge,
                      ),
                    ),
                    IconButton(
                      icon: Util.showArrowForward(),
                      onPressed: () {
                        Navigator.of(context).maybePop();
                      },
                    )
                  ],
                ),
              ]),
            )
*/
                      ],
                    ),
                  )
                : const Center(child: Text("Empty")),
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
                    disabled: viewModel.isBusy,
                  )),
            ),
          );
  }
}
