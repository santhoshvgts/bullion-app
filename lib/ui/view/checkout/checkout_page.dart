import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/shared/cart/cart_summary_help_text.dart';
import 'package:bullion/ui/shared/cart/warning_card.dart';
import 'package:bullion/ui/shared/web_view/apmex_web_view.dart';
import 'package:bullion/ui/view/checkout/checkout_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:bullion/core/enums/viewstate.dart';
import 'package:bullion/core/models/module/cart/order_total_summary.dart';
import 'package:bullion/core/models/module/checkout/selected_bullion_card_reward.dart';
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
             title: const Text(
               "Confirm your Order",
               textScaleFactor: 1,
             ),
             actions: [

               IconButton(icon: const Icon(Icons.close), onPressed: (){
                 if (viewModel.placeOrderLoading) {
                   return;
                 }
                 locator<NavigationService>().pop();
               },)

             ],
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
                     ) : Container(),

                     Flexible(
                       child: Container(
                         height: double.infinity,
                         child: SingleChildScrollView(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [

                               _PriceTimingSection(),

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

                       InkWell(
                         onTap: () {
                           ApmexWebView.open(locator<AppConfigService>().config!.appLinks!.checkoutTermCancelPolicy, title: "Cancellation Policy");
                         },
                         child: RichText(
                           textScaleFactor: 1,
                           text: TextSpan(
                             text: 'By placing an order, I agree to ',
                             style: AppTextStyle.bodySmall,
                             children: <TextSpan>[
                               TextSpan(text: 'terms and cancellation policy', style: AppTextStyle.bodySmall.copyWith(color: Colors.blue, decoration: TextDecoration.underline)),
                             ],
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
         borderRadius: BorderRadius.circular(5),
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
         borderRadius: BorderRadius.circular(5),
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
            child: Column(
              children: [

                const Text(
                  "Your pricing will be locked for:",
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bodySmall,
                ),

                Text(
                  viewModel.formattedRemainingPricingTime,
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.titleMedium.copyWith( color: AppColor.primary),
                ),

              ],
            ),
          ),

          Container(
            height: 40,
            width: 0.5,
            color: AppColor.black20,
          ),

          Expanded(
            child: InkWell(
              key: const Key("btnReviewOrder"),
              onTap: (){
                locator<NavigationService>().pushNamed(Routes.reviewCart);
              },
              child: Column(
                children: [

                  Text(
                    "Order Total (${viewModel.checkout!.totalItems} Items)",
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.bodySmall.copyWith(fontSize: 12, decoration: TextDecoration.underline),
                  ),

                  Text(
                    viewModel.checkout!.formattedOrderTotal!,
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.titleMedium.copyWith(fontSize: 22, color: AppColor.primary),
                  ),

                ],
              ),
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

    if ((viewModel.checkout!.selectedShippingAddress != null &&
        viewModel.checkout!.selectedShippingAddress?.address?.id != 0 &&
        viewModel.checkout!.selectedShippingAddress?.address?.id != null) ||  viewModel.checkout!.selectedShippingAddress?.isCitadel == true) {
      UserAddress? userAddress = viewModel.checkout!.selectedShippingAddress!.address;

      return InkWell(
        key: const Key("cardAddressAction"),
        onTap: () => viewModel.onDeliveryAddressSelection(),
        child: Container(
          color: AppColor.white,
          margin: const EdgeInsets.only(top: 10, ),
          padding: const EdgeInsets.only(top: 10,bottom: 10,left: 15,right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              const Icon(Icons.location_on_outlined, size: 25, color: AppColor.primary,),

              HorizontalSpacing.d15px(),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ship To Address", textScaleFactor: 1,style: AppTextStyle.bodySmall.copyWith(fontSize: 12),),

                    VerticalSpacing.d2px(),

                    Text(viewModel.checkout!.selectedShippingAddress!.isCitadel! ? "Secure Storage" : userAddress!.name, textScaleFactor: 1,style: AppTextStyle.titleMedium.copyWith(fontSize: 16),),

                    VerticalSpacing.d2px(),

                    if (!viewModel.checkout!.selectedShippingAddress!.isCitadel!)
                      Text(userAddress!.add1 ?? "",textScaleFactor: 1,style: AppTextStyle.bodySmall,),

                    if (viewModel.checkout!.selectedShippingAddress!.isCitadel!)
                      Text(viewModel.checkout!.selectedShippingAddress!.citadelAccountNumber ?? 'Citadel Global Depository Services',textScaleFactor: 1,style: AppTextStyle.bodySmall,)
                    else
                      Text(userAddress!.formattedSubAddress,textScaleFactor: 1, style: AppTextStyle.bodySmall,),
                  ],
                ),
              ),

              Container(
                  alignment: Alignment.bottomRight,
                  child: Text("Edit", textScaleFactor: 1, style: AppTextStyle.bodySmall.copyWith(color: AppColor.primary),)
              ),

            ],
          ),
        ),
      );
    }

    return InkWell(
      key: const Key("cardAddressAction"),
      onTap: () => viewModel.onDeliveryAddressSelection(),
      child: Container(
        color: AppColor.white,
        margin: const EdgeInsets.only(top: 10,bottom: 5),
        padding: const EdgeInsets.only(top: 10,bottom: 10,left: 15,right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            const Icon(Icons.location_on_outlined, size: 25,),

            HorizontalSpacing.d15px(),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Ship To Address",textScaleFactor: 1,style: AppTextStyle.titleMedium.copyWith(fontSize: 16),),

                  VerticalSpacing.d2px(),

                  Text("Select your shipping address for delivery",textScaleFactor: 1,style: AppTextStyle.bodySmall,),
                ],
              ),
            ),

            Container(
                alignment: Alignment.bottomRight,
                child: Text("Add", textScaleFactor: 1, style: AppTextStyle.bodySmall.copyWith(color: AppColor.primary),)
            ),

          ],
        ),
      ),
    );

  }

}

class _PaymentSection extends ViewModelWidget<CheckoutViewModel> {

  @override
  Widget build(BuildContext context, CheckoutViewModel viewModel) {

    if (viewModel.checkout!.selectedPaymentMethod != null) {

      SelectedPaymentMethod paymentMethod = viewModel.checkout!.selectedPaymentMethod!;

      return InkWell(
        key: const Key("actionPayment"),
        onTap: () => viewModel.onPaymentClick(),
        child: Container(
          color: AppColor.white,
          margin: const EdgeInsets.only(top: 10, ),
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
                  child: Text("Edit", textScaleFactor: 1, style: AppTextStyle.bodySmall.copyWith(color: AppColor.primary),)
              ),

            ],
          ),
        ),
      );
    }

    return InkWell(
      key: const Key("actionPayment"),
      onTap: viewModel.checkout!.selectedShippingAddress == null ? null : () => viewModel.onPaymentClick(),
      child: Opacity(
        opacity: viewModel.checkout!.selectedShippingAddress == null ? 0.7 : 1,
        child: Container(
          color: AppColor.white,
          margin: const EdgeInsets.only(top: 10,),
          padding: const EdgeInsets.only(top: 10, bottom: 10,left: 15,right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Icon(Icons.credit_card_rounded, color: viewModel.checkout!.selectedShippingAddress == null ? AppColor.disabled : null, size: 25,),

              HorizontalSpacing.d15px(),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Payment", textScaleFactor: 1, style: AppTextStyle.titleMedium.copyWith(fontSize: 16),),

                    VerticalSpacing.d2px(),

                    Text("Please select your payment method", textScaleFactor: 1, style: AppTextStyle.bodySmall,),
                  ],
                ),
              ),

              if (viewModel.checkout!.selectedShippingAddress != null)
                Container(
                    alignment: Alignment.bottomRight,
                    child: Text("Add", textScaleFactor: 1, style: AppTextStyle.bodySmall.copyWith(color: AppColor.primary),)
                ),

            ],
          ),
        ),
      ),
    );
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
      color: AppColor.white,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10,),
      padding: const EdgeInsets.only(top: 10, bottom: 10,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Text("Shipping Options",textScaleFactor: 1,style: AppTextStyle.titleMedium.copyWith(fontSize: 16),),
          ),

          VerticalSpacing.d15px(),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 15,right: 15),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  ...viewModel.checkout!.selectedShippingOption!.shippingOptions!.map((shippingOption) =>
                      InkWell(
                        onTap: (){
                          viewModel.onShippingOptionSelect(shippingOption);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          margin: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            color: viewModel.checkout!.selectedShippingOption!.selectedShippingOption == shippingOption.id ? AppColor.primary.withOpacity(0.07) : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(width: viewModel.checkout!.selectedShippingOption!.selectedShippingOption == shippingOption.id ? 1.5 : 1,
                                color: viewModel.checkout!.selectedShippingOption!.selectedShippingOption == shippingOption.id ? AppColor.primary : Colors.black12
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: Padding(
                                    padding: const EdgeInsets.only(top: 10, left: 10),
                                    child: Text(shippingOption.formattedShipCharge!, textScaleFactor: 1, style: AppTextStyle.titleMedium.copyWith(color: AppColor.primary),),
                                  )),

                                  if (shippingOption.serviceDescription != null)
                                    Container(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: IconButton(
                                          onPressed: () => locator<DialogService>().showBottomSheet(title: shippingOption.name, child: CartSummaryHelpText(shippingOption.serviceDescription)),
                                          icon: const Icon(
                                            Icons.error_outline,
                                            size: 18,
                                            color: AppColor.text,
                                          )
                                      ),
                                    ),

                                ],
                              ),

                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: shippingOption.serviceDescription != null ? 0 : 10),
                                child: Text(shippingOption.name!, textAlign: TextAlign.start, textScaleFactor: 1, style: AppTextStyle.bodySmall,),
                              ),

                            ],
                          ),
                        ),
                      )
                  ).toList()
                ],
              ),
            ),
          )


        ],
      ),
    );
  }

}

class _OrderSummary extends ViewModelWidget<CheckoutViewModel> {

  @override
  Widget build(BuildContext context, CheckoutViewModel viewModel) {

    if (viewModel.orderSummaryList == null){
      return Container();
    }

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
                style: AppTextStyle.titleMedium.copyWith(fontSize: 17),
              ),
            ),

            ListView.separated(
                itemCount: viewModel.orderSummaryList!.length,
                primary: false,
                shrinkWrap: true,
                separatorBuilder: (context, index){
                  return AppStyle.customDivider;
                },
                itemBuilder: (context, index) {

                  OrderTotalSummary item = viewModel.orderSummaryList![index];

                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.key!, textScaleFactor: 1, style: AppTextStyle.bodySmall.copyWith(fontSize: 15)),

                            if (item.canRemove == true)
                              Container(
                                height: 26,
                                width: 60,
                                child: InkWell(
                                  onTap: () {
                                    viewModel.onRemoveFromOrderSummary(item.keyCode);
                                  },
                                  child: Row(
                                    children: [
                                      Text("Remove", textAlign: TextAlign.left, textScaleFactor: 1, style: AppTextStyle.titleMedium.copyWith(fontSize: 12)),
                                    ],
                                  )),
                              ),
                          ],
                        ),

                        HorizontalSpacing.d5px(),

                        if (item.keyHelpText!.isNotEmpty)
                          InkWell(
                              onTap: () => locator<DialogService>().showBottomSheet(title: item.key, child: CartSummaryHelpText(item.keyHelpText)),
                              child: const Icon(
                                Icons.error_outline,
                                size: 18,
                                color: AppColor.text,
                              )
                          ),

                        Expanded(child: Container()),

                        HorizontalSpacing.d15px(),

                        Text(item.value!, style: AppTextStyle.bodySmall.copyWith(color: item.textColor, fontSize: 15))

                      ],
                    ),
                  );

                }
            ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              color: AppColor.white,
              child: Row(
                children: [
                  Text("Total", textScaleFactor: 1, style: AppTextStyle.titleMedium.copyWith(fontSize: 17)),

                  Expanded(child: Container()),

                  Text(viewModel.checkout!.formattedOrderTotal!, style: AppTextStyle.titleMedium.copyWith(fontSize: 17))

                ],
              ),
            ),

          ],
        ),
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
