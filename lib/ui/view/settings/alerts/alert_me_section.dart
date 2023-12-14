import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'alert_me_view_model.dart';

class AlertMePage extends VGTSBuilderWidget<AlertMeViewModel> {
  const AlertMePage({super.key});

  @override
  AlertMeViewModel viewModelBuilder(BuildContext context) {
    return AlertMeViewModel();
  }

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      AlertMeViewModel viewModel, Widget? child) {
    /*return viewModel.filteredList == null
        ? const Center(child: Text("No data available"))
        : Container();*/
    return Scaffold();
  }
}
