import 'package:bullion/core/models/module/checkout/shipping_option.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/shared/cart/cart_summary_help_text.dart';
import 'package:bullion/ui/shared/cart/warning_card.dart';
import 'package:bullion/ui/shared/web_view/apmex_web_view.dart';
import 'package:bullion/ui/view/checkout/address/checkout_address_section.dart';
import 'package:bullion/ui/view/checkout/checkout_view_model.dart';
import 'package:bullion/ui/view/checkout/payment_method/payment_method_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bullion/core/models/module/cart/order_total_summary.dart';
import 'package:bullion/core/models/module/checkout/selected_payment_method.dart';
import 'package:bullion/core/models/user_address.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/helper/utils.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/appconfig_service.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/services/shared/preference_service.dart';
import 'package:bullion/ui/widgets/apmex_html_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/page_will_pop.dart';
import 'package:bullion/ui/widgets/shimmer_effect.dart';
import 'package:stacked/stacked.dart';

class CheckoutPage extends StatelessWidget with WidgetsBindingObserver {

  late CheckoutViewModel _checkoutViewModel;
  late BuildContext _buildContext;

  @override
  Widget build(BuildContext context) {
    _buildContext = context;

   return ViewModelBuilder<CheckoutViewModel>.reactive(
     onViewModelReady: (CheckoutViewModel viewModel){
       _checkoutViewModel = viewModel;
       WidgetsBinding.instance.addObserver(this);
       viewModel.init();
     },
     onDispose: (CheckoutViewModel viewModel){
       WidgetsBinding.instance.removeObserver(this);
     },
     builder: (context, CheckoutViewModel viewModel, child) {
       return PageWillPop(
         allowPop: !viewModel.placeOrderLoading,
         child: Scaffold(
           appBar: AppBar(
             automaticallyImplyLeading: false,
             toolbarHeight: 65,
             title: Column(
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text(
                   "Checkout",
                   textScaleFactor: 1,
                   style: AppTextStyle.titleMedium.copyWith(
                       color: AppColor.text, fontFamily: AppTextStyle.fontFamily),
                 ),

                 InkWell(
                   onTap: () {
                     locator<NavigationService>().pushNamed(Routes.reviewCart);
                   },
                   child: Text(
                     "Review Order ${viewModel.checkout?.formattedOrderTotal ?? '-'}",
                     textScaleFactor: 1,
                     style: AppTextStyle.labelMedium.copyWith(
                         color: AppColor.text, fontFamily: AppTextStyle.fontFamily, decoration: TextDecoration.underline),
                   ),
                 ),

               ],
             ),
             leading: IconButton(icon: const Icon(Icons.close), onPressed: (){
               if (viewModel.placeOrderLoading) {
                 return;
               }
               locator<NavigationService>().pop();
             },),
             actions: [
               Container(
                 decoration: BoxDecoration(
                   color: AppColor.primary,
                   borderRadius: BorderRadius.circular(15),
                 ),
                 margin: const EdgeInsets.only(left: 10, right: 15),
                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                 child: Text(
                   viewModel.formattedRemainingPricingTime,
                   textScaleFactor: 1,
                   textAlign: TextAlign.center,
                   style: AppTextStyle.titleSmall.copyWith( color: AppColor.white),
                 ),
               ),
             ]
           ),

           body: Stack(
             children: [

               Container(
                 color: AppColor.secondaryBackground,
                 height: MediaQuery.of(context).size.height,
                 child: viewModel.checkout == null ? LoadingShimmer() : Column(
                   children: [

                     viewModel.isBusy ?
                     const SizedBox(
                         height: 2,
                         child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColor.primary),)
                     ) : const SizedBox(),

                     Flexible(
                       child: SizedBox(
                         height: double.infinity,
                         child: SingleChildScrollView(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [

                               // _PriceTimingSection(),

                               _DeliveryAddress(),

                               _PaymentSection(),

                               _ShippingOptionSection(),

                               if (viewModel.checkout?.warnings != null)
                                 ...viewModel.checkout?.warnings?.map((warning) {
                                   return WarningCard(warning, color: Colors.blue, textColor: AppColor.black,);
                                 }).toList() ?? [],

                               _OrderSummary(),

                               if (!viewModel.isBusy)
                                 _Notes()

                             ],
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),

               if (viewModel.placeOrderLoading)
                 Container(
                   height: MediaQuery.of(context).size.height,
                   width: MediaQuery.of(context).size.width,
                   color: AppColor.white.withOpacity(0.1),
                   child: Container(),
                 )

             ],
           ),
           bottomNavigationBar: viewModel.checkout == null ? null : SafeArea(
             child: Container(
               padding: const EdgeInsets.all(15),
               decoration: BoxDecoration(
                   boxShadow: AppStyle.topShadow,
                   color: AppColor.white
               ),
               child: Wrap(
                 children: [

                   Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [

                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 5),
                         child: InkWell(
                           onTap: () {
                             ApmexWebView.open(locator<AppConfigService>().config!.appLinks!.checkoutTermCancelPolicy, title: "Cancellation Policy");
                           },
                           child: RichText(
                             textScaleFactor: 1,
                             textAlign: TextAlign.center,
                             text: TextSpan(
                               text: 'By placing an order, I agree to ',
                               style: AppTextStyle.bodySmall.copyWith(color: AppColor.text, fontFamily: AppTextStyle.fontFamily),
                               children: <TextSpan>[
                                 TextSpan(text: 'terms and cancellation policy', style: AppTextStyle.bodySmall.copyWith(color: Colors.blue, decoration: TextDecoration.underline)),
                               ],
                             ),
                           ),
                         ),
                       ),

                       VerticalSpacing.d15px(),

                       _PlaceOrderButton()

                     ],
                   )

                 ],
               ),
             ),
           ),
         ),
       );
     },
     viewModelBuilder: () => CheckoutViewModel()
   );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.paused) {
      print('Checkout state: Paused audio playback');
    }
    if(state == AppLifecycleState.resumed) {
      if (ModalRoute.of(_buildContext) != null) {
        print(ModalRoute.of(_buildContext)!.settings.name);
        print("Current ${ModalRoute.of(_buildContext)!.isCurrent}");
        if (ModalRoute.of(_buildContext)!.isCurrent) {
          _checkoutViewModel.refreshPage();
        }
      }
      print('Checkout state: Resumed audio playback');
    }
  }


}

class LoadingShimmer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        ShimmerEffect(
          height: 85,
          width: double.infinity,
        ),

         Container(
            height: 90,
            margin: const EdgeInsets.only(top: 10,),
            width: double.infinity,
            child: ShimmerEffect(),
          ),

        Container(
          height: 90,
          margin: const EdgeInsets.only(top: 10,),
          width: double.infinity,
          child: ShimmerEffect(),
        ),

        Container(
          height: 190,
          margin: const EdgeInsets.only(top: 10,),
          width: double.infinity,
          child: ShimmerEffect(),
        )

      ],
    );
  }

}

class _PlaceOrderButton extends ViewModelWidget<CheckoutViewModel> {

  @override
  Widget build(BuildContext context, CheckoutViewModel viewModel) {

   if (viewModel.paymentMethod != null){
     if (viewModel.paymentMethod!.paymentMethodId == 18){
       return Button.image(
         Images.payPal,
         viewModel.paymentMethod!.icon,
         valueKey: const Key("btnPlaceOrder"),
         width: double.infinity,
         disabled: !viewModel.enablePlaceOrder,
         loading: viewModel.placeOrderLoading,
         color: const Color(0xFF023087),
         borderColor: const Color(0xFF023087),
         onPressed: viewModel.isBusy ? null : (){
           viewModel.onPayPalClick();
         },
       );

     }

     if (viewModel.paymentMethod!.paymentMethodId == 28) {
       return Button.image(
         Images.bitpay,
         viewModel.paymentMethod!.icon,
         valueKey: const Key("btnPlaceOrder"),
         width: double.infinity,
         disabled: !viewModel.enablePlaceOrder,
         loading: viewModel.placeOrderLoading,
         color: const Color(0xFF022147),
         borderColor: const Color(0xFF022147),
         onPressed: viewModel.isBusy ? null : (){
           viewModel.onBitPayClick();
         },
       );
     }
   }

    return Button(
      "Place Order",
      valueKey: const Key("btnPlaceOrder"),
      width: double.infinity,
      color: AppColor.secondary,
      borderColor: AppColor.secondary,
      loading: viewModel.placeOrderLoading,
      onPressed: viewModel.isBusy ? null : (){
        viewModel.submitPlaceOrder();
      },
    );

  }

}

class _PriceTimingSection extends ViewModelWidget<CheckoutViewModel> {

  @override
  Widget build(BuildContext context, CheckoutViewModel viewModel) {

    return Container(
      padding: const EdgeInsets.all(15),
      color: AppColor.white,
      alignment: Alignment.center,
      child: Row(
        children: [

          Expanded(
            child: InkWell(
              key: const Key("btnReviewOrder"),
              onTap: (){
                locator<NavigationService>().pushNamed(Routes.reviewCart);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    viewModel.checkout!.formattedOrderTotal!,
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.titleMedium.copyWith(color: AppColor.primary),
                  ),

                  Text(
                    "Order Total (${viewModel.checkout!.totalItems} Items)",
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.bodySmall.copyWith(fontSize: 12,color: AppColor.primary, decoration: TextDecoration.underline),
                  ),

                ],
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Text(
              viewModel.formattedRemainingPricingTime,
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: AppTextStyle.titleSmall.copyWith( color: AppColor.white),
            ),
          ),

        ],
      ),
    );
  }

}

class _DeliveryAddress extends ViewModelWidget<CheckoutViewModel>  {

  @override
  Widget build(BuildContext context, CheckoutViewModel viewModel) {
print("viewModel.showAddressSelection ${viewModel.showAddressSelection}");
    if ((viewModel.checkout!.selectedShippingAddress != null &&
        viewModel.checkout!.selectedShippingAddress?.address?.id != 0 &&
        viewModel.checkout!.selectedShippingAddress?.address?.id != null) && viewModel.showAddressSelection == false) {
      UserAddress? userAddress = viewModel.checkout!.selectedShippingAddress!.address;

      return InkWell(
        key: const Key("cardAddressAction"),
        onTap: () => viewModel.onDeliveryAddressSelection(),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor.divider, width: 0.5),
          ),
          margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
          padding: const EdgeInsets.only(top: 10,bottom: 10,left: 15,right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              SizedBox(
                width: 27,
                child: Image.asset(Images.shippingAddressIcon, )
              ),

              HorizontalSpacing.d15px(),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Shipping Address", textScaleFactor: 1,style: AppTextStyle.bodySmall.copyWith(fontSize: 12),),

                    VerticalSpacing.d2px(),

                    Text(userAddress!.name, textScaleFactor: 1,style: AppTextStyle.titleMedium.copyWith(fontSize: 16),),

                    VerticalSpacing.d2px(),

                    Text(userAddress!.formattedFullAddress ?? "",textScaleFactor: 1,style: AppTextStyle.bodySmall,),

                  ],
                ),
              ),

              Container(
                  alignment: Alignment.bottomRight,
                  child: Text("Change", textScaleFactor: 1, style: AppTextStyle.bodySmall.copyWith(color: AppColor.primary),)
              ),

            ],
          ),
        ),
      );
    }

    return CheckoutAddressSection(
      viewModel.checkout
    );
  }

}

class _PaymentSection extends ViewModelWidget<CheckoutViewModel> {

  @override
  Widget build(BuildContext context, CheckoutViewModel viewModel) {

    if (viewModel.checkout!.selectedPaymentMethod != null && viewModel.showPaymentSelection == false) {
      SelectedPaymentMethod paymentMethod = viewModel.checkout!.selectedPaymentMethod!;
      return InkWell(
        key: const Key("actionPayment"),
        onTap: () => viewModel.onPaymentClick(),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor.divider, width: 0.5),
          ),
          margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
          padding: const EdgeInsets.only(top: 10,bottom: 10,left: 15,right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              if (paymentMethod.isBullionCard == true)
                Image.asset(Images.bullionCardPortrait, width: 35, fit: BoxFit.fill,)
              else
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(FAIcon(paymentMethod.icon), size: 25, color: AppColor.primary,),
                ),

              HorizontalSpacing.d5px(),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Payment Method", textScaleFactor: 1,style: AppTextStyle.bodySmall.copyWith(fontSize: 12),),

                    VerticalSpacing.d2px(),

                    Text(paymentMethod.displayName!, textScaleFactor: 1,style: AppTextStyle.titleMedium.copyWith(fontSize: 16),),

                    if (paymentMethod.displaySubText != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(paymentMethod.displaySubText!,textScaleFactor: 1,style: AppTextStyle.bodySmall,),
                      ),

                    if (paymentMethod.selectedInfoText != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: ApmexHtmlWidget(
                          paymentMethod.selectedInfoText!,
                          textStyle: AppTextStyle.bodySmall,
                        ),
                      ),
                  ],
                ),
              ),

              Container(
                  alignment: Alignment.bottomRight,
                  child: Text("Change", textScaleFactor: 1, style: AppTextStyle.bodySmall.copyWith(color: AppColor.primary),)
              ),

            ],
          ),
        ),
      );
    }

    if (viewModel.checkout?.selectedShippingAddress != null || viewModel.checkout?.selectedPaymentMethod != null) {
      return const PaymentMethodSection();
    }

    return const SizedBox();
  }

}

class _ShippingOptionSection extends ViewModelWidget<CheckoutViewModel> {

  @override
  Widget build(BuildContext context, CheckoutViewModel viewModel) {

    if (viewModel.checkout == null){
      return Container();
    }

    if (viewModel.checkout!.selectedShippingOption == null){
      return Container();
    }

    if (!viewModel.checkout!.selectedShippingOption!.showShippingOption!){
      return Container();
    }

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.divider, width: 0.5),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text('Shipping Method', style: AppTextStyle.titleMedium)
            ),
             Padding(
                padding: const EdgeInsets.only(left: 15, top: 2),
                child: Text('All shipping methods are fully insured', style: AppTextStyle.labelMedium.copyWith(fontWeight: FontWeight.w400,color: AppColor.secondaryText))
            ),

            VerticalSpacing.d20px(),

            ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {

                  ShippingOption? option = viewModel.checkout?.selectedShippingOption?.shippingOptions?[index];
                  bool selected = viewModel.checkout?.selectedShippingOption?.selectedShippingOption == option?.id;
                  return InkWell(
                    onTap: () {
                      viewModel.onShippingOptionSelect(option!);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                          value: selected,
                          activeColor: AppColor.primary,
                          onChanged: (value) {
                          },
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, groupValue: true,
                        ),
                        Expanded(child: Text(option?.name ?? '', style: AppTextStyle.bodyMedium.copyWith(color: selected ? AppColor.primary : null, fontWeight: selected ? FontWeight.w500 : null))),
                        Text('\$${option?.shipCharge.toString() ?? ''}', style: AppTextStyle.bodyMedium.copyWith(color: selected ? AppColor.primary : null, fontWeight: selected ? FontWeight.w500 : null)),
                        HorizontalSpacing.d15px(),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  color: AppColor.divider,
                  thickness: 0.3,
                  height: 15,
                ),
                itemCount: viewModel.checkout?.selectedShippingOption?.shippingOptions?.length ?? 0
            ),
          ],
        )
    );

  }

}

class _OrderSummary extends ViewModelWidget<CheckoutViewModel> {
  @override
  Widget build(BuildContext context, CheckoutViewModel viewModel) {
    if (viewModel.orderSummaryList == null){
      return Container();
    }

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
                itemCount: viewModel.orderSummaryList?.length ?? 0,
                primary: false,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 2),
                separatorBuilder: (context, index) {
                  return AppStyle.dottedDivider;
                },
                itemBuilder: (context, index) {
                  OrderTotalSummary item = viewModel.orderSummaryList![index];

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
                    Text(viewModel.checkout?.formattedOrderTotal ?? '',
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


class _Notes extends ViewModelWidget<CheckoutViewModel> {
  @override
  Widget build(BuildContext context, CheckoutViewModel viewModel) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.only(top: 5,bottom: 5),
        width: double.infinity,
        child: Text("Checkout confirmation and updates will be emailed to ${locator<AuthenticationService>().getUser?.email ?? ''} | Cart Id: ${locator<PreferenceService>().getCartId() ?? ''}",
            style: AppTextStyle.labelMedium,
            textAlign: TextAlign.center),
      )
    ]);
  }
//.toList(),
}
