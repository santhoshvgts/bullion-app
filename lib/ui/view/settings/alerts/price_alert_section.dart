import 'package:bullion/ui/view/settings/alerts/price_alert_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PriceAlertPage extends VGTSBuilderWidget<PriceAlertViewModel> {
  const PriceAlertPage({super.key});

  @override
  PriceAlertViewModel viewModelBuilder(BuildContext context) {
    return PriceAlertViewModel();
  }

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      PriceAlertViewModel viewModel, Widget? child) {
    /*return viewModel.filteredList == null
        ? const Center(child: Text("No data available"))
        : Container();*/
    return Scaffold();
  }
}
