import 'package:bullion/ui/shared/contentful/module/module_ui_container.dart';
import 'package:bullion/ui/shared/contentful/product/product_text_style.dart';
import 'package:bullion/ui/shared/contentful/product/product_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:bullion/core/constants/display_direction.dart';
import 'package:bullion/core/constants/display_type.dart';
import 'package:bullion/core/constants/module_type.dart';
import 'package:bullion/core/models/module/module_settings.dart';
import 'package:bullion/core/models/module/product_item.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/network_image_loader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked/stacked.dart';

typedef ProductModuleCallBackTypDef(ModuleSettings? settings);

class ProductModuleController {
  ProductModuleCallBackTypDef? onDataChange;

  void dispose() {
    onDataChange = null;
  }
}

class ProductModule extends VGTSBuilderWidget<ProductViewModel> {
  ProductModuleController? controller;
  ModuleSettings? settings;
  Widget? sortFilterWidget;
  bool isLoadingFilter;

  ProductModule(this.settings, {this.controller, this.sortFilterWidget, this.isLoadingFilter = false});

  @override
  bool get reactive => true;

  @override
  void onViewModelReady(ProductViewModel viewModel) {
    if (controller != null) {
      controller!.onDataChange = viewModel.onDataChange;
    }

    viewModel.init(settings);
    super.onViewModelReady(viewModel);
  }

  @override
  ProductViewModel viewModelBuilder(BuildContext context) => ProductViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, ProductViewModel viewModel, Widget? child) {
    return ModuleUIContainer(
      viewModel.settings,
      hideHeadSection: viewModel.settings!.moduleType == ModuleType.productList,
      children: [
        if (viewModel.settings!.moduleType == ModuleType.productList) sortFilterWidget!,
        if (viewModel.settings!.displaySettings!.itemDisplaySettings.displayDirection == DisplayDirection.vertical) _ProductVerticalDisplay() else _ProductHorizontalDisplay()
      ],
    );
  }
}

class _ProductVerticalDisplay extends ViewModelWidget<ProductViewModel> {
  @override
  Widget build(BuildContext context, ProductViewModel viewModel) {
    return _WrapItemList(
      wrap: viewModel.itemDisplaySettings.wrapItems,
      spacing: viewModel.spacing,
      runSpacing: viewModel.runSpacing,
      gridCols: viewModel.itemDisplaySettings.gridCols,
      children: viewModel.items!
          .asMap()
          .map((index, item) {
            return MapEntry(index, _VerticalItem(item));
          })
          .values
          .toList(),
    );
  }
}

class _ProductHorizontalDisplay extends ViewModelWidget<ProductViewModel> {
  @override
  Widget build(BuildContext context, ProductViewModel viewModel) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: ScrollController(),
      child: _WrapItemList(
        wrap: true,
        spacing: viewModel.spacing,
        runSpacing: viewModel.runSpacing,
        direction: Axis.vertical,
        gridCols: 3,
        children: viewModel.items!
            .asMap()
            .map((index, item) {
              return MapEntry(index, _HorizontalItem(item));
            })
            .values
            .toList(),
      ),
    );
  }
}

class _HorizontalItem extends ViewModelWidget<ProductViewModel> {
  final ProductOverview _item;

  _HorizontalItem(this._item);

  @override
  Widget build(BuildContext context, ProductViewModel viewModel) {
    return InkWell(
      key: Key("actionProduct${_item.productId}"),
      onTap: () => viewModel.onItemTap(_item),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            width: viewModel.itemWidth(context) * 2,
            decoration: BoxDecoration(
              color: AppColor.white,
              boxShadow: AppStyle.cardShadow,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                NetworkImageLoader(
                  image: _item.primaryImageUrl,
                  fit: BoxFit.cover,
                  height: 100,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_item.name!,
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            textScaleFactor: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ProductTextStyle.title(viewModel.itemDisplaySettings.gridCols, color: viewModel.itemDisplaySettings.textColor)),
                        VerticalSpacing.d10px(),
                        _PriceSection(_item, Alignment.centerLeft)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          if (_item.ribbonText != null)
            Positioned(
                top: 10,
                left: 0,
                child: Container(
                    decoration: BoxDecoration(color: _item.ribbonTextBackgroundColor),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Text(
                      _item.ribbonText!,
                      style: const TextStyle(fontSize: 12, color: AppColor.white),
                      textScaleFactor: 1,
                    ))),
        ],
      ),
    );
  }
}

class _VerticalItem extends ViewModelWidget<ProductViewModel> {
  final ProductOverview _item;

  _VerticalItem(this._item);

  @override
  Widget build(BuildContext context, ProductViewModel viewModel) {
    return InkWell(
      key: Key("actionProduct${_item.productId}"),
      onTap: () => viewModel.onItemTap(_item),
      child: Container(
        width: viewModel.itemWidth(context),
        decoration: BoxDecoration(color: AppColor.white, boxShadow: AppStyle.mildCardShadow, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                      child: Container(
                        color: AppColor.white,
                        padding: const EdgeInsets.all(5),
                        child: NetworkImageLoader(
                          image: _item.primaryImageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (_item.ribbonText != null)
                      Positioned(
                          bottom: 0,
                          left: 0,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: _item.ribbonTextBackgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: _item.ribbonTextBackgroundColor,
                                      offset: const Offset(-0.5, 0),
                                    ),
                                  ],
                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(8))),
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                              child: Text(
                                _item.ribbonText!,
                                style: const TextStyle(fontSize: 12, color: AppColor.white),
                                textScaleFactor: 1,
                              ))),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    _item.name!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: 1,
                    style: ProductTextStyle.title(
                      viewModel.itemDisplaySettings.gridCols,
                      color: viewModel.itemDisplaySettings.textColor,
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10), child: _PriceSection(_item, Alignment.centerLeft))
          ],
        ),
      ),
    );
  }
}

class _PriceSection extends ViewModelWidget<ProductViewModel> {
  final ProductOverview _item;
  final Alignment alignment;

  _PriceSection(this._item, this.alignment);

  @override
  Widget build(BuildContext context, ProductViewModel viewModel) {
    if (_item.productAction == ProductInfoDisplayType.addToCart) {
      List<Widget> priceList = [
        Text(
          "${_item.pricing!.formattedNewPrice}",
          style:
              ProductTextStyle.price(viewModel.itemDisplaySettings.gridCols, color: viewModel.itemDisplaySettings.textColor).copyWith(color: _item.pricing!.strikeThroughEnabled! ? const Color(0xffC30000) : AppColor.primaryDark),
          textScaleFactor: 1,
        ),
        if (_item.pricing!.strikeThroughEnabled!)
          Text(
            _item.pricing!.formattedOldPrice!,
            textScaleFactor: 1,
            style: ProductTextStyle.strikedPrice(viewModel.itemDisplaySettings.gridCols, color: AppColor.green).copyWith(fontWeight: FontWeight.normal, color: const Color(0xff666666), decoration: TextDecoration.lineThrough),
          )
      ];

      return Column(
        crossAxisAlignment: alignment == Alignment.center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          if (_item.pricing!.badgeText != null)
            Container(
              padding: const EdgeInsets.only(top: 5),
              alignment: alignment,
              child: Text(
                _item.pricing!.badgeText!,
                textAlign: TextAlign.center,
                style: ProductTextStyle.badge(viewModel.itemDisplaySettings.gridCols, color: viewModel.itemDisplaySettings.textColor),
              ),
            ),
          Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 5,
            children: priceList,
          ),
          if (_item.pricing!.strikeThroughEnabled!)
            Container(
              padding: const EdgeInsets.only(top: 5),
              alignment: alignment,
              child: Text(
                _item.pricing!.discountText!,
                textAlign: TextAlign.center,
                style: ProductTextStyle.badge(viewModel.itemDisplaySettings.gridCols, color: AppColor.offerText),
              ),
            ),
        ],
      );
    }

    return Column(
      children: [
        if (_item.alertMe! && !_item.showPrice!)
          Padding(
            padding: viewModel.itemDisplaySettings.displayDirection == DisplayDirection.horizontal ? EdgeInsets.zero : const EdgeInsets.only(top: 10.0),
            child: Container(
                alignment: alignment,
                child: Button.outline("AlertMe!®",
                    valueKey: const Key('btnAlert'),
                    height: viewModel.itemDisplaySettings.displayDirection == DisplayDirection.horizontal ? 30 : 40,
                    width: viewModel.itemDisplaySettings.displayDirection == DisplayDirection.horizontal ? 100 : double.infinity,
                    borderRadius: BorderRadius.circular(5.0),
                    textStyle: AppTextStyle.title.copyWith(fontSize: 14),
                    borderColor: AppColor.primaryDark, onPressed: () async {
                  // if (!locator<AuthenticationService>().isAuthenticated){
                  //   bool authenticated = await signInRequest(Images.iconAlertBottom, title: "AlertMe!®", content: "Add you Item to Price Alert. Get live update of item availability.");
                  //   if (!authenticated) return;
                  // }
                  //
                  // await locator<DialogService>().showBottomSheet(title: "AlertMe!®", child: AlertMeBottomSheet(ProductDetails(overview: _item), showViewButton: true,));
                })),
          )
        else
          Container(
              alignment: alignment,
              child: Text(
                _item.availabilityText!,
                textAlign: TextAlign.center,
                style: AppTextStyle.title.copyWith(color: AppColor.red, fontSize: viewModel.itemDisplaySettings.gridCols > 1 ? 14 : 17),
              )),
      ],
    );
  }
}

class _WrapItemList extends StatelessWidget {
  final bool wrap;
  final Axis direction;
  final double runSpacing;
  final double spacing;
  final int? gridCols;
  final List<Widget> children;

  _WrapItemList({this.wrap = false, this.direction = Axis.horizontal, this.gridCols, this.runSpacing = 0.0, this.spacing = 0.0, this.children = const <Widget>[]});

  @override
  Widget build(BuildContext context) {
    if (wrap)
      return Container(
          padding: EdgeInsets.symmetric(horizontal: spacing),
          margin: const EdgeInsets.only(top: 15),
          child: direction == Axis.vertical
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildWrapItems(),
                )
              : Column(
                  children: _buildWrapItems(),
                ));
    else {
      return Container(
        width: double.infinity,
        child: SingleChildScrollView(
            scrollDirection: direction,
            controller: ScrollController(keepScrollOffset: false),
            padding: EdgeInsets.symmetric(horizontal: spacing, vertical: spacing),
            child: IntrinsicHeight(
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children
                      .map(
                        (e) => Padding(
                          padding: EdgeInsets.only(right: spacing),
                          child: e,
                        ),
                      )
                      .toList()),
            )),
      );
    }
  }

  List<Widget> _buildWrapItems() {
    if (gridCols! <= 1) {
      return children
          .expand((e) => [
                e,
                SizedBox(
                  height: children.length > 1 ? spacing : 0,
                )
              ])
          .toList();
    }

    List<Widget> items = [];
    List<Widget> childItem = children;

    while (childItem.length > 0) {
      List<Widget> tuple = childItem.take(gridCols!).toList();

      tuple.forEach((element) {
        if (childItem.length > 0) childItem.removeAt(0);
      });

      if (direction == Axis.vertical) {
        Widget item = IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: tuple
                .expand((e) => [
                      e,
                      SizedBox(
                        height: spacing,
                      )
                    ])
                .toList(),
          ),
        );

        items.add(item);
      } else {
        Widget item = IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: tuple.map((e) => e).toList(),
          ),
        );
        items.add(item);
      }
    }

    if (direction == Axis.vertical) {
      return items
          .expand((element) => [
                element,
                SizedBox(
                  width: spacing,
                )
              ])
          .toList();
    }

    return items
        .expand((element) => [
              element,
              SizedBox(
                height: spacing,
              )
            ])
        .toList();
  }
}
