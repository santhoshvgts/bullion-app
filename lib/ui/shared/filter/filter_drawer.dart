// ignore_for_file: library_private_types_in_public_api, must_be_immutable, prefer_generic_function_type_aliases

import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/models/module/product_listing/items.dart';
import 'package:bullion/core/models/module/product_listing/product_list_module.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/shared/filter/filter_drawer_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
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
        child: viewModel.isBusy
            ? const Center(child: CircularProgressIndicator(color: AppColor.primary))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VerticalSpacing.d10px(),
                  Padding(padding: const EdgeInsets.only(left: 30), child: Text('All Filters', style: AppTextStyle.headlineSmall.copyWith(fontSize: 24))),
                  VerticalSpacing.d5px(),
                  const Divider(
                    color: Colors.black38,
                    thickness: 0.7,
                  ),
                  VerticalSpacing.d5px(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewModel.filterData?.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Theme(
                              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                title: Text(viewModel.filterData?[index].displayName ?? ''),
                                children: viewModel.selectedFacet!.items!
                                    .asMap()
                                    .map((index, item) {
                                      return MapEntry(
                                        index,
                                        Container(
                                          padding: const EdgeInsets.only(left: 15.0, right: 10.0, bottom: 14.0, top: 10),
                                          child: _BuildRow(
                                            item,
                                            onSelect: (item) async {
                                              viewModel.setBusy(true);
                                              await onSelect!(item.targetUrl);
                                              viewModel.setBusy(false);
                                            },
                                          ),
                                        ),
                                      );
                                    })
                                    .values
                                    .toList(),
                              ),
                            ),
                            const Divider(
                              color: Colors.black12,
                              thickness: 0.7,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  VerticalSpacing.d30px(),
                  InkWell(
                    onTap: () async {
                      locator<DialogService>().dialogComplete(AlertResponse(status: true));
                      viewModel.setBusy(true);
                      await onSelect!(viewModel.productModel.resetFilterUrl);

                      viewModel.setBusy(false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        'Reset',
                        style: AppTextStyle.titleLarge.copyWith(color: AppColor.primary, fontSize: 18),
                      ),
                    ),
                  ),
                  VerticalSpacing.d20px(),
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
    return Row(
      children: <Widget>[
        Checkbox(
          value: _item.isSelected,
          checkColor: _item.isSelected! ? AppColor.primary : Colors.black12,
          onChanged: (bool? value) => onSelect!(_item),
        ),
        Text(_item.displayName ?? ''),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text('(${(_item.count ?? '').toString()})'),
          ),
        ),
        HorizontalSpacing.custom(value: 10),
      ],
    );
  }
}
