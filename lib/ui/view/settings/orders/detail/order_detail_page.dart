import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/models/module/cart/cart_item.dart';
import 'package:bullion/core/models/module/cart/order_total_summary.dart';
import 'package:bullion/core/models/module/order/payment_acknowledgement.dart';
import 'package:bullion/core/models/module/tracking_info_module.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/shared/cart/cart_summary_help_text.dart';
import 'package:bullion/ui/view/settings/orders/detail/order_detail_view_model.dart';
import 'package:bullion/ui/view/settings/settings_user_page.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/animated_flexible_space.dart';
import 'package:bullion/ui/widgets/apmex_html_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/loading_data.dart';
import 'package:bullion/ui/widgets/network_image_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/res/colors.dart';
import '../../../../../core/res/styles.dart';
import '../../../../../helper/utils.dart';

class OrderDetailPage extends VGTSBuilderWidget<OrderDetailViewModel> {

  final Map<String,dynamic> data;
  static const double _expandedHeight = 100;

  const OrderDetailPage(this.data, {super.key});

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, OrderDetailViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColor.secondaryBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                icon: Util.showArrowBackward(),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
              ),
              expandedHeight: _expandedHeight,
              pinned: true,
              flexibleSpace: AnimatedFlexibleSpace.withoutTab(title: '#${viewModel.orderDetail?.orderId ?? ""}'),
            ),
            SliverToBoxAdapter(
              child: viewModel.isBusy
                  ? LoadingData(
                loadingStyle: LoadingStyle.LOGO,
              ) : viewModel.orderDetail == null ? const Center(child: Text("No data available"))
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    if (viewModel.fromSuccess)
                      Container(
                        color: AppColor.white,
                        child: _FromSuccessCard()
                      ),

                    if (viewModel.isGuestUser)
                      _SettingItemGuestUser(),

                    Container(
                      color: AppColor.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          VerticalSpacing.d10px(),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                            child: Row(
                              children: [

                                const Icon(CupertinoIcons.checkmark_alt_circle, color: AppColor.primary,),

                                HorizontalSpacing.d10px(),

                                Expanded(child: _buildItemSection(null, viewModel.orderDetail?.orderStatus ?? '-')),

                              ],
                            ),
                          ),

                          AppStyle.customDivider,

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                            child: Row(
                              children: [

                                const Icon(CupertinoIcons.calendar_today, color: AppColor.primary,),

                                HorizontalSpacing.d10px(),

                                Expanded(child: _buildItemSection("Order Date", viewModel.orderDetail?.formattedPostedDate ?? '-')),

                                if (viewModel.orderDetail?.formattedShippingDate?.isNotEmpty == true)
                                  Expanded(child: _buildItemSection("Shipping Date", viewModel.orderDetail?.formattedShippingDate ?? '-')),

                              ],
                            ),
                          ),

                          AppStyle.customDivider,

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                            child: Row(
                              children: [

                                if (viewModel.orderDetail?.paymentMethod?.icon != null)
                                  Icon(FAIcon(viewModel.orderDetail?.paymentMethod?.icon), color: AppColor.primary, size: 22,)
                                else
                                  const Icon(CupertinoIcons.creditcard, color: AppColor.primary,),

                                HorizontalSpacing.d10px(),

                                Expanded(child: _buildItemSection("Payment Method", viewModel.orderDetail?.paymentMethod?.displayText ?? '-')),

                              ],
                            ),
                          ),

                          AppStyle.customDivider,

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                const Icon(Icons.share_location_outlined, size: 24, color: AppColor.primary,),

                                HorizontalSpacing.d10px(),

                                Expanded(child: _buildItemSection("Address", viewModel.orderDetail?.shippingAddress?.displayText ?? '-')),

                              ],
                            ),
                          ),

                          VerticalSpacing.d15px(),

                        ],
                      ),
                    ),

                    if (viewModel.orderDetail?.showPaymentAcknowledge == true)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Sent your Payment ?",style: AppTextStyle.bodyMedium.copyWith(fontSize:14,),textAlign: TextAlign.start,),


                                InkWell(
                                    onTap: (){
                                      // viewModel.submitPaymentAcknowledge(item);
                                    },
                                    child: Text("Click here",style: AppTextStyle.bodyMedium.copyWith(fontSize:14, color: AppColor.blue),textAlign: TextAlign.start,)
                                ),
                              ],
                            ),

                            VerticalSpacing.d10px(),

                            Container(height:1,child: AppStyle.customDivider),

                          ],
                        ),
                      ),

                    if (viewModel.orderDetail!.shipmentTracking != null)
                      TrackOrderInfoBottomSheet(viewModel.orderDetail!.shipmentTracking),


                    Container(
                      color: AppColor.secondaryBackground,
                      child: _ItemListSection()
                    ),

                    _OrderSummary(),

                    if ((viewModel.orderDetail?.paymentInstructions?.length ?? 0) > 0)
                      _PaymentInstruction()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  OrderDetailViewModel viewModelBuilder(BuildContext context) {
    return OrderDetailViewModel(data);
  }

  Widget _buildItemSection(String? key, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        if (key != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(key,  style: AppTextStyle.labelLarge,),
          ),

        Text(value,  style: AppTextStyle.bodyMedium,),

      ],
    );
  }

  Widget getDetailRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: Text(
                key,
                style:
                AppTextStyle.bodyMedium.copyWith(color: AppColor.primaryText),
              )),
          Expanded(child: Text(value, style: AppTextStyle.bodyMedium)),
        ],
      ),
    );
  }

  Widget showOrderSummary(OrderDetailViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text("Order Summary", style: AppTextStyle.titleMedium),
          ),
          Container(
            height: 112,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: AppColor.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColor.platinumColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: Image.network(viewModel
                        .orderDetail?.orderLineItems?[0].primaryImageUrl ??
                        ""),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          viewModel.orderDetail?.orderLineItems?[0]
                              .productName ??
                              "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: AppTextStyle.labelLarge,
                        ),
                        Text(
                          "Qty: ${viewModel.orderDetail!.orderLineItems![0].quantity}",
                          style: AppTextStyle.bodySmall
                              .copyWith(color: AppColor.primaryText),
                        ),
                        Text(
                          viewModel.orderDetail?.orderLineItems?[0]
                              .formattedUnitPrice ??
                              "",
                          style: AppTextStyle.labelLarge
                              .copyWith(color: AppColor.turtleGreen),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Button("Cancel order",
                      valueKey: const Key("btnCancelOrder"),
                      onPressed: () {},
                      textStyle: AppTextStyle.titleSmall
                          .copyWith(color: AppColor.redOrange),
                      color: Colors.white,
                      borderColor: AppColor.border),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Button("Track Shipment",
                      valueKey: const Key("btnTrackShipment"),
                      onPressed: () {}),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> showOrderSummaryPairs(OrderDetailViewModel viewModel) {
    List<Widget>? widgets = [], widgetsTwo = [];
    viewModel.orderDetail?.orderTotalSummary?.forEach((element) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(element.key!,
                style:
                AppTextStyle.bodyMedium.copyWith(color: AppColor.concord)),
            Text(element.value!, style: AppTextStyle.bodyMedium)
          ],
        ),
      ));
    });

    widgetsTwo.add(Flexible(
      flex: 7,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: widgets,
        ),
      ),
    ));
    widgetsTwo.add(Flexible(
      flex: 3,
      child: Column(
        children: [
          const Divider(
            thickness: 1,
            color: AppColor.platinumColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("You Pay",
                  style: AppTextStyle.titleMedium
                      .copyWith(color: AppColor.turtleGreen)),
              Text(viewModel.orderDetail!.formattedOrderTotal.toString(),
                  style: AppTextStyle.titleMedium
                      .copyWith(color: AppColor.turtleGreen)),
            ],
          ),
        ],
      ),
    ));
    return widgetsTwo;
  }

  Widget showTransactionDetails(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(key,
                style:
                AppTextStyle.bodyMedium.copyWith(color: AppColor.concord)),
          ),
          Expanded(child: Text(value, style: AppTextStyle.bodyMedium))
        ],
      ),
    );
  }

}

class _FromSuccessCard extends ViewModelWidget<OrderDetailViewModel> {
  @override
  Widget build(BuildContext context, OrderDetailViewModel viewModel) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColor.green.withOpacity(0.2),
        border: Border.all(color: AppColor.green),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Expanded(child: Text("Order Placed Successfully.", style: AppTextStyle.bodyMedium.copyWith(color: AppColor.greenText),)),

          HorizontalSpacing.d10px(),

          const Icon(CupertinoIcons.checkmark_seal_fill, color: AppColor.green, size: 30,),

        ],
      ),

    );
  }
}

class TrackOrderInfoBottomSheet extends StatelessWidget {

  final List<TrackingInfo>? info;

  const TrackOrderInfoBottomSheet(this.info);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [

        SafeArea(
          child: Column(
              children: info!.map((e) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 5.0,top: 5.0,left: 15.0,right: 15.0,),
                  child: Column(
                    children: [
                      Text(e.message!, style: AppTextStyle.bodyMedium,),

                      VerticalSpacing.d10px(),

                      InkWell(
                        onTap: (){
                          locator<DialogService>().dialogComplete(AlertResponse());
                          launchUrl(Uri.parse(e.trackingUrl!));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text("Tracking No: ", style: AppTextStyle.bodyMedium.copyWith(color: AppColor.primary, decoration: TextDecoration.underline),),

                            Expanded(child: Text(e.trackingNumber!, style: AppTextStyle.bodyMedium.copyWith(color: AppColor.primary,  decoration: TextDecoration.underline),)),

                          ],
                        ),
                      ),

                      VerticalSpacing.d10px(),

                      AppStyle.customDivider

                    ],
                  ),
                );
              }).toList()
          ),
        )


      ],
    );
  }

}

class _ItemListSection extends ViewModelWidget<OrderDetailViewModel> {

  @override
  Widget build(BuildContext context, OrderDetailViewModel viewModel) {

    if (viewModel.orderDetail!.hasTaxableItems!) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Padding(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: Text("Non-Taxable Products",  style: AppTextStyle.titleMedium,),
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

                const Expanded(child: Text("Non-Taxable Subtotal",  style: AppTextStyle.titleSmall,)),

                Text(viewModel.orderDetail!.formattedNonTaxableSubTotal!,  style: AppTextStyle.titleSmall,),

              ],
            ),
          ),

          AppStyle.customDivider,

          const Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            child: Text("Taxable Products",  style: AppTextStyle.titleMedium,),
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

                const Expanded(child: Text("Taxable Subtotal",  style: AppTextStyle.titleSmall,)),

                Text(viewModel.orderDetail!.formattedTaxableSubTotal!,  style: AppTextStyle.titleSmall,),

              ],
            ),
          ),

          AppStyle.dottedDivider,

          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 15),
            child: Row(
              children: [

                const Expanded(child: Text("Tax",  style: AppTextStyle.titleSmall,)),

                Text(viewModel.orderDetail!.formattedTaxableItemsTax!,  style: AppTextStyle.titleSmall,),

              ],
            ),
          ),

        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 10,),
          child: Text("Items",  style: AppTextStyle.titleMedium,),
        ),

        ListView.separated(
          itemCount: viewModel.orderDetail?.orderLineItems?.length ?? 0,
          shrinkWrap: true,
          primary: false,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          separatorBuilder: (context, index) {
            return VerticalSpacing.d10px();
          },
          itemBuilder: (context, index) {
            return _ItemCard(viewModel.orderDetail!.orderLineItems![index],);
          },
        ),
      ],
    );
  }

}

class _ItemCard extends StatelessWidget {

  CartItem item;

  _ItemCard(this.item);

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        locator<NavigationService>().pushNamed(item.targetUrl);
      },
      child: Container(
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
                NetworkImageLoader(
                  image: item.primaryImageUrl,
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                  borderRadius: BorderRadius.circular(5),
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
                        
                        style: AppTextStyle.bodyMedium,
                      ),
                      VerticalSpacing.d5px(),

                      Row(
                        children: [

                          Text("${item.formattedUnitPrice!} x ${item.quantity}",
                            style: AppTextStyle.titleSmall,
                            
                          ),


                          Expanded(
                            child:  Text(item.formattedSubTotal!,
                              style: AppTextStyle.titleSmall,
                              
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
    );
  }

}

class _OrderSummary extends ViewModelWidget<OrderDetailViewModel> {
  @override
  Widget build(BuildContext context, OrderDetailViewModel viewModel) {
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
                itemCount: viewModel.orderDetail!.orderTotalSummary!.length,
                primary: false,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 2),
                separatorBuilder: (context, index) {
                  return AppStyle.dottedDivider;
                },
                itemBuilder: (context, index) {
                  OrderTotalSummary item = viewModel.orderDetail!.orderTotalSummary![index];

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 15,
                    ),
                    child: Row(
                      children: [
                        Text(
                          item.key!,
                          
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
                    Text("Total",  style: AppTextStyle.titleLarge.copyWith(fontSize: 17)),
                    Expanded(child: Container()),
                    Text(viewModel.orderDetail!.formattedOrderTotal!, style: AppTextStyle.titleLarge.copyWith(fontSize: 17))
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

class _PaymentInstruction extends ViewModelWidget<OrderDetailViewModel> {

  @override
  Widget build(BuildContext context, OrderDetailViewModel viewModel) {
    return Container(
      color: AppColor.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Text(
              "Payment Instructions",
              
              style: AppTextStyle.titleMedium.copyWith(fontSize: 17),
            ),
          ),

          ...viewModel.orderDetail!.paymentInstructions!.map((e) {
            return Container(
              padding: const EdgeInsets.all(15),
              child: ApmexHtmlWidget(e,
                textStyle: AppTextStyle.bodyMedium,
              ),
            );
          }).toList()
        ],
      ),
    );
  }

}

class PaymentAcknowledgementBottomSheet extends StatelessWidget {

  final PaymentAcknowledgement? info;

  PaymentAcknowledgementBottomSheet(this.info);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [

        SafeArea(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const Icon(Icons.check_circle, color: AppColor.green, size: 60,),

                VerticalSpacing.d15px(),

                Text(info!.title!,  textAlign: TextAlign.center, style: AppTextStyle.titleMedium,),

                if (info!.subText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(info!.subText,  textAlign: TextAlign.center, style: AppTextStyle.bodyMedium,),
                  ),

                VerticalSpacing.d5px(),

                Text(info!.message!,  textAlign: TextAlign.center, style: AppTextStyle.bodyMedium,),

              ],
            ),
          ),
        )


      ],
    );
  }

}

class _SettingItemGuestUser extends ViewModelWidget<OrderDetailViewModel> {
  @override
  Widget build(BuildContext context, OrderDetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppStyle.elevatedCardShadow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Register as User",
            style: AppTextStyle.titleMedium,
          ),
          VerticalSpacing.d10px(),

          const Text(
            "Want to Check the Status of your Order?",
            style: AppTextStyle.titleSmall,
          ),
          VerticalSpacing.d5px(),

          const Text(
            "Start by creating a password associated with your email address. This will allow you to check order status and tracking information.",
            style: AppTextStyle.bodyMedium,
          ),
          VerticalSpacing.d20px(),
          Button.outline("Register As User",
              width: double.infinity,
              textStyle: AppTextStyle.bodyMedium.copyWith(color: AppColor.primary),
              valueKey: const ValueKey("btnRegisterAsUser"), onPressed: () {
                viewModel.onGuestRegisterClick();
              })
        ],
      ),
    );
  }
}
