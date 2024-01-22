import 'package:bullion/core/constants/display_type.dart';
import 'package:bullion/core/constants/module_type.dart';
import 'package:bullion/core/models/module/cart/cart_item.dart';
import 'package:bullion/core/models/module/cart/display_message.dart';
import 'package:bullion/core/models/module/cart/order_total_summary.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/shared/cart/cart_summary_help_text.dart';
import 'package:bullion/ui/shared/cart/inline_block_section.dart';
import 'package:bullion/ui/shared/cart/warning_card.dart';
import 'package:bullion/ui/shared/contentful/banner/banner_ui_container.dart';
import 'package:bullion/ui/shared/contentful/product/product_module.dart';
import 'package:bullion/ui/shared/contentful/standard/standard_module.dart';
import 'package:bullion/ui/view/cart/cart_item_card.dart';
import 'package:bullion/ui/view/cart/cart_view_model.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:bullion/ui/widgets/page_will_pop.dart';
import 'package:bullion/ui/widgets/tap_outside_unfocus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CartPage extends StatelessWidget with WidgetsBindingObserver {
  bool fromMain = false;

  late CartViewModel _cartViewModel;
  late BuildContext _buildContext;

  DisplayMessage? redirectDisplayMessage;

  CartPage({this.redirectDisplayMessage, this.fromMain = false});

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return ViewModelBuilder<CartViewModel>.reactive(
      onViewModelReady: (viewModel) {
        _cartViewModel = viewModel;
        viewModel.init();

        WidgetsBinding.instance.addObserver(this);
        Future.delayed(const Duration(milliseconds: 300), () {
          viewModel.displayMessage(redirectDisplayMessage);
        });
      },
      onDispose: (viewModel) {
        WidgetsBinding.instance.removeObserver(this);
      },
      builder: (context, viewModel, child) {
        return PageWillPop(
          child: Scaffold(
            key: viewModel.scaffoldKey,
            backgroundColor: viewModel.cartItems?.isEmpty == true
                ? AppColor.white
                : AppColor.secondaryBackground,
            appBar: AppBar(
              elevation: 0,
              title: Text(
                "Shopping Cart",
                textScaleFactor: 1,
                style: AppTextStyle.titleMedium.copyWith(
                    color: AppColor.text, fontFamily: AppTextStyle.fontFamily),
              ),
            ),
            body: viewModel.cart == null
                ? Container()
                : TapOutsideUnFocus(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: viewModel.isBusy
                              ? const SizedBox(
                                  height: 2,
                                  child: LinearProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                      AppColor.primary,
                                    ),
                                  ),
                                )
                              : Container(),
                        ),
                        Positioned.fill(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: RefreshIndicator(
                              onRefresh: () async {
                                return await viewModel.refresh();
                              },
                              child: SingleChildScrollView(
                                padding: EdgeInsets.zero,
                                child: Column(
                                  children: [
                                    if (redirectDisplayMessage
                                            ?.messageDisplayType ==
                                        MessageDisplayType.Inline)
                                      InlineBlockSection(
                                          redirectDisplayMessage!),
                                    if (viewModel.shoppingCart?.errors != null)
                                      _ErrorNotes(),
                                    if (viewModel.inlineMessage != null)
                                      InlineBlockSection(
                                          viewModel.inlineMessage!),
                                    if (viewModel.totalItems == 0)
                                      Container(
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                1.5,
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              Images.cartIcon,
                                              width: 150,
                                            ),
                                            VerticalSpacing.d30px(),
                                            const Text(
                                              "Your Cart is Empty",
                                              textScaleFactor: 1,
                                              textAlign: TextAlign.center,
                                              style: AppTextStyle.titleLarge,
                                            ),
                                            VerticalSpacing.d10px(),
                                            const Text(
                                              "Browse our wide selection of products and add your favorites to the cart.",
                                              textScaleFactor: 1,
                                              textAlign: TextAlign.center,
                                              style: AppTextStyle.bodySmall,
                                            ),
                                            VerticalSpacing.d30px(),
                                            Button(
                                              "Continue Shopping",
                                              width: 200,
                                              valueKey: const Key("btnShopNow"),
                                              onPressed: () {
                                                locator<NavigationService>()
                                                    .pop();
                                              },
                                            )
                                          ],
                                        ),
                                      )
                                    else
                                      ListView.separated(
                                        itemCount:
                                            viewModel.cartItems?.length ?? 0,
                                        shrinkWrap: true,
                                        primary: false,
                                        padding: const EdgeInsets.all(15),
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(
                                            height: 10,
                                          );
                                        },
                                        itemBuilder: (context, index) {
                                          return CartItemCard(
                                            viewModel.cartItems![index],
                                            onIncrease: (CartItem item) {
                                              viewModel.modifyItemQty(
                                                  item, item.quantity! + 1);
                                            },
                                            onDecrease: (CartItem item) {
                                              viewModel.modifyItemQty(
                                                  item, item.quantity! - 1);
                                            },
                                            onRemove: (CartItem item) {
                                              viewModel.removeItem(item);
                                            },
                                            onValueChange: (
                                              CartItem item,
                                              int qty,
                                            ) {
                                              viewModel.cartItems![index]
                                                  .quantity = qty;
                                              viewModel.modifyItemQty(
                                                item,
                                                qty,
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    if (viewModel.shoppingCart!.warnings !=
                                        null)
                                      ...viewModel.shoppingCart!.warnings!
                                          .map((warning) {
                                        return WarningCard(warning);
                                      }).toList(),
                                    if (viewModel.shoppingCart!
                                            .showPotentialSavings! &&
                                        viewModel.totalItems! > 0)
                                      _PotentialSavings(),
                                    if (viewModel.totalItems! > 0)
                                      _PromoCodeSection(),
                                    if (viewModel.totalItems! > 0)
                                      _OrderSummary(),
                                    if (viewModel.modules != null)
                                      ...viewModel.modules!.map((module) {
                                        switch (module!.moduleType) {
                                          case ModuleType.standard:
                                            return StandardModule(module);

                                          case ModuleType.product:
                                          case ModuleType.productList:
                                            return ProductModule(
                                              module,
                                            );

                                          case ModuleType.banner:
                                            return BannerModule(module);

                                          default:
                                            return Container();
                                        }
                                      }).toList(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            bottomNavigationBar: viewModel.totalItems! > 0
                ? SafeArea(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        boxShadow: AppStyle.topShadow,
                        color: AppColor.white,
                      ),
                      child: Wrap(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${viewModel.totalItems.toString()} ${viewModel.totalItems! > 1 ? "Items" : "Item"}",
                                        textScaleFactor: 1,
                                        style: AppTextStyle.labelMedium,
                                      ),
                                      Text(
                                        viewModel.shoppingCart
                                                ?.formattedOrderTotal
                                                .toString() ??
                                            "",
                                        textScaleFactor: 1,
                                        style: AppTextStyle.titleMedium,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Button(
                                    "Checkout",
                                    valueKey: const Key("CheckoutBtn"),
                                    color: AppColor.secondary,
                                    borderColor: AppColor.secondary,
                                    onPressed: () =>
                                        viewModel.onCheckoutClick(),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : null,
          ),
        );
      },
      viewModelBuilder: () => CartViewModel(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      print('Cart Page state: Paused');
    }
    if (state == AppLifecycleState.resumed) {
      if (ModalRoute.of(_buildContext) != null) {
        print(ModalRoute.of(_buildContext)!.settings.name);
        print("First ${ModalRoute.of(_buildContext)!.isFirst}");
        print("Current ${ModalRoute.of(_buildContext)!.isCurrent}");
        print("Active ${ModalRoute.of(_buildContext)!.isActive}");

        if (ModalRoute.of(_buildContext)!.isCurrent) {
          _cartViewModel.init();
        }
      }
      print('Cart Page state: Resumed');
    }
  }
}

class _PotentialSavings extends ViewModelWidget<CartViewModel> {
  @override
  Widget build(BuildContext context, CartViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 0),
      child: DottedBorder(
        color: const Color(0xff19A672),
        padding: EdgeInsets.zero,
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xff19A672).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Potential Savings",
                textScaleFactor: 1,
                style: AppTextStyle.bodySmall.copyWith(color: AppColor.primary),
                // style: AppTextStyle.titleSmall,
              ),
              VerticalSpacing.d5px(),
              Text(
                viewModel.shoppingCart!.potentialSavings!,
                // style: AppTextStyle.bodySmall.copyWith(color: AppColor.primary),
                style: AppTextStyle.titleSmall,
                textScaleFactor: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromoCodeSection extends ViewModelWidget<CartViewModel> {
  @override
  Widget build(BuildContext context, CartViewModel viewModel) {
    if (!viewModel.shoppingCart!.canAddPromoCode!) {
      return Container();
    }

    return InkWell(
      onTap: () {
        viewModel.couponInlineMessage = null;
        locator<DialogService>()
            .showBottomSheet(title: "Promo Code", child: _PromoCode(viewModel));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: DottedBorder(
          color: AppColor.outlineBorder,
          borderType: BorderType.RRect,
          radius: const Radius.circular(5),
          padding: EdgeInsets.zero,
          dashPattern: const [2, 2],
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 15.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Images.discountOffers,
                  width: 16,
                  color: AppColor.green,
                ),
                HorizontalSpacing.d10px(),
                const Text(
                  "Apply Promo Code",
                  style: AppTextStyle.titleSmall,
                  textScaleFactor: 1,
                ),
                const Spacer(),
                const Icon(CupertinoIcons.forward, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderSummary extends ViewModelWidget<CartViewModel> {
  @override
  Widget build(BuildContext context, CartViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 17,
            right: 15,
            top: 20,
          ),
          child: Text(
            "Order Summary",
            textScaleFactor: 1,
            style: AppTextStyle.titleMedium,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 15,
            bottom: 15,
          ),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              ListView.separated(
                itemCount: viewModel.shoppingCart!.orderTotalSummary!.length,
                primary: false,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 2),
                separatorBuilder: (context, index) {
                  return AppStyle.dottedDivider;
                },
                itemBuilder: (context, index) {
                  OrderTotalSummary item =
                      viewModel.shoppingCart!.orderTotalSummary![index];

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 15,
                    ),
                    child: Row(
                      children: [
                        Text(
                          item.key!,
                          textScaleFactor: 1,
                          style: AppTextStyle.bodyMedium,
                        ),
                        HorizontalSpacing.d5px(),
                        if (item.keyHelpText!.isNotEmpty)
                          InkWell(
                            onTap: () {
                              locator<DialogService>().showBottomSheet(
                                title: item.key,
                                child: CartSummaryHelpText(item.keyHelpText),
                              );
                            },
                            child: const Icon(
                              Icons.error_outline,
                              size: 18,
                              color: AppColor.text,
                            ),
                          ),
                        Expanded(child: Container()),
                        HorizontalSpacing.d15px(),
                        Text(
                          item.value!,
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: item.textColor,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              AppStyle.dottedDivider,
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                child: Row(
                  children: [
                    Text("Total",
                        textScaleFactor: 1,
                        style: AppTextStyle.titleLarge.copyWith(fontSize: 17)),
                    Expanded(child: Container()),
                    Text(viewModel.shoppingCart!.formattedOrderTotal!,
                        style: AppTextStyle.titleLarge.copyWith(fontSize: 17))
                  ],
                ),
              ),
              VerticalSpacing.d5px(),
            ],
          ),
        ),
      ],
    );
  }
}

class _ErrorNotes extends ViewModelWidget<CartViewModel> {
  @override
  Widget build(BuildContext context, CartViewModel viewModel) {
    return Column(
      children: viewModel.shoppingCart!.errors!.map((e) {
        if (e == null) return Container();
        return WarningCard(e);
      }).toList(),
    );
  }
}

class _PromoCode extends StatelessWidget {
  final CartViewModel viewModel;

  _PromoCode(this.viewModel) {
    viewModel.promoCodeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Wrap(
          children: [
            if (viewModel.couponInlineMessage != null)
              Container(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: viewModel.couponInlineMessage!.color.withOpacity(0.09),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            viewModel.couponInlineMessage!.icon,
                            color: viewModel.couponInlineMessage!.color,
                            size: 25,
                          )
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (viewModel.couponInlineMessage!.title != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    viewModel.couponInlineMessage!.title!,
                                    style: AppTextStyle.titleSmall.copyWith(color: viewModel.couponInlineMessage!.color),
                                    textAlign: TextAlign.start
                                  ),
                                ),
                              Text(viewModel.couponInlineMessage!.message!,
                                  style: AppTextStyle.bodySmall.copyWith(
                                      color:
                                      viewModel.couponInlineMessage!.color),
                                  textAlign: TextAlign.start),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            VerticalSpacing.d10px(),
            EditTextField(
              "Enter Promo Code",
              viewModel.promoCodeController,
              margin: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0, top: 5),
              textInputAction: TextInputAction.done,
              autoFocus: true,
              onChanged: (value) {
                setState((){});
              },
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 15.0, top: 10),
                child: Button("Apply Promo Code",
                    width: double.infinity,
                    loading: viewModel.isBusy,
                    disabled: viewModel.promoCodeController.text.isEmpty,
                    valueKey: const Key("btnPromoCodeAdd"),
                    onPressed: () async {
                  setState(() {});
                  if (viewModel.promoCodeController.text.isNotEmpty) {
                    await viewModel.applyCoupon(context);
                  }
                  setState(() {});
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}
