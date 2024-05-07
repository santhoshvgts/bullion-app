// ignore_for_file: library_private_types_in_public_api, must_be_immutable, prefer_generic_function_type_aliases

import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/models/module/product_listing/items.dart';
import 'package:bullion/core/models/module/product_listing/product_list_module.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/analytics_service.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/shared/filter/filter_drawer_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/custom_expansion_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef FilterCallBackTypDef(ProductModel productModel);

class FilterDrawerController {
  FilterCallBackTypDef? onDataChange;

  void dispose() {
    onDataChange = null;
  }
}

class FilterDrawer extends VGTSBuilderWidget<FilterDrawerViewModel> {
  FilterDrawerController? controller;
  ProductModel productModel;
  Function(String?)? onSelect;
  FilterDrawer({
    Key? key,
    required this.controller,
    required this.onSelect,
    required this.productModel,
  }) : super(key: key);

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, FilterDrawerViewModel viewModel, Widget? child) {
    return SafeArea(
      child: Material(
        color: AppColor.scaffoldBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerticalSpacing.d10px(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                HorizontalSpacing.d10px(),
                const Expanded(
                  child: Text(
                    'All Filters',
                    style: AppTextStyle.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => locator<DialogService>().dialogComplete(AlertResponse(status: true)),
                  icon: const Icon(
                    CupertinoIcons.clear,
                    size: 20,
                  ),
                )
              ],
            ),
            AppStyle.customDivider,
            VerticalSpacing.d5px(),
            Expanded(
              child: ListView.separated(
                itemCount: viewModel.filterData?.length ?? 0,
                separatorBuilder: (context, index) {
                  return AppStyle.customDivider;
                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: CustomExpansionTile(
                          initiallyExpanded: false,
                          onExpansionChanged: (value) => viewModel.onFilterSectionChange(index),
                          trailing: const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.arrow_drop_down_rounded, size: 30, color: Colors.black38),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  viewModel.filterData?[index].displayName ?? '',
                                  style: AppTextStyle.titleSmall.copyWith(color: viewModel.filterData![index].hasSelectedItems! ? AppColor.primary : AppColor.text),
                                ),
                                HorizontalSpacing.d5px(),
                                viewModel.filterData![index].hasSelectedItems!
                                    ? Text(
                                        '(${viewModel.selectedFilterItemCount?[index]})',
                                        style: AppTextStyle.titleSmall.copyWith(color: AppColor.primary),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                          children: viewModel.productModel.facets![index].items!
                              .asMap()
                              .map((index, item) {
                                return MapEntry(
                                  index,
                                  Container(
                                    padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 5),
                                    child: _BuildRow(
                                      item,
                                      onSelect: (item) async {
                                        locator<DialogService>().showLoader();
                                        await onSelect!(item.targetUrl);
                                        locator<AnalyticsService>().logFilter(item.displayName);
                                        locator<DialogService>().dialogComplete(AlertResponse(status: true));
                                      },
                                    ),
                                  ),
                                );
                              })
                              .values
                              .toList(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                border: AppStyle.divider,
                color: Colors.white,
              ),
              child: Button.outline(
                "Reset",
                width: double.infinity,
                height: 35,
                textStyle: AppTextStyle.titleSmall.copyWith(color: AppColor.primary),
                valueKey: const ValueKey("btnReset"),
                onPressed: () async {
                  locator<DialogService>().dialogComplete(AlertResponse(status: true));
                  locator<DialogService>().showLoader();
                  await onSelect!(
                    viewModel.productModel.resetFilterUrl,
                  );
                  locator<DialogService>().dialogComplete(AlertResponse(status: true));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  FilterDrawerViewModel viewModelBuilder(BuildContext context) {
    return FilterDrawerViewModel(productModel, controller);
  }
}

class _BuildRow extends VGTSWidget<FilterDrawerViewModel> {
  final Items _item;
  final Function(Items)? onSelect;
  const _BuildRow(this._item, {this.onSelect});

  @override
  Widget widget(BuildContext context, AppLocalizations locale, FilterDrawerViewModel viewModel) {
    return InkWell(
      onTap: () => onSelect!(_item),
      splashColor:AppColor.primary.withOpacity(0.2) ,
      
      child: Row(
        children: <Widget>[
          Checkbox(
            value: _item.isSelected,
            activeColor: _item.isSelected! ? AppColor.primary : Colors.black12,
            onChanged: (bool? value) =>  onSelect!(_item),
          ),
          Expanded(
              child: Text(
            _item.displayName ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text('(${(_item.count ?? '').toString()})'),
            ),
          ),
          
        ],
      ),
    );
  }
}
