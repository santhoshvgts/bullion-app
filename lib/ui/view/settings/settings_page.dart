import 'package:bullion/ui/view/settings/settings_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends VGTSBuilderWidget<SettingsViewModel> {
  const SettingsPage({super.key});

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      SettingsViewModel viewModel, Widget? child) {
    return const Scaffold();
  }

  @override
  SettingsViewModel viewModelBuilder(BuildContext context) {
    return SettingsViewModel();
  }
}
