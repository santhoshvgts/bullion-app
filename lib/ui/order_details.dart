import 'package:bullion/ui/view/order_details_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../core/res/colors.dart';
import '../core/res/images.dart';
import '../core/res/styles.dart';

class OrderDetails extends VGTSBuilderWidget<OrderDetailsViewModel> {
  const OrderDetails({super.key});

  @override
  void onViewModelReady(OrderDetailsViewModel viewModel) {
    super.onViewModelReady(viewModel);
  }

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      OrderDetailsViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: SingleChildScrollView(
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "#7161760",
                            style: AppTextStyle.bodyMedium,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Processing Payment",
                            style: AppTextStyle.labelMedium
                                .copyWith(color: AppColor.cyanBlue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            getDetailRow("Order Date", "June 5 , 2023"),
            getDetailRow("Shipping Date", "--"),
            getDetailRow("Payment Method", "Bank Wire"),
            getDetailRow("Address",
                "4517 Washington Ave, Manchester, Kentucky 399495 +11 748537766"),
            const Divider(color: AppColor.secondaryBackground, thickness: 8),
            showOrderSummary(),
            showPriceDetails(),
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

  Widget showOrderSummary() {
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
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColor.platinumColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: Image.asset(Images.marketNews),
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
                        const Text(
                          "1 oz gold bar-Royal Canadian Mint New Design",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: AppTextStyle.labelLarge,
                        ),
                        Text(
                          "Qty: 2",
                          style: AppTextStyle.bodySmall
                              .copyWith(color: AppColor.primaryText),
                        ),
                        Text(
                          "\$ 130.00",
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

  Widget showPriceDetails() {
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
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Card Total",
                            style: AppTextStyle.bodyMedium
                                .copyWith(color: AppColor.concord)),
                        const Text("\$ 130.00", style: AppTextStyle.bodyMedium)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Shipping, Handling & Insurance",
                            style: AppTextStyle.bodyMedium
                                .copyWith(color: AppColor.concord)),
                        Text("Free",
                            style: AppTextStyle.bodyMedium
                                .copyWith(color: AppColor.turtleGreen)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Promo code Savings",
                            style: AppTextStyle.bodyMedium
                                .copyWith(color: AppColor.concord)),
                        Text("-\$ 1.00",
                            style: AppTextStyle.bodyMedium
                                .copyWith(color: AppColor.turtleGreen)),
                      ],
                    ),
                  ),
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
                      Text("\$ 129.00",
                          style: AppTextStyle.titleMedium
                              .copyWith(color: AppColor.turtleGreen)),
                    ],
                  ),
                ],
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
          showTransactionDetails(
              "Payment Method", "Bank Wire (No ACH Accepted)"),
          showTransactionDetails("Beneficiary",
              "APMEX - Clearing Account ,226 Dean A. McGee Avenue Oklahoma City, OK 73102"),
          showTransactionDetails("Beneficiary Account Number",
              "7792990008 Bank of Oklahoma : 215 State StMuskogee, OK 74401SWIFT BAOKUS44"),
          showTransactionDetails("ABA Routing Number", "103 900 036"),
          showTransactionDetails("Ref", "Lfs asd / 7161760"),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 168,
            decoration: BoxDecoration(
              color: AppColor.eggSour,
              border: Border.all(width: 1, color: AppColor.orangePeel),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Column(children: [
                Row(
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
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "In accordance with our Market Loss Policy, this transaction is locked in and may not be cancelled by you if you do not send in your payment, you will be subject to our Market Learn More",
                    style: AppTextStyle.bodyMedium,
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
