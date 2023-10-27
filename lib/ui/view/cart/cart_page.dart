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
import 'package:bullion/ui/widgets/page_will_pop.dart';
import 'package:bullion/ui/widgets/tap_outside_unfocus.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CartPage extends StatelessWidget with WidgetsBindingObserver {
  late CartViewModel _cartViewModel;
  late BuildContext _buildContext;

  DisplayMessage? redirectDisplayMessage;

  CartPage({this.redirectDisplayMessage});

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
              appBar: AppBar(
                title: viewModel.cartItems!.isEmpty
                    ? const Text(
                        "Your Cart is Empty",
                        style: AppTextStyle.titleSmall,
                        textScaleFactor: 1,
                      )
                    : Column(
                        children: [
                          Text(
                            viewModel.shoppingCart!.formattedOrderTotal
                                .toString(),
                            textScaleFactor: 1,
                            style: AppTextStyle.titleLarge,
                          ),
                          Text(
                            "${viewModel.totalItems.toString()} ${viewModel.totalItems! > 1 ? "Items" : "Item"}",
                            textScaleFactor: 1,
                            style:
                                AppTextStyle.bodyLarge.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                centerTitle: true,
              ),
              body: viewModel.cart == null
                  ? Container()
                  : TapOutsideUnFocus(
                      child: Container(
                        color: AppColor.secondaryBackground,
                        child: Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height,
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  return await viewModel.refresh();
                                },
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      viewModel.isBusy
                                          ? const SizedBox(
                                              height: 2,
                                              child: LinearProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        AppColor.primary),
                                              ))
                                          : Container(),
                                      if (redirectDisplayMessage != null)
                                        if (redirectDisplayMessage!
                                                .messageDisplayType ==
                                            MessageDisplayType.Inline)
                                          InlineBlockSection(
                                              redirectDisplayMessage),
                                      if (viewModel.shoppingCart!.errors !=
                                          null)
                                        _ErrorNotes(),
                                      if (viewModel.inlineMessage != null)
                                        InlineBlockSection(
                                            viewModel.inlineMessage),
                                      if (viewModel.totalItems == 0)
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
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
                                                color: const Color(0xff83919B),
                                                width: 100,
                                              ),

                                              VerticalSpacing.d30px(),

                                              Text(
                                                "Your cart is currently empty.",
                                                textScaleFactor: 1,
                                                textAlign: TextAlign.center,
                                                style: AppTextStyle.titleLarge,
                                              ),

                                              // VerticalSpacing.d15px(),
                                              //
                                              // Text("Never forget your favorite products. Add them to your Favorite today.", textAlign: TextAlign.center, textScaleFactor: 1, style: AppTextStyle.body,),
                                              //
                                              VerticalSpacing.d30px(),

                                              Button("Continue Shopping",
                                                  width: 200,
                                                  valueKey:
                                                      const Key("btnShopNow"),
                                                  onPressed: () {
                                                locator<NavigationService>()
                                                    .pop();
                                              })
                                            ],
                                          ),
                                        )
                                      else
                                        Container(
                                          color: AppColor.white,
                                          child: ListView.separated(
                                            itemCount:
                                                viewModel.cartItems!.length,
                                            shrinkWrap: true,
                                            primary: false,
                                            separatorBuilder: (context, index) {
                                              return Container(
                                                  height: 1,
                                                  child:
                                                      AppStyle.customDivider);
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
                                                onValueChange:
                                                    (CartItem item, int qty) {
                                                  viewModel.cartItems![index]
                                                      .quantity = qty;
                                                  viewModel.modifyItemQty(
                                                      item, qty);
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      if (viewModel.totalItems! > 0)
                                        VerticalSpacing.d10px(),
                                      if (viewModel.totalItems! > 0)
                                        _PromoCodeSection(),
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
                          ],
                        ),
                      ),
                    ),
              bottomNavigationBar: viewModel.totalItems! > 0
                  ? SafeArea(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            boxShadow: AppStyle.topShadow,
                            color: AppColor.white),
                        child: Button(
                          "Checkout",
                          valueKey: const Key("CheckoutBtn"),
                          color: AppColor.orange,
                          borderColor: AppColor.orange,
                          width: double.infinity,
                          onPressed: () => viewModel.onCheckoutClick(),
                        ),
                      ),
                    )
                  : null,
            ),
          );
        },
        viewModelBuilder: () => CartViewModel());
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
    return Container(
      color: AppColor.background,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Potential Savings",
              textScaleFactor: 1,
              style: AppTextStyle.titleLarge.copyWith(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Text(
              viewModel.shoppingCart!.potentialSavings!,
              style: AppTextStyle.bodyMedium.copyWith(color: AppColor.primary),
              textScaleFactor: 1,
            ),
          ),
        ],
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
      child: Container(
        color: AppColor.white,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.add, color: AppColor.primary, size: 25),
            HorizontalSpacing.d10px(),
            Text(
              "Add Promo Code",
              style: AppTextStyle.titleLarge.copyWith(fontSize: 16),
              textScaleFactor: 1,
            )
          ],
        ),
      ),
    );
  }
}

class _OrderSummary extends ViewModelWidget<CartViewModel> {
  @override
  Widget build(BuildContext context, CartViewModel viewModel) {
    return Container(
      color: AppColor.background,
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Order Summary",
              textScaleFactor: 1,
              style: AppTextStyle.titleLarge.copyWith(fontSize: 17),
            ),
          ),
          ListView.separated(
              itemCount: viewModel.shoppingCart!.orderTotalSummary!.length,
              primary: false,
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return AppStyle.customDivider;
              },
              itemBuilder: (context, index) {
                OrderTotalSummary item =
                    viewModel.shoppingCart!.orderTotalSummary![index];

                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Row(
                    children: [
                      Text(item.key!,
                          textScaleFactor: 1,
                          style:
                              AppTextStyle.bodyMedium.copyWith(fontSize: 15)),
                      HorizontalSpacing.d5px(),
                      if (item.keyHelpText!.isNotEmpty)
                        InkWell(
                            onTap: () => locator<DialogService>()
                                .showBottomSheet(
                                    title: item.key,
                                    child:
                                        CartSummaryHelpText(item.keyHelpText)),
                            child: const Icon(
                              Icons.error_outline,
                              size: 18,
                              color: AppColor.text,
                            )),
                      Expanded(child: Container()),
                      HorizontalSpacing.d15px(),
                      Text(item.value!,
                          style: AppTextStyle.bodyMedium
                              .copyWith(color: item.textColor, fontSize: 15))
                    ],
                  ),
                );
              }),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            color: AppColor.white,
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
        ],
      ),
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
                        color: AppColor.secondaryBackground,
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: [
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              viewModel.couponInlineMessage!.icon,
                              color: viewModel.couponInlineMessage!.color,
                              size: 35,
                            )),
                        Expanded(
                          child: Column(
                            children: [
                              if (viewModel.couponInlineMessage!.title != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                      viewModel.couponInlineMessage!.title!,
                                      style: AppTextStyle.titleLarge.copyWith(
                                          fontSize: 14,
                                          color: viewModel
                                              .couponInlineMessage!.color),
                                      textAlign: TextAlign.start),
                                ),
                              Text(viewModel.couponInlineMessage!.message!,
                                  style: AppTextStyle.bodyLarge.copyWith(
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
            // EditText(
            //   "Enter Promo Code",
            //   const Key("textPromoCode"),
            //   viewModel.promoCodeController,
            //   TextInputType.text,
            //   focusNode: viewModel.promoCodeFocus,
            //   validate: viewModel.promoCodeValidate,
            //   errorText: viewModel.errorText,
            //   marginEdgeInsets: const EdgeInsets.only(
            //       left: 15.0, right: 15.0, bottom: 10.0, top: 5),
            //   autofocus: true,
            //   textCapitalization: TextCapitalization.characters,
            //   textInputAction: TextInputAction.done,
            //   onSubmitted: (value) {},
            //   onChanged: (value) {
            //     viewModel.promoCodeValidate = false;
            //     setState(() {});
            //   },
            // ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 15.0, top: 10),
                child: Button("Apply Promo Code",
                    width: double.infinity,
                    color: viewModel.promoCodeController.text.isEmpty
                        ? Colors.black12
                        : AppColor.primary,
                    textStyle: viewModel.promoCodeController.text.isEmpty
                        ? AppTextStyle.bodyLarge.copyWith(color: Colors.black26)
                        : AppTextStyle.bodyLarge,
                    borderColor: Colors.transparent,
                    loading: viewModel.isBusy,
                    valueKey: const Key("btnPromoCodeAdd"),
                    onPressed: () async {
                  setState(() {});

                  if (viewModel.promoCodeController.text.isNotEmpty)
                    await viewModel.applyCoupon(context);
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
