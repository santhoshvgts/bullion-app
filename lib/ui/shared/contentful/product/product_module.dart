import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bullion/core/constants/display_direction.dart';
import 'package:bullion/core/constants/display_type.dart';
import 'package:bullion/core/constants/module_type.dart';
import 'package:bullion/core/models/module/module_settings.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/models/module/product_item.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/services/shared/analytics_service.dart';
import 'package:bullion/services/shared/sign_in_request.dart';
import 'package:bullion/services/toast_service.dart';
import 'package:bullion/ui/shared/contentful/dynamic/product/product_detail_section.dart';
import 'package:bullion/ui/shared/contentful/module/module_ui_container.dart';
import 'package:bullion/ui/shared/contentful/product/product_text_style.dart';
import 'package:bullion/ui/shared/contentful/product/product_view_model.dart';
import 'package:bullion/ui/shared/toast/actionable_toast.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/network_image_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked/stacked.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../helper/utils.dart';
import '../../../../locator.dart';
import '../../../../router.dart';
import '../../../../services/authentication_service.dart';
import '../../../../services/shared/navigator_service.dart';

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

  ProductModule(this.settings,
      {super.key,
      this.controller,
      this.sortFilterWidget,
      this.isLoadingFilter = false});

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
        if (viewModel.settings!.moduleType == ModuleType.productList)
          sortFilterWidget!,

        if (viewModel.itemDisplaySettings.displayType == ProductDisplayType.priceComparison)
          _ProductPriceComparisonDisplay()
        else if (viewModel.settings!.displaySettings!.itemDisplaySettings.displayDirection == DisplayDirection.vertical)
          _ProductVerticalDisplay()
        else
          _ProductHorizontalDisplay()
      ],
    );
  }
}

class _ProductPriceComparisonDisplay extends ViewModelWidget<ProductViewModel> {
  @override
  Widget build(BuildContext context, ProductViewModel viewModel) {
    return ProductWrapItemList(
      wrap: viewModel.itemDisplaySettings.wrapItems,
      spacing: 0,
      runSpacing: 0,
      gridCols: viewModel.itemDisplaySettings.gridCols,
      children: viewModel.items!
          .asMap()
          .map((index, item) {
        return MapEntry(index, _PriceComparisonItemCard(item, index));
      }).values.toList(),
    );
  }
}

class _ProductVerticalDisplay extends ViewModelWidget<ProductViewModel> {

  bool eventLogged = false;

  @override
  Widget build(BuildContext context, ProductViewModel viewModel) {
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (visibilityInfo) {

        double visiblePercentage = visibilityInfo.visibleFraction * 100;

        if (visiblePercentage > 25 && eventLogged == false) {
          locator<AnalyticsService>().logViewItemList(
              viewModel.settings?.id,
              viewModel.settings?.title,
              viewModel.items
          );
          eventLogged = true;
        }

      },
      child: ProductWrapItemList(
        wrap: viewModel.itemDisplaySettings.wrapItems,
        spacing: viewModel.spacing,
        runSpacing: viewModel.runSpacing,
        gridCols: viewModel.itemDisplaySettings.gridCols,
        children: viewModel.items!
            .asMap()
            .map((index, item) {
              return MapEntry(index, VerticalItem(item,
                itemWidth: viewModel.itemWidth(context),
                wrapItems: viewModel.itemDisplaySettings.wrapItems,
                gridCols: viewModel.itemDisplaySettings.gridCols,
                textColor: viewModel.itemDisplaySettings.textColor,
                displayDirection: viewModel.itemDisplaySettings.displayDirection,
                onItemTap: (ProductOverview overview) {
                  viewModel.onItemTap(overview, index: index);
                },
              ));
            })
            .values
            .toList(),
      ),
    );
  }
}

class _ProductHorizontalDisplay extends ViewModelWidget<ProductViewModel> {
  @override
  Widget build(BuildContext context, ProductViewModel viewModel) {



    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: ScrollController(),
      child: ProductWrapItemList(
        wrap: true,
        spacing: viewModel.spacing,
        runSpacing: viewModel.runSpacing,
        direction: Axis.vertical,
        gridCols: 3,
        children: viewModel.items!
            .asMap()
            .map((index, item) {
              return MapEntry(index, _HorizontalItem(item, index));
            })
            .values
            .toList(),
      ),
    );
  }
}

class _HorizontalItem extends ViewModelWidget<ProductViewModel> {
  final ProductOverview _item;
  int index;

  _HorizontalItem(this._item, this.index);

  @override
  Widget build(BuildContext context, ProductViewModel viewModel) {
    return InkWell(
      key: Key("actionProduct${_item.productId}"),
      onTap: () => viewModel.onItemTap(_item, index: index),
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
                            
                            overflow: TextOverflow.ellipsis,
                            style: ProductTextStyle.title(
                                viewModel.itemDisplaySettings.gridCols,
                                color:
                                    viewModel.itemDisplaySettings.textColor)),
                        VerticalSpacing.d10px(),
                        _PriceSection(
                          item: _item,
                          alignment: Alignment.centerLeft,
                          gridCols: viewModel.itemDisplaySettings.gridCols,
                          textColor: viewModel.itemDisplaySettings.textColor,
                          displayDirection: viewModel.itemDisplaySettings.displayDirection,
                        )
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
                    decoration:
                        BoxDecoration(color: _item.ribbonTextBackgroundColor),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Text(
                      _item.ribbonText!,
                      style:
                          const TextStyle(fontSize: 12, color: AppColor.white),
                      
                    ))),
        ],
      ),
    );
  }
}

class VerticalItem extends StatelessWidget {

  final ProductOverview _item;
  final double itemWidth;
  final bool wrapItems;
  final int gridCols;
  final Color textColor;
  final String displayDirection;
  Function(ProductOverview) onItemTap;

  VerticalItem(this._item, { required this.itemWidth, required this.wrapItems, required this.gridCols, required this.textColor, required this.onItemTap, this.displayDirection = DisplayDirection.vertical });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      key: Key("actionProduct${_item.productId}"),
      onTap: () => onItemTap(_item),
      child: Container(
        width: itemWidth,
        decoration: BoxDecoration(
          // color: AppColor.secondaryBackground.withOpacity(0.7),
          color: AppColor.white,
          border: Border.all(color: AppColor.border, width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        width: itemWidth,
                        height: itemWidth + 20,
                        color: AppColor.secondaryBackground,
                        child: NetworkImageLoader(
                          image: _item.primaryImageUrl,
                          fit: BoxFit.fitWidth,
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
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      // bottomLeft: Radius.circular(10),
                                  )
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 2),
                              child: Text(
                                _item.ribbonText!,
                                style: const TextStyle(
                                    fontSize: 12, color: AppColor.white),
                                
                              ))),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    _item.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: ProductTextStyle.title(
                      gridCols,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PriceSection(
                    item: _item,
                    alignment: Alignment.centerLeft,
                    gridCols: gridCols,
                    textColor: textColor,
                    displayDirection: displayDirection,
                  ),

                  if (_item.showDealProgress)
                    Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VerticalSpacing.d10px(),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: LinearProgressIndicator(
                          value: _item.soldPercentage,
                        ),
                      ),

                      VerticalSpacing.d2px(),

                      Text("${(_item.soldPercentage * 100).round()}% Sold",  style: AppTextStyle.labelSmall,),

                      VerticalSpacing.d5px(),

                      Text("Only ${_item.onHand} left",  style: AppTextStyle.labelMedium.copyWith(
                          color: AppColor.dealsRed,
                          fontWeight: FontWeight.w600
                      ),),

                      VerticalSpacing.custom(value: 7),

                      if (_item.formattedDealEndsIn != "-")
                        StreamBuilder(
                          stream: Stream.periodic(const Duration(seconds: 1)),
                          builder: (context, snapshot) {
                            return Text(
                              "Ends in ${_item.formattedDealEndsIn}", style: AppTextStyle.bodySmall.copyWith(fontSize: 11, color: AppColor.dealsRed),
                            );
                          }
                        ),


                    ],
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class _PriceComparisonItemCard extends ViewModelWidget<ProductViewModel> {
  final ProductOverview _item;
  final int index;

  _PriceComparisonItemCard(this._item, this.index);

  @override
  Widget build(BuildContext context, ProductViewModel viewModel) {
    double _itemWidth = viewModel.itemWidth(context);
    return InkWell(
      key: Key("actionProduct${_item.productId}"),
      onTap: () => viewModel.onItemTap(_item, index: index),
      child: Container(
        width: _itemWidth,
        decoration: BoxDecoration(
          color: index %2 == 0 ? AppColor.white : AppColor.secondaryBackground,
          border: viewModel.itemDisplaySettings.wrapItems ? null : Border.all(color: AppColor.border),
          borderRadius: BorderRadius.circular(0),
        ),
        padding: EdgeInsets.symmetric(vertical: index %2 != 0 ? 10 : 0 ),
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0)
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        width: 110,
                        height: 110,
                        child: NetworkImageLoader(
                          image: _item.primaryImageUrl,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    if (_item.ribbonText != null)
                      Positioned(
                          top: 0,
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
                                borderRadius: const BorderRadius.all(Radius.circular(5))
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                              child: Text(
                                _item.ribbonText!,
                                style: const TextStyle(fontSize: 12, color: AppColor.white),
                              ),
                          ),
                      ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _item.name!,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: ProductTextStyle.title(2,
                            color: viewModel.itemDisplaySettings.textColor,
                          ),
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(child: _PriceSection(
                              item: _item,
                              alignment: Alignment.centerLeft,
                              gridCols: viewModel.itemDisplaySettings.gridCols,
                              textColor: viewModel.itemDisplaySettings.textColor,
                              displayDirection: viewModel.itemDisplaySettings.displayDirection,
                            ),),

                            HorizontalSpacing.d10px(),

                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                height: 35,
                                child: CircleAvatar(
                                  backgroundColor: AppColor.secondary,
                                  child: IconButton(
                                    onPressed: () {
                                      locator<NavigationService>().pushNamed(_item.targetUrl, arguments: ProductDetails(overview: _item));
                                    },
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.navigate_next,  color: AppColor.white,)
                                  ),
                                ),
                              )
                            )
                          ],
                        ),

                        if (_item.competitorPrices?.where((element) => element.isLowest == true).isEmpty == true && _item.productAction == ProductInfoDisplayType.addToCart)
                          Container(
                            decoration: BoxDecoration(
                                color: AppColor.greenText,
                                borderRadius: BorderRadius.circular(5)
                            ),
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                            child: Text("Lowest Price",
                              style: AppTextStyle.labelSmall.copyWith(color: AppColor.white),
                            )
                          ),

                      ],
                    ),
                  ),
                ),
              ],
            ),

            VerticalSpacing.d10px(),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                decoration: BoxDecoration(
                    color: AppColor.white,
                    border: Border.all(
                        color: AppColor.border,
                    ),
                    borderRadius: BorderRadius.circular(5)
                ),
                margin: const EdgeInsets.only(left: 10),
                child: IntrinsicHeight(
                  child: CompetitorPricingSection(_item.competitorPrices ?? []),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class _PriceSection extends StatelessWidget {
  final ProductOverview item;
  final Alignment alignment;
  final int gridCols;
  final Color textColor;
  final String displayDirection;

  _PriceSection(
    { required this.item,
      required this.alignment,
      required this.gridCols,
      required this.textColor,
      required this.displayDirection});

  @override
  Widget build(BuildContext context) {
    if (item.productAction == ProductInfoDisplayType.addToCart) {
      List<Widget> priceList = [
        Text(
          "${item.pricing!.formattedNewPrice}",
          style: ProductTextStyle.price(gridCols,
                  color: textColor)
              .copyWith(
                  color: item.pricing!.strikeThroughEnabled!
                      ? const Color(0xffC30000)
                      : AppColor.primaryDark),
          
        ),
        if (item.pricing!.strikeThroughEnabled!)
          Text(
            item.pricing!.formattedOldPrice!,
            
            style: ProductTextStyle.strikedPrice(
                    gridCols,
                    color: AppColor.green)
                .copyWith(
                    fontWeight: FontWeight.normal,
                    color: const Color(0xff666666),
                    decoration: TextDecoration.lineThrough),
          )
      ];

      return Column(
        crossAxisAlignment: alignment == Alignment.center
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          if (item.pricing!.badgeText != null)
            Container(
              padding: const EdgeInsets.only(top: 5),
              alignment: alignment,
              child: Text(
                item.pricing!.badgeText!,
                textAlign: TextAlign.center,
                style: ProductTextStyle.badge(
                    gridCols,
                    color: textColor),
              ),
            ),
          Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 5,
            children: priceList,
          ),
          if (item.pricing!.strikeThroughEnabled!)
            Container(
              padding: const EdgeInsets.only(top: 5),
              alignment: alignment,
              child: Text(
                item.pricing!.discountText!,
                textAlign: TextAlign.left,
                style: ProductTextStyle.badge(
                    gridCols,
                    color: AppColor.offerText),
              ),
            ),
        ],
      );
    }

    return Column(
      children: [
        if (item.alertMe! && !item.showPrice!)
          Padding(
            padding: displayDirection == DisplayDirection.horizontal
                ? EdgeInsets.zero
                : const EdgeInsets.only(top: 10.0),
            child: Container(
                alignment: alignment,
                child: Button.outline("Notify Me",
                    valueKey: const Key('btnAlert'),
                    height: 35,
                    width: displayDirection == DisplayDirection.horizontal
                        ? 100
                        : double.infinity,
                    textStyle: AppTextStyle.titleLarge.copyWith(fontSize: 14, color: AppColor.primary),
                    borderColor: AppColor.primary,
                    onPressed: () async {
                      if (!locator<AuthenticationService>().isAuthenticated) {
                        bool authenticated = await signInRequest(
                            Images.iconAlertBottom,
                            title: "Notify Me",
                            content:
                            "Add you Item to Alert. Get live update of item availability.");
                        if (!authenticated) return;
                      }

                      var result = await locator<NavigationService>().pushNamed(Routes.editAlertMe, arguments: { "productDetails": item });

                      if (result == true) {
                        locator<ToastService>().showWidget(child: ActionableToast(
                          title: "Notify Me",
                          content: "Added Successfully",
                          onActionTap: () {
                            locator<NavigationService>().pushNamed(Routes.alerts, arguments: 2);
                          },
                          icon: CupertinoIcons.check_mark_circled_solid,
                          actionText: "View",
                        ));
                      }
                  }
                )
            ),
          )
        else
          Container(
              alignment: alignment,
              child: Text(
                item.availabilityText!,
                textAlign: TextAlign.center,
                style: AppTextStyle.titleLarge.copyWith(
                    color: AppColor.red,
                    fontSize: gridCols > 1 ? 14 : 17),
              )),
      ],
    );
  }
}

class ProductWrapItemList extends StatelessWidget {
  final bool wrap;
  final Axis direction;
  final double runSpacing;
  final double spacing;
  final int? gridCols;
  final List<Widget> children;

  ProductWrapItemList(
      {this.wrap = false,
      this.direction = Axis.horizontal,
      this.gridCols,
      this.runSpacing = 0.0,
      this.spacing = 0.0,
      this.children = const <Widget>[]});

  @override
  Widget build(BuildContext context) {
    if (wrap) {
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
                )
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
            scrollDirection: direction,
            controller: ScrollController(keepScrollOffset: false),
            padding: EdgeInsets.symmetric(horizontal: spacing, vertical: spacing,),
            child: IntrinsicHeight(
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children.map(
                        (e) => Padding(
                          padding: EdgeInsets.only(right: spacing),
                          child: e,
                        ),
                      ).toList()),
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

    while (childItem.isNotEmpty) {
      List<Widget> tuple = childItem.take(gridCols!).toList();

      tuple.forEach((element) {
        if (childItem.isNotEmpty) childItem.removeAt(0);
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
                      ),
                    ])
                .toList(),
          ),
        );

        items.add(item);
      } else {
        Widget item = IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: tuple.asMap().map((index, e) => MapEntry(
              index,
              Row(
                children: [
                  e,
                ],
              ),
            )).values.toList(),
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

    return items.expand((element) {
      return [
        element,
        SizedBox(
          height: spacing,
        )
        // const Divider(
        //   color: AppColor.divider,
        //   thickness: 1,
        //   height: 1,
        // )
      ];
    }).toList();
  }
}
