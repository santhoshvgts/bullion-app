import 'package:bullion/core/res/images.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/shared/cart/cart_summary_help_text.dart';
import 'package:bullion/ui/shared/cart/inline_block_section.dart';
import 'package:bullion/ui/shared/cart/warning_card.dart';
import 'package:bullion/ui/shared/contentful/banner/banner_ui_container.dart';
import 'package:bullion/ui/shared/contentful/product/product_module.dart';
import 'package:bullion/ui/shared/contentful/standard/standard_module.dart';
import 'package:bullion/ui/view/checkout/review_order/review_order_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bullion/core/constants/module_type.dart';
import 'package:bullion/core/models/module/cart/cart_item.dart';
import 'package:bullion/core/models/module/cart/order_total_summary.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/shared/loading_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/network_image_loader.dart';
import 'package:stacked/stacked.dart';

class ReviewOrderPage extends VGTSBuilderWidget<ReviewOrderViewModel> {

  bool? fromPriceExpiry = false;

  ReviewOrderPage({this.fromPriceExpiry});

  @override
  ReviewOrderViewModel viewModelBuilder(BuildContext context) => ReviewOrderViewModel(fromPriceExpiry);

  @override
  void onViewModelReady(ReviewOrderViewModel viewModel) {
    viewModel.init();
  }

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, ReviewOrderViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar (
        automaticallyImplyLeading: fromPriceExpiry! ? false : true,
        title: Text(fromPriceExpiry! ? "Price Expired" : "Review Order", textScaleFactor: 1, style: AppTextStyle.titleMedium.copyWith(color: AppColor.text, fontFamily: AppTextStyle.fontFamily),),
        actions: [

          if (fromPriceExpiry!)
            IconButton(icon: const Icon(Icons.close), onPressed: (){
              locator<NavigationService>().popUntil(Routes.dashboard);
            })

        ],
      ),
      body: viewModel.cart == null ? LoadingWidget(allowPop: true,) : Container(
        color: AppColor.secondaryBackground,
        child: ListView(
          children: [

            if (fromPriceExpiry!)
              Container(
                color: AppColor.white,
                padding: const EdgeInsets.all(15),
                child: Text(viewModel.shoppingCart!.expiredCartMessage!,
                  style: AppTextStyle.bodyMedium,
                ),
              ),


            viewModel.isBusy ?
              const SizedBox(
                  height: 2,
                  child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColor.primary),)
              ) : Container(),

            if(viewModel.shoppingCart!.errors != null)
              _ErrorNotes(),

            if (viewModel.inlineMessage != null)
              InlineBlockSection(viewModel.inlineMessage!),

            VerticalSpacing.d10px(),

            _ItemListSection(),

            // VerticalSpacing.d10px(),

            if (viewModel.shoppingCart!.warnings != null)
              ...viewModel.shoppingCart!.warnings!.map((warning) {
                return Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(top: 10),
                  color: AppColor.white,
                  child: Text(warning, textScaleFactor: 1, style: AppTextStyle.bodyMedium.copyWith(color: AppColor.red),),
                );
              }).toList(),

            if (viewModel.shoppingCart!.showPotentialSavings! && viewModel.totalItems! > 0) _PotentialSavings(),

            if (viewModel.totalItems! > 0)
              _OrderSummary(),

            if (viewModel.modules != null)
              ...viewModel.modules!.map((module){
                switch(module!.moduleType){

                  case ModuleType.standard:
                    return StandardModule(module);

                  case ModuleType.product:
                  case ModuleType.productList:
                    return ProductModule(module,);

                  case ModuleType.banner:
                    return BannerModule(module);

                  default:
                    return Container();
                }

              }).toList(),

          ],
        ),
      ),
      bottomNavigationBar: fromPriceExpiry! && !viewModel.isBusy ? SafeArea(
        child: Container(
          color: AppColor.white,
          padding: const EdgeInsets.all(15),
          child: Button(
            "Accept Updated Pricing",
            color: AppColor.secondary,
            borderColor: AppColor.secondary,
            valueKey: const Key("btnAccept"),
            onPressed: (){
              locator<NavigationService>().pushReplacementNamed(Routes.checkout);
            },
          ),
        ),
      ) : null,
    );
  }

}

class _ItemListSection extends ViewModelWidget<ReviewOrderViewModel> {

  @override
  Widget build(BuildContext context, ReviewOrderViewModel viewModel) {

    if (viewModel.shoppingCart!.hasTaxableItems!) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Padding(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: Text("Non-Taxable Products", textScaleFactor: 1, style: AppTextStyle.titleMedium,),
          ),

          ListView.separated(
            itemCount: viewModel.nonTaxCartItems.length,
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            separatorBuilder: (context, index) {
              return VerticalSpacing.d10px();
            },
            itemBuilder: (context, index) {
              return _ItemCard(viewModel.nonTaxCartItems[index],);
            },
          ),


          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
            child: Row(
              children: [

                const Expanded(child: Text("Non-Taxable Subtotal", textScaleFactor: 1, style: AppTextStyle.titleSmall,)),

                Text(viewModel.shoppingCart!.formattedNonTaxableSubTotal!, textScaleFactor: 1, style: AppTextStyle.titleSmall,),

              ],
            ),
          ),

          AppStyle.customDivider,

          const Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            child: Text("Taxable Products", textScaleFactor: 1, style: AppTextStyle.titleMedium,),
          ),

          ListView.separated(
            itemCount: viewModel.taxCartItems.length,
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            separatorBuilder: (context, index) {
              return VerticalSpacing.d10px();
            },
            itemBuilder: (context, index) {
              return _ItemCard(viewModel.taxCartItems[index],);
            },
          ),

          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
            child: Row(
              children: [

                const Expanded(child: Text("Taxable Subtotal", textScaleFactor: 1, style: AppTextStyle.titleSmall,)),

                Text(viewModel.shoppingCart!.formattedTaxableSubTotal!, textScaleFactor: 1, style: AppTextStyle.titleSmall,),

              ],
            ),
          ),

          AppStyle.dottedDivider,

          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 15),
            child: Row(
              children: [

                const Expanded(child: Text("Tax", textScaleFactor: 1, style: AppTextStyle.titleSmall,)),

                Text(viewModel.shoppingCart!.formattedTaxableItemsTax!, textScaleFactor: 1, style: AppTextStyle.titleSmall,),

              ],
            ),
          ),

        ],
      );
    }

    return ListView.separated(
      itemCount: viewModel.cartItems!.length,
      shrinkWrap: true,
      primary: false,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      separatorBuilder: (context, index) {
        return const SizedBox(height: 1, child: AppStyle.customDivider);
      },
      itemBuilder: (context, index) {
        return _ItemCard(viewModel.cartItems![index],);
      },
    );
  }

}


class _ItemCard extends StatelessWidget {

  CartItem item;

  _ItemCard(this.item);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        top: 12,
        right: 10,
        bottom: 10,
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
                  locator<NavigationService>().pushNamed(item.targetUrl);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColor.divider, width: 0.5),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: NetworkImageLoader(
                    image: item.primaryImageUrl,
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
                      item.productName!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textScaleFactor: 1,
                      style: AppTextStyle.bodyMedium,
                    ),
                    VerticalSpacing.d5px(),

                    Row(
                      children: [

                        Text("${item.formattedUnitPrice!} x ${item.quantity}",
                          style: AppTextStyle.titleSmall,
                          textScaleFactor: 1,
                        ),


                        Expanded(
                          child:  Text(item.formattedSubTotal!,
                            style: AppTextStyle.titleSmall,
                            textScaleFactor: 1,
                            textAlign: TextAlign.end,
                          ),
                        )

                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (item.offers != null)
            ...item.offers!.map((offer) {
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
          if (item.warnings != null)
            ...item.warnings!.map((warning) {
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
    );
  }

}


class _PotentialSavings extends ViewModelWidget<ReviewOrderViewModel> {
  @override
  Widget build(BuildContext context, ReviewOrderViewModel viewModel) {
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


class _OrderSummary extends ViewModelWidget<ReviewOrderViewModel> {
  @override
  Widget build(BuildContext context, ReviewOrderViewModel viewModel) {
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

class _ErrorNotes extends ViewModelWidget<ReviewOrderViewModel> {

  @override
  Widget build(BuildContext context, ReviewOrderViewModel viewModel) {

    return Column(
      children: viewModel.shoppingCart!.errors!.map((e) {
        if (e == null) {
          return Container();
        }

        return WarningCard(e);
      }).toList(),
    );
  }

}
