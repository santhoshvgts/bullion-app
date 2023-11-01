import 'dart:io';

import 'package:bullion/ui/view/order_details_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/apmex_html_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../core/res/colors.dart';
import '../core/res/styles.dart';

class OrderDetails extends VGTSBuilderWidget<OrderDetailsViewModel> {
  final String orderID;
  static const double _expandedHeight = 100;
  static const double _scrollOffset = 36;

  const OrderDetails(this.orderID, {super.key});

  final String text =
      "In accordance with our Market Loss Policy, this transaction is locked in and may not be cancelled by you if you do not send in your payment, you will be subject to our Market";

  @override
  void onViewModelReady(OrderDetailsViewModel viewModel) {
    viewModel.init(orderID);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      OrderDetailsViewModel viewModel, Widget? child) {
    return Scaffold(
/*      appBar: AppBar(
        toolbarHeight: 80,
        leadingWidth: double.infinity,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back_ios),
                  Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(Icons.local_print_shop_outlined),
                  ),
                ],
              ),
              Text(
                "Order Details",
                style: AppTextStyle.titleLarge,
              ),
            ],
          ),
        ),
      )*/
      body: SafeArea(
        child: CustomScrollView(
          controller: viewModel.scrollController,
          slivers: [
            SliverAppBar(
              leading: IconButton(
                icon: Platform.isAndroid
                    ? const Icon(Icons.arrow_back)
                    : const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
              ),
              expandedHeight: _expandedHeight,
              pinned: true,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double percent = ((constraints.maxHeight - kToolbarHeight) *
                      100 /
                      (10 - kToolbarHeight));
                  double dx = 0;

                  dx = 100 + percent;

                  //To reduce the space between start to end
                  dx = (dx * 64) / 100;

                  return Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: kToolbarHeight / 4, left: 16),
                        child: Transform.translate(
                          offset: Offset(
                              dx, constraints.maxHeight - kToolbarHeight),
                          child: const Text("Order Details",
                              style: AppTextStyle.titleLarge),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: viewModel.isBusy
                  ? const Align(
                      alignment: Alignment.bottomCenter,
                      child: LinearProgressIndicator())
                  : viewModel.orderDetail == null
                      ? const Center(child: Text("No data available"))
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColor.iconBG,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      width: 56,
                                      height: 56,
                                      child: const Icon(
                                        Icons.receipt_long_outlined,
                                        size: 32,
                                        color: AppColor.turtleGreen,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              viewModel.orderDetail?.orderId ??
                                                  "",
                                              style: AppTextStyle.bodyMedium,
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              viewModel.orderDetail
                                                      ?.orderStatus ??
                                                  "",
                                              style: AppTextStyle.labelMedium
                                                  .copyWith(
                                                      color: AppColor.cyanBlue),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              getDetailRow("Order Date", viewModel.date ?? ""),
                              getDetailRow("Shipping Date", "--"),
                              getDetailRow(
                                "Payment Method",
                                viewModel.orderDetail?.paymentMethod
                                        ?.displayText ??
                                    "",
                              ),
                              getDetailRow(
                                "Address",
                                viewModel.orderDetail?.shippingAddress
                                        ?.displayText ??
                                    "",
                              ),
                              const Divider(
                                  color: AppColor.secondaryBackground,
                                  thickness: 8),
                              showOrderSummary(viewModel),
                              showPriceDetails(viewModel),
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
  OrderDetailsViewModel viewModelBuilder(BuildContext context) {
    return OrderDetailsViewModel();
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

  Widget showOrderSummary(OrderDetailsViewModel viewModel) {
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

  List<Widget> showOrderSummaryPairs(OrderDetailsViewModel viewModel) {
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

  Widget showPriceDetails(OrderDetailsViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text("Price Details", style: AppTextStyle.titleMedium),
          ),
          Container(
            height: 176,
            decoration: BoxDecoration(
              color: AppColor.secondaryBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: showOrderSummaryPairs(viewModel),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Button("Sent Payment",
                      valueKey: const Key("btnCancelOrder"),
                      onPressed: () {},
                      textStyle: AppTextStyle.titleSmall
                          .copyWith(color: AppColor.turtleGreen),
                      color: Colors.white,
                      borderColor: AppColor.border),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Button("Change Payment",
                      valueKey: const Key("btnTrackShipment"),
                      onPressed: () {}),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          if (viewModel.orderDetail?.paymentInstructions != null &&
              viewModel.orderDetail!.paymentInstructions!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ApmexHtmlWidget(
                  viewModel.orderDetail?.paymentInstructions?[0]),
            ),
          /*showTransactionDetails(
              "Payment Method", "Bank Wire (No ACH Accepted)"),
          showTransactionDetails("Beneficiary",
              "APMEX - Clearing Account ,226 Dean A. McGee Avenue Oklahoma City, OK 73102"),
          showTransactionDetails("Beneficiary Account Number",
              "7792990008 Bank of Oklahoma : 215 State StMuskogee, OK 74401SWIFT BAOKUS44"),
          showTransactionDetails("ABA Routing Number", "103 900 036"),
          showTransactionDetails("Ref", "Lfs asd / 7161760"),*/
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            //height: 168,
            decoration: BoxDecoration(
              color: AppColor.eggSour,
              border: Border.all(width: 1, color: AppColor.orangePeel),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(children: [
                const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColor.orangePeel,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Note",
                        style: AppTextStyle.labelLarge,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    child: viewModel.isExpanded
                        ? Text(
                            text,
                            style: AppTextStyle.bodyMedium,
                          )
                        : Wrap(
                            children: [
                              Text(
                                "${text.substring(0, 150)}...",
                                style: AppTextStyle.bodyMedium,
                              ),
                              InkWell(
                                  child: Text(
                                    "Learn More",
                                    style: AppTextStyle.bodyMedium
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    viewModel.isExpanded = true;
                                  }),
                            ],
                          ),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}
