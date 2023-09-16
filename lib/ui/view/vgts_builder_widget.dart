import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class VGTSBuilderWidget<T extends ChangeNotifier> extends StackedView<T> {
  const VGTSBuilderWidget({Key? key}) : super(key: key);

  Widget viewBuilder(BuildContext context, AppLocalizations locale, T viewModel,
    Widget? child,
  );

  @override
  Widget builder(BuildContext context, T viewModel, Widget? child) {
    return viewBuilder(context, AppLocalizations.of(context)!, viewModel, child);
  }

}

abstract class VGTSWidget<T extends ChangeNotifier> extends ViewModelWidget<T> {
  const VGTSWidget({Key? key}) : super(key: key);


  Widget widget(BuildContext context, AppLocalizations locale, T viewModel);

  @override
  Widget build(BuildContext context, T viewModel) {
    return widget(context, AppLocalizations.of(context)!, viewModel,);
  }

}