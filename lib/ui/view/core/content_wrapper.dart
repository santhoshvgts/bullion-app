// ignore_for_file: library_private_types_in_public_api

import 'package:bullion/core/constants/module_type.dart';
import 'package:bullion/core/models/module/page_settings.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
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
  final Color? backgroundColor;

  final LoadingStyle loadingStyle;

  const ContentWrapper(
    this.path, {
    super.key,
    this.controller,
    this.initialValue,
    this.onPageFetched,
    this.enableController = true,
    this.onLoading,
    this.backgroundColor,
    this.loadingStyle = LoadingStyle.DEFAULT,
    this.metalName,
  });

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
  ContentViewModel viewModelBuilder(BuildContext context) =>
      ContentViewModel(path!, onPageFetched, initialValue, onLoading);

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      ContentViewModel viewModel, Widget? child) {
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
              color: backgroundColor ?? AppColor.secondaryBackground,
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      controller:
                          enableController! ? viewModel.scrollController : null,
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
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 0
                                                  ),
                                                ),
                                                isLoadingFilter: viewModel.isBusy
                                              );

                                            case ModuleType.banner:
                                              return BannerModule(module);

                                            default:
                                              return Container();
                                          }
                                        }).toList() ??
                                        []
                                  ],
                                )
                              : LoadingData(loadingStyle: loadingStyle),
                        ),
                        if (viewModel.paginationLoading)
                          Container(
                              margin: const EdgeInsets.all(15),
                              child: const SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(AppColor.primary),
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
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
                      )
                    ),

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

    String sortOption = (viewModel.productModel.sortOptions?.where((element) => element.selected == true).firstOrNull?.text) ?? '';

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: viewModel.showSortAppBarSection ? AppStyle.cardShadow : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => viewModel.onFilterPressed(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: AppColor.border, width: 1),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Images.filter_icon,
                    height: 18,
                  ),
                  HorizontalSpacing.d5px(),
                  const Text(
                    "Filter",
                    textScaleFactor: 1,
                    style: AppTextStyle.titleSmall,
                  ),
                  if (viewModel.productModel.selectedFacetsCount! > 0)
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColor.primary,
                        shape: BoxShape.circle,
                      ),
                      margin: const EdgeInsets.only(left: 5),
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        viewModel.productModel.selectedFacetsCount!.toString(),
                        textScaleFactor: 1,
                        style: AppTextStyle.labelSmall.copyWith(
                          color: AppColor.white,
                          fontSize: 10,
                          fontFamily: AppTextStyle.fontFamily,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          HorizontalSpacing.d10px(),
          InkWell(
            onTap: () => viewModel.onSortPressed(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: AppColor.border, width: 1),
              ),
              padding: const EdgeInsets.only(
                left: 8,
                top: 5,
                bottom: 5,
                right: 15,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.sort_rounded,
                    size: 18,
                  ),
                  HorizontalSpacing.d5px(),
                  Text(
                    sortOption.isEmpty ? "Sort By" : sortOption,
                    textScaleFactor: 1,
                    style: AppTextStyle.titleSmall,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
