import 'package:bullion/core/models/module/product_listing/items.dart';
import 'package:bullion/core/models/module/product_listing/product_list_module.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/shared/contentful/product/sort_filter/filter_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked/stacked.dart';

typedef FilterCallBackTypDef(ProductModel productModel);

class FilterBottomSheetController {
  FilterCallBackTypDef? onDataChange;

  void dispose() {
    onDataChange = null;
  }
}

class FilterBottomSheet extends VGTSBuilderWidget<FilterViewModel> {
  FilterBottomSheetController? controller;
  ProductModel productModel;
  Function(String?)? onSelect;

  FilterBottomSheet(this.productModel, {this.controller, this.onSelect});

  @override
  void onViewModelReady(FilterViewModel viewModel) {
    if (this.controller != null) {
      this.controller!.onDataChange = viewModel.onDataChange;
    }
    super.onViewModelReady(viewModel);
  }

  @override
  FilterViewModel viewModelBuilder(BuildContext context) =>
      FilterViewModel(productModel);

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      FilterViewModel viewModel, Widget? child) {
    return Container(
      child: Stack(
        children: [
          SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.92,
              color: AppColor.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header(
                    onTap: () async {
                      viewModel.setBusy(true);
                      await onSelect!(viewModel.productModel.resetFilterUrl);
                      viewModel.setBusy(false);
                    },
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _FacetList(),
                        _ItemsList(onSelect: onSelect),
                      ],
                    ),
                  ),
                  _Bottom(),
                ],
              ),
            ),
          ),
          if (viewModel.isBusy)
            Container(
              color: AppColor.white.withOpacity(0.7),
              height: (MediaQuery.of(context).size.height / 1) * 0.95,
              child: Center(
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColor.primary),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class _Bottom extends ViewModelWidget<FilterViewModel> {
  @override
  Widget build(BuildContext context, FilterViewModel viewModel) {
    return Container(
      color: AppColor.white,
      padding: EdgeInsets.all(10),
      child: Button("See all Results (${viewModel.productModel.totalCount})",
          valueKey: Key('btnSeeAllResult'),
          width: double.infinity,
          color: AppColor.primary,
          textStyle: AppTextStyle.titleSmall.copyWith(color: AppColor.white),
          borderColor: AppColor.primary,
          onPressed: () => Navigator.pop(context)),
    );
  }
}

class _FacetList extends ViewModelWidget<FilterViewModel> {
  @override
  Widget build(BuildContext context, FilterViewModel viewModel) {
    return Expanded(
      flex: 3,
      child: Container(
        color: AppColor.secondaryBackground,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: viewModel.filterData!
                .asMap()
                .map((index, item) {
                  return MapEntry(
                      index,
                      InkWell(
                        onTap: () => viewModel.onFilterSectionChange(index),
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color:
                                  viewModel.selectedFacetName == item.facetName
                                      ? AppColor.white
                                      : AppColor.secondaryBackground,
                              border:
                                  viewModel.selectedFacetName == item.facetName
                                      ? Border(
                                          left: BorderSide(
                                              width: 4.0,
                                              color: AppColor.primary),
                                        )
                                      : null,
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.displayName!,
                                    maxLines: 2,
                                    textScaleFactor: 1,
                                    style: AppTextStyle.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: viewModel.selectedFacetName ==
                                                item.facetName
                                            ? AppColor.primary
                                            : AppColor.header),
                                  ),
                                ),
                                if (item.hasSelectedItems!)
                                  Container(
                                    margin: EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                        color: AppColor.primary,
                                        shape: BoxShape.circle),
                                    height: 7,
                                    width: 7,
                                  )
                              ],
                            )),
                      ));
                })
                .values
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _ItemsList extends ViewModelWidget<FilterViewModel> {
  Function(String?)? onSelect;

  _ItemsList({this.onSelect});

  @override
  Widget build(BuildContext context, FilterViewModel viewModel) {
    return Expanded(
      flex: 5,
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: viewModel.selectedFacet?.items == null
                ? []
                : viewModel.selectedFacet!.items!
                    .asMap()
                    .map((index, item) {
                      return MapEntry(
                          index,
                          Container(
                              padding: EdgeInsets.only(
                                  left: 15.0,
                                  right: 10.0,
                                  bottom: 14.0,
                                  top: 10),
                              child: _CheckBoxListWidget(
                                item,
                                onSelect: (item) async {
                                  viewModel.setBusy(true);
                                  await onSelect!(item.targetUrl);
                                  viewModel.setBusy(false);
                                },
                              )));
                    })
                    .values
                    .toList(),
          ),
        ),
      ),
    );
  }
}

class _CheckBoxListWidget extends ViewModelWidget<FilterViewModel> {
  final Items _item;
  final Function(Items)? onSelect;

  _CheckBoxListWidget(this._item, {this.onSelect});

  @override
  Widget build(BuildContext context, FilterViewModel vm) {
    return InkWell(
      onTap: () => onSelect!(_item),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Icon(
          Icons.check,
          color: _item.isSelected! ? AppColor.primary : Colors.black12,
          size: 22,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: RichText(
              textScaleFactor: 1,
              text: TextSpan(
                  text: _item.displayName,
                  style: AppTextStyle.bodyMedium
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' (${_item.count})',
                      style: AppTextStyle.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColor.secondaryText),
                    ),
                  ]),
            ),
          ),
        ),
      ]),
    );
  }
}

class Header extends StatelessWidget {
  Function? onTap;

  Header({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 20,
            width: 20,
            child: IconButton(
              icon: Icon(Icons.close, size: 20),
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Filter",
                textScaleFactor: 1,
                style: AppTextStyle.titleLarge.copyWith(
                  fontSize: 17,
                ),
              ),
            ),
          ),

          InkWell(
            onTap: onTap as void Function()?,
            child: Container(
              padding: EdgeInsets.only(top: 15, bottom: 15.0),
              child: Text(
                "Reset",
                textScaleFactor: 1,
                style: AppTextStyle.titleMedium
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),

          // IconButton(
          //   onPressed: () {
          //
          //   },
          //   icon: Container(
          //     decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: AppColor.secondaryBackground,
          //         boxShadow: AppStyle.mildCardShadow
          //     ),
          //     padding: EdgeInsets.all(5),
          //     child: Icon(
          //       Icons.close, size: 20,
          //       color: AppColor.title,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
