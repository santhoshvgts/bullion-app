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
