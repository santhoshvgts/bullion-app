import 'package:bullion/core/models/module/cart/cart_item.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
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
          padding: const EdgeInsets.only(
            left: 10,
            top: 12,
            right: 10,
            bottom: 5,
          ),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor.divider, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      locator<NavigationService>().pushNamed(_item.targetUrl);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColor.divider, width: 0.5),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: NetworkImageLoader(
                        image: _item.primaryImageUrl,
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  HorizontalSpacing.d10px(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _item.productName!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor: 1,
                          style: AppTextStyle.bodyMedium,
                        ),
                        VerticalSpacing.d5px(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                _item.formattedUnitPrice!,
                                style: AppTextStyle.titleMedium,
                                textScaleFactor: 1,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          border: Border.all(color: AppColor.border)
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 35,
                                            width: 40,
                                            child: IconButton(
                                              padding: const EdgeInsets.all(2),
                                              icon: const Icon(
                                                Icons.remove,
                                                size: 20,
                                                color: AppColor.text,
                                              ),
                                              onPressed: () {
                                                _item.loading = true;
                                                onDecrease!(_item);
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              height: 35,
                                              child: EditTextField(
                                                "",
                                                _item.qtyController,
                                                key: const ValueKey("txtQuantity"),
                                                textAlign: TextAlign.center,
                                                textInputAction: TextInputAction.done,
                                                isInputDecorationNone: true,
                                                textStyle: AppTextStyle.titleSmall,
                                                padding: EdgeInsets.zero,
                                                onSubmitted: (val) {
                                                  if (!_item.loading){
                                                    _item.loading = true;
                                                    onValueChange!(_item, int.parse(val));
                                                  }
                                                },
                                              ),
                                            ),
                                          ),

                                          SizedBox(
                                            height: 35,
                                            width: 40,
                                            child: IconButton(
                                              padding: const EdgeInsets.all(2),
                                              icon: const Icon(
                                                Icons.add,
                                                size: 20,
                                                color: AppColor.text,
                                              ),
                                              onPressed: () {
                                                _item.loading = true;
                                                onIncrease!(_item);
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   height: 30,
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(50),
                                  //     color: AppColor.secondaryBackground,
                                  //     border: Border.all(
                                  //       color: Colors.black12,
                                  //       width: 0.25,
                                  //     ),
                                  //   ),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.center,
                                  //     children: [
                                  //       InkWell(
                                  //         onTap: () {
                                  //           _item.loading = true;
                                  //           onDecrease!(_item);
                                  //         },
                                  //         child: const Padding(
                                  //           padding: EdgeInsets.symmetric(
                                  //             vertical: 2,
                                  //             horizontal: 5,
                                  //           ),
                                  //           child: Icon(
                                  //             CupertinoIcons.minus_circle,
                                  //             size: 20,
                                  //             color: AppColor.primary,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //       HorizontalSpacing.d10px(),
                                  //       Container(
                                  //         padding: const EdgeInsets.only(
                                  //           bottom: 2.0,
                                  //           right: 5,
                                  //         ),
                                  //         width: 35,
                                  //         child: Text(
                                  //           _item.qtyController.text,
                                  //           style: AppTextStyle.bodyMedium
                                  //               .copyWith(
                                  //             color: AppColor.text,
                                  //             fontFamily:
                                  //                 AppTextStyle.fontFamily,
                                  //           ),
                                  //           textAlign: TextAlign.center,
                                  //           textScaleFactor: 1,
                                  //           overflow: TextOverflow.ellipsis,
                                  //         ),
                                  //       ),
                                  //       InkWell(
                                  //         onTap: () {
                                  //           _item.loading = true;
                                  //           onIncrease!(_item);
                                  //         },
                                  //         child: const Padding(
                                  //           padding: EdgeInsets.symmetric(
                                  //             horizontal: 5,
                                  //             vertical: 2,
                                  //           ),
                                  //           child: Icon(
                                  //             CupertinoIcons.add_circled,
                                  //             size: 20,
                                  //             color: AppColor.primary,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  IconButton(
                                    onPressed: () {
                                      _item.loading = true;
                                      onRemove!(_item);
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.delete,
                                      color: AppColor.red,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              if (_item.offers != null)
                ..._item.offers!.map((offer) {
                  return Column(
                    children: [
                      AppStyle.dottedDivider,
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          children: [
                            Image.asset(
                              Images.discountOffers,
                              width: 16,
                              color: AppColor.green,
                            ),
                            HorizontalSpacing.d5px(),
                            Expanded(
                              child: Text(
                                offer,
                                textScaleFactor: 1,
                                style: AppTextStyle.bodySmall.copyWith(
                                  color: AppColor.green,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              // VerticalSpacing.d5px(),
              if (_item.warnings != null)
                ..._item.warnings!.map((warning) {
                  return Column(
                    children: [
                      AppStyle.dottedDivider,
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          children: [
                            Image.asset(
                              Images.warning,
                              width: 16,
                              color: AppColor.redOrange,
                            ),
                            HorizontalSpacing.d5px(),
                            Expanded(
                              child: Text(
                                warning,
                                textScaleFactor: 1,
                                style: AppTextStyle.bodySmall.copyWith(
                                  color: AppColor.redOrange,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
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
            ),
          ),
      ],
    );
  }
}
