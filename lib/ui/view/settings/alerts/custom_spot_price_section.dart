import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/res/colors.dart';
import '../../../../locator.dart';
import '../../../../router.dart';
import '../../../../services/shared/navigator_service.dart';
import '../../../widgets/button.dart';
import 'custom_spot_price_view_model.dart';

class CustomSpotPricePage extends VGTSBuilderWidget<CustomSpotPriceViewModel> {
  const CustomSpotPricePage({super.key});

  @override
  CustomSpotPriceViewModel viewModelBuilder(BuildContext context) {
    return CustomSpotPriceViewModel();
  }

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      CustomSpotPriceViewModel viewModel, Widget? child) {
    /*return viewModel.filteredList == null
        ? const Center(child: Text("No data available"))
        : Container();*/
    return Scaffold(
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 16,),
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
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Button(
              color: AppColor.turtleGreen,
              "Create New Alert",
              valueKey: const Key("btnCreateAlert"),
              borderRadius: BorderRadius.circular(24),
              onPressed: () {
                locator<NavigationService>().pushNamed(Routes.createAlerts);
              },
              disabled: viewModel.isBusy,
            )),
      ),
    );
  }
}
