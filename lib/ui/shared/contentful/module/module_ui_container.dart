import 'package:bullion/core/constants/alignment.dart';
import 'package:bullion/core/constants/display_style.dart';
import 'package:bullion/core/constants/module_type.dart';
import 'package:bullion/core/models/module/module_settings.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/fontsize.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/shared/contentful/module/action_button.dart';
import 'package:bullion/ui/shared/contentful/module/module_text_style.dart';
import 'package:bullion/ui/shared/contentful/module/module_ui_container_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked/stacked.dart';

class ModuleUIContainer extends VGTSBuilderWidget<ModuleUIContainerViewModel> {
  final ModuleSettings? _setting;
  final bool hideHeadSection;
  final List<Widget>? children;

  ModuleUIContainer(this._setting,
      {this.hideHeadSection = false, this.children = const <Widget>[]});

  @override
  bool get reactive => true;

  @override
  ModuleUIContainerViewModel viewModelBuilder(BuildContext context) =>
      ModuleUIContainerViewModel();

  @override
  void onViewModelReady(ModuleUIContainerViewModel model) {
    model.init(_setting);
    super.onViewModelReady(model);
  }

  @override
  bool get disposeViewModel => true;

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      ModuleUIContainerViewModel vm, Widget? child) {
    if (vm.displaySetting == null) {
      return Column(children: children!);
    }

    return Stack(
      children: [
        if (vm.setting!.displaySettings!.displayStyle == DisplayStyle.phamplet)
          Container(
            height: 250,
            color: vm.displaySetting!.backgroundColor,
          ),
        Container(
          padding: vm.displaySetting!.itemDisplaySettings.fullBleed
              ? EdgeInsets.zero
              : EdgeInsets.only(
                  bottom: 10, top: vm.setting!.hasHeaderSection ? 15 : 0),
          margin: EdgeInsets.only(top: vm.displaySetting!.marginTop),
          decoration: BoxDecoration(
              color: vm.setting!.displaySettings!.displayStyle ==
                      DisplayStyle.phamplet
                  ? null
                  : vm.displaySetting!.backgroundColor,
              image: vm.displaySetting!.hasBackgroundImage
                  ? DecorationImage(
                      image:
                          NetworkImage(vm.displaySetting!.backgroundImageUrl!),
                      fit: BoxFit.cover)
                  : null),
          width: double.infinity,
          child: Column(
            children: [
              if (vm.setting!.hasHeaderSection && !hideHeadSection)
                _ModuleHeadSection(),
              if ((!vm.setting!.hasHeaderSection &&
                      vm.setting!.displaySettings!.itemDisplaySettings
                              .displayType ==
                          DisplayStyle.standard))
                VerticalSpacing.custom(
                  value: vm.displaySetting!.itemDisplaySettings.cardPadding,
                ),
              ...children as Iterable<Widget>
            ],
          ),
        ),
      ],
    );
  }
}

class _ModuleHeadSection extends ViewModelWidget<ModuleUIContainerViewModel> {
  final double _padding = 10;

  @override
  Widget build(BuildContext context, ModuleUIContainerViewModel viewModel) {
    return Container(
      padding: EdgeInsets.only(
        right: _padding,
        left: _padding,
      ),
      width: double.infinity,
      height: viewModel.headSectionHeight,
      child: Stack(
        children: [
          Positioned(
            left: viewModel.titleSectionPositionLeft,
            right: viewModel.titleSectionPositionRight,
            top: viewModel.titleSectionPositionTop,
            child: Container(
              key: viewModel.titleSectionKey,
              child: Column(
                crossAxisAlignment:
                    viewModel.displaySetting!.titleCrossAxisAlignment,
                children: [
                  if (viewModel.setting!.title != null)
                    Text(viewModel.setting!.title!,
                        textScaleFactor: 1,
                        textAlign: UIAlignment.textAlign(
                            viewModel.displaySetting!.titleAlignment),
                        style: ModuleTextStyle.title(
                            viewModel.displaySetting!.titleStyle,
                            color: viewModel.displaySetting!.textColor)),
                  if (viewModel.setting!.subtitle?.isNotEmpty ?? false)
                    Text(viewModel.setting!.subtitle!,
                        textScaleFactor: 1,
                        textAlign: UIAlignment.textAlign(
                            viewModel.displaySetting!.titleAlignment),
                        style: ModuleTextStyle.subtitle(
                            viewModel.displaySetting!.titleStyle,
                            color: viewModel.displaySetting!.textColor)),
                  if (viewModel.setting!.metaData != null)
                    Container(color: AppColor.blue, child: _MetaData())
                ],
              ),
            ),
          ),
          if (viewModel.setting!.hasActionButton)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                alignment: UIAlignment.alignment(
                    viewModel.displaySetting!.actionButtonsPosition),
                child: Wrap(
                  key: viewModel.actionSectionKey,
                  children: viewModel.actions!.map((e) {
                    return ActionButtonItem(
                      settings: e,
                      textColor: viewModel.displaySetting!.textColor,
                      itemDisplaySettings:
                          viewModel.displaySetting!.itemDisplaySettings,
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MetaData extends ViewModelWidget<ModuleUIContainerViewModel> {
  @override
  Widget build(BuildContext context, ModuleUIContainerViewModel viewModel) {
    return Column(
      children: [
        if (viewModel.setting!.metaData!.saleEndDate != null)
          Text(
            "Ends In : ${viewModel.endTime.toString()}",
            textScaleFactor: 1,
            textAlign:
                UIAlignment.textAlign(viewModel.displaySetting!.titleAlignment),
            style: AppTextStyle.titleMedium.copyWith(
                fontSize: AppFontSize.subtitleByValue("small"),
                fontWeight: FontWeight.w600,
                color: Colors.red),
          ),
        if (viewModel.setting!.metaData!.saleStartDate != null)
          Text(
            "Sales Starts on : ${viewModel.setting!.metaData!.saleStartDate.toString()}",
            textScaleFactor: 1,
            textAlign:
                UIAlignment.textAlign(viewModel.displaySetting!.titleAlignment),
            style: AppTextStyle.titleMedium.copyWith(
                fontSize: AppFontSize.subtitleByValue("small"),
                fontWeight: FontWeight.w600,
                color: Colors.green),
          ),
      ],
    );
  }
}
