import 'package:bullion/core/models/module/cart/cart_item.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/widgets/network_image_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartItemCard extends StatelessWidget {
  final CartItem _item;
  final Function(CartItem)? onIncrease;
  final Function(CartItem)? onDecrease;
  final Function(CartItem, int)? onValueChange;
  final Function(CartItem)? onRemove;

  CartItemCard(this._item,
      {this.onDecrease, this.onIncrease, this.onValueChange, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: AppColor.white,
          padding:
              const EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  locator<NavigationService>().pushNamed(_item.targetUrl);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColor.divider),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: NetworkImageLoader(
                        image: _item.primaryImageUrl,
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    HorizontalSpacing.d10px(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  _item.productName!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textScaleFactor: 1,
                                  style: AppTextStyle.titleSmall,
                                ),
                              ),
                            ],
                          ),
                          VerticalSpacing.d5px(),
                          Text(
                            _item.formattedUnitPrice!,
                            style: AppTextStyle.titleSmall,
                            textScaleFactor: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: AppColor.secondaryBackground,
                                  border: Border.all(
                                      color: Colors.black12, width: 0.25),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _item.loading = true;
                                        onDecrease!(_item);
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.minus_circle,
                                        size: 22,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                    HorizontalSpacing.d10px(),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          bottom: 2.0, right: 5),
                                      width: 35,
                                      child: Text(
                                        _item.qtyController.text,
                                        style: AppTextStyle.bodyMedium.copyWith(
                                          color: AppColor.text,
                                          fontFamily: AppTextStyle.fontFamily,
                                        ),
                                        textAlign: TextAlign.center,
                                        textScaleFactor: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _item.loading = true;
                                        onIncrease!(_item);
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.add_circled,
                                        size: 22,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _item.loading = true;
                                  onRemove!(_item);
                                },
                                icon: const Icon(
                                  CupertinoIcons.delete,
                                  color: AppColor.red,
                                  size: 22,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_item.offers != null)
                ..._item.offers!.map((offer) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      offer,
                      textScaleFactor: 1,
                      style: AppTextStyle.bodyLarge
                          .copyWith(color: AppColor.green),
                    ),
                  );
                }).toList(),
              VerticalSpacing.d5px(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // EditText.outline(
                  //   "",
                  //   Key("addToCart"),
                  //   _item.qtyController,
                  //   TextInputType.numberWithOptions(
                  //     decimal: false,
                  //   ),
                  //   prefixIcon: IconButton(
                  //     icon: Icon(
                  //       Icons.remove,
                  //       size: 17,
                  //       color: AppColor.text,
                  //     ),
                  //     onPressed: () {
                  //       _item.loading = true;
                  //       onDecrease!(_item);
                  //     },
                  //   ),
                  //   suffixIcon: IconButton(
                  //     icon: Icon(
                  //       Icons.add,
                  //       size: 17,
                  //       color: AppColor.text,
                  //     ),
                  //     onPressed: int.parse(_item.qtyController.text) >= 9999
                  //         ? null
                  //         : () {
                  //             _item.loading = true;
                  //             onIncrease!(_item);
                  //           },
                  //   ),
                  //   height: 37,
                  //   width: 150,
                  //   showIOSDoneOverlay: true,
                  //   focusNode: _item.qtyFocus,
                  //   textAlign: TextAlign.center,
                  //   fillColor: AppColor.white,
                  //   marginEdgeInsets: EdgeInsets.only(right: 10.0),
                  //   validate: false,
                  //   autofocus: false,
                  //   textInputAction: TextInputAction.done,
                  //   borderRadius: BorderRadius.circular(5.0),
                  //   contentPadding: EdgeInsets.zero,
                  //   inputFormatter: [
                  //     LengthLimitingTextInputFormatter(4),
                  //     FilteringTextInputFormatter.allow(new RegExp('[0-9]+'))
                  //   ],
                  //   // onChanged: (val) {
                  //   //   if (!_item.loading){
                  //   //     _item.loading = true;
                  //   //     onValueChange(_item, int.parse(val));
                  //   //   }
                  //   // },
                  //   onSubmitted: (val) {
                  //     if (!_item.loading) {
                  //       _item.loading = true;
                  //       onValueChange!(_item, int.parse(val));
                  //     }
                  //   },
                  // ),
                ],
              ),
              if (_item.warnings != null)
                ..._item.warnings!.map((warning) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      warning,
                      textScaleFactor: 1,
                      style:
                          AppTextStyle.bodyLarge.copyWith(color: AppColor.red),
                    ),
                  );
                }).toList(),
            ],
          ),
        ),
        if (_item.loading)
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: AppColor.white.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    valueColor: AlwaysStoppedAnimation(AppColor.primary),
                  ),
                ),
              )),
      ],
    );
  }
}
