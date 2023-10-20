// ignore_for_file: library_private_types_in_public_api

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bullion/core/constants/alignment.dart';
import 'package:bullion/core/constants/module_type.dart';
import 'package:bullion/core/models/module/page_settings.dart';
import 'package:bullion/core/models/module/selected_item_list.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/shared/contentful/banner/banner_ui_container.dart';
import 'package:bullion/ui/shared/contentful/dynamic/dynamic_module.dart';
import 'package:bullion/ui/shared/contentful/product/product_module.dart';
import 'package:bullion/ui/shared/contentful/standard/standard_module.dart';
import 'package:bullion/ui/view/core/content_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/loading_data.dart';
import 'package:bullion/ui/widgets/page_will_pop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked/stacked.dart';

class ContentWrapperController {
  Function(String)? onMetalChange;
  dispose() {
    onMetalChange = null;
  }
}

class ContentWrapper extends VGTSBuilderWidget<ContentViewModel> {
  final String? path;
  final ContentWrapperController? controller;
  final PageSettings? initialValue;
  final Function(PageSettings?)? onPageFetched;
  final bool? enableController;
  final Function(bool onload)? onLoading;
  final String? metalName;

  const ContentWrapper(this.path, {super.key, this.controller, this.initialValue, this.onPageFetched, this.enableController = true, this.onLoading, this.metalName});

  @override
  bool get reactive => true;

  @override
  void onViewModelReady(ContentViewModel viewModel) {
    super.onViewModelReady(viewModel);
    if (controller != null) {
      controller!.onMetalChange = viewModel.onMetalChange;
    }
  }

  @override
  ContentViewModel viewModelBuilder(BuildContext context) => ContentViewModel(path!, onPageFetched, initialValue, onLoading);

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, ContentViewModel viewModel, Widget? child) {
    return PageWillPop(
      child: Container(
        color: AppColor.white,
        child: SafeArea(
          top: false,
          child: RefreshIndicator(
            onRefresh: () async {
              await viewModel.fetchContent(path!, refresh: true);
              return;
            },
            child: Container(
              color: AppColor.secondaryBackground,
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      controller: enableController! ? viewModel.scrollController : null,
                      child: Column(children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                          child: viewModel.modules?.isNotEmpty == true
                              ? Column(
                                  children: [
                                    ...viewModel.modules?.map((module) {
                                          switch (module?.moduleType) {
                                            case ModuleType.dynamic:
                                              return DynamicModule(
                                                module,
                                                viewModel.pageSetting,
                                                metalName: metalName,
                                              );

                                            case ModuleType.standard:
                                              return StandardModule(module);

                                            case ModuleType.product:
                                            case ModuleType.productList:
                                              return ProductModule(module,
                                                  controller: viewModel.productModuleController,
                                                  sortFilterWidget: SortFilterWidget(
                                                    key: viewModel.sortFilterWidgetKey,
                                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                                                  ),
                                                  isLoadingFilter: viewModel.isBusy);

                                            case ModuleType.banner:
                                              return BannerModule(module);

                                            default:
                                              return Container();
                                          }
                                        }).toList() ??
                                        []
                                  ],
                                )
                              : LoadingData(),
                        ),
                        if (viewModel.paginationLoading)
                          Container(
                              margin: const EdgeInsets.all(15),
                              child: const SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(AppColor.primary),
                                ),
                              ))
                      ]),
                    ),
                  ),
                  if (viewModel.showSortAppBarSection)
                    Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: SortFilterWidget(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SortFilterWidget extends ViewModelWidget<ContentViewModel> {
  EdgeInsets? padding;

  SortFilterWidget({Key? key, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context, ContentViewModel viewModel) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(color: AppColor.white, boxShadow: viewModel.showSortAppBarSection ? AppStyle.cardShadow : null),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (viewModel.productListingModuleTitle != null)
            AutoSizeText(viewModel.productListingModuleTitle!,
                textScaleFactor: 1, textAlign: UIAlignment.textAlign(viewModel.productListingModule!.displaySettings!.titleAlignment), style: AppTextStyle.titleSmall.copyWith(color: AppColor.title)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PopupMenuButton<SelectedItemList>(
                elevation: 0,
                color: AppColor.scaffoldBackground,
                onSelected: (value) => viewModel.onSortPressed(value.value ?? ''),
                itemBuilder: (BuildContext context) => viewModel.productModel.sortOptions!
                    .map(
                      (e) => PopupMenuItem(
                        value: e,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            e.text ?? '',
                            style: AppTextStyle.bodyLarge,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.sort,
                    ),
                    HorizontalSpacing.d10px(),
                    Text(
                      "Sort",
                      textScaleFactor: 1,
                      style: AppTextStyle.titleSmall.copyWith(color: AppColor.title),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () => viewModel.onFilterPressed(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  margin: const EdgeInsets.only(left: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          const Icon(
                            Icons.filter_list_alt,
                          ),
                          if (viewModel.productModel.selectedFacetsCount! > 0)
                            Positioned(
                              right: 0,
                              child: Container(
                                decoration: const BoxDecoration(color: AppColor.primary, shape: BoxShape.circle),
                                width: 10,
                                height: 10,
                              ),
                            )
                        ],
                      ),
                      HorizontalSpacing.d10px(),
                      Text(
                        "Filter${viewModel.productModel.selectedFacetsCount! > 0 ? " (${viewModel.productModel.selectedFacetsCount})" : ""}",
                        textScaleFactor: 1,
                        style: AppTextStyle.titleSmall.copyWith(color: AppColor.title),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
