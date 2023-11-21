import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/view/checkout/checkout_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CheckoutPage extends VGTSBuilderWidget<CkeckOutPageViewModel> {
  const CheckoutPage({super.key});

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, CkeckOutPageViewModel viewModel, Widget? child) {
    return Scaffold(
        backgroundColor: AppColor.secondaryBackground,
        appBar: AppBar(
            shadowColor: Colors.black54,
            centerTitle: false,
            leadingWidth: 30,
            actions: [
              Chip(
                backgroundColor: AppColor.primary,
                side: BorderSide.none,
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                label: SizedBox(
                  height: 20,
                  child: Row(
                    children: [
                      // const Icon(Icons.timer_rounded, color: Colors.white, size: 12),
                      // HorizontalSpacing.d5px(),
                      Text('${viewModel.minutes.toString().padLeft(2, '0')} : ${viewModel.formattedSeconds}',
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.white,
                            fontFamily: AppTextStyle.fontFamily,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  ),
                ),
              ),
              HorizontalSpacing.d15px(),
            ],
            leading: IconButton(onPressed: () => locator<NavigationService>().pop(), icon: const Icon(Icons.arrow_back_ios, size: 19), padding: const EdgeInsets.symmetric(horizontal: 15)),
            title: Text('Confirm your Order', style: AppTextStyle.titleMedium.copyWith(color: Colors.black))),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const ScrollPhysics(parent: ClampingScrollPhysics()),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VerticalSpacing.d30px(),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text('Shipping Address', style: AppTextStyle.titleSmall),
                    ),
                    VerticalSpacing.d10px(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        //borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30)),
                        boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 12)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Oliver Jake ',
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.bodyMedium.copyWith(color: Colors.black87),
                                  maxLines: 1,
                                  softWrap: true,
                                ),
                                VerticalSpacing.d5px(),
                                Text(
                                  '555 555-123',
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.bodySmall.copyWith(color: Colors.black54),
                                  maxLines: 1,
                                  softWrap: true,
                                ),
                                VerticalSpacing.d2px(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Akshya Nagar 1st Block 1st Cross, Rammurthy nagar, Bangalore-560016',
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyle.bodySmall.copyWith(color: Colors.black54),
                                        maxLines: 1,
                                        softWrap: true,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.black38,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VerticalSpacing.d30px(),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text('Select Payment Options', style: AppTextStyle.titleSmall),
                        ),
                        VerticalSpacing.d10px(),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(14))),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            FontAwesomeIcons.solidCreditCard,
                                            color: AppColor.primary,
                                            size: 15,
                                          ),
                                          HorizontalSpacing.d15px(),
                                          const Text(
                                            'Debit/Credit Cards',
                                            style: AppTextStyle.bodyMedium,
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            size: 19,
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            VerticalSpacing.d15px(),
                                            Text(
                                              'XXXX XXXX XXXX 9089',
                                              style: AppTextStyle.bodySmall.copyWith(color: Colors.black45),
                                            ),
                                            VerticalSpacing.d15px(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                const Icon(Icons.add_card_outlined, color: AppColor.green, size: 15),
                                                HorizontalSpacing.d5px(),
                                                const Text(
                                                  'Add new card',
                                                  style: AppTextStyle.bodySmall,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Divider(thickness: 0.8, color: AppColor.divider, height: 0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.wallet,
                                        color: AppColor.primary,
                                        size: 15,
                                      ),
                                      HorizontalSpacing.d15px(),
                                      const Text(
                                        'ACH/eCheck',
                                        style: AppTextStyle.bodyMedium,
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 19,
                                      )
                                    ],
                                  ),
                                ),
                                const Divider(thickness: 0.8, color: AppColor.divider, height: 0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.paypal,
                                        color: AppColor.primary,
                                        size: 15,
                                      ),
                                      HorizontalSpacing.d15px(),
                                      const Text(
                                        'Paypal',
                                        style: AppTextStyle.bodyMedium,
                                      ),
                                      HorizontalSpacing.d5px(),
                                      const Icon(
                                        FontAwesomeIcons.circleCheck,
                                        size: 12,
                                        color: AppColor.primary,
                                      )
                                    ],
                                  ),
                                ),
                                const Divider(thickness: 0.8, color: AppColor.divider, height: 0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.bitcoin,
                                        color: AppColor.primary,
                                        size: 15,
                                      ),
                                      HorizontalSpacing.d15px(),
                                      const Text(
                                        'Crytocurrency via Bitpay',
                                        style: AppTextStyle.bodyMedium,
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 19,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )),
                        VerticalSpacing.d30px(),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text('Shipping Options', style: AppTextStyle.titleSmall),
                        ),
                        VerticalSpacing.d10px(),
                        Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(14)),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withOpacity(0.1), offset: const Offset(0, 2), blurRadius: 12),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        value: true,
                                        activeColor: AppColor.primary,
                                        fillColor: const MaterialStatePropertyAll(AppColor.primary),
                                        groupValue: true,
                                        onChanged: (value) {},
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Express Delivery', style: AppTextStyle.bodyMedium),
                                            VerticalSpacing.d2px(),
                                            Text(
                                              'Expeted to delivery within 11, Tue',
                                              style: AppTextStyle.bodySmall.copyWith(fontSize: 10, color: Colors.black54),
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // const Spacer(),
                                      Text('\$7.90', style: AppTextStyle.bodyMedium.copyWith(color: AppColor.text)),
                                      HorizontalSpacing.d15px(),
                                    ],
                                  ),
                                  const Divider(thickness: 0.6, color: Colors.black12, height: 15),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        value: true,
                                        activeColor: AppColor.primary,
                                        fillColor: const MaterialStatePropertyAll(AppColor.primary),
                                        groupValue: false,
                                        onChanged: (value) {},
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Standard Delivery', style: AppTextStyle.bodyMedium),
                                            VerticalSpacing.d2px(),
                                            Text(
                                              'Expeted to delivery within 18, Fri',
                                              style: AppTextStyle.bodySmall.copyWith(fontSize: 10, color: Colors.black54),
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // const Spacer(),
                                      Text('Free', style: AppTextStyle.bodyMedium.copyWith(color: AppColor.greenText)),
                                      HorizontalSpacing.d15px(),
                                    ],
                                  ),
                                  // Row(
                                  //   crossAxisAlignment: CrossAxisAlignment.center,
                                  //   children: [
                                  //     Radio(
                                  //       value: true,
                                  //       activeColor: AppColor.primary,
                                  //       fillColor: MaterialStatePropertyAll(AppColor.primary),
                                  //       groupValue: false,
                                  //       onChanged: (value) {},
                                  //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  //     ),
                                  //     Expanded(
                                  //       child: Column(
                                  //         crossAxisAlignment: CrossAxisAlignment.start,
                                  //         children: [
                                  //           const Text('Standard Delivery', style: AppTextStyle.bodyMedium),
                                  //           VerticalSpacing.d5px(),
                                  //           Text(
                                  //             'Expeted to delivery within 18,Fri',
                                  //             style: AppTextStyle.bodySmall.copyWith(fontSize: 10),
                                  //             maxLines: 1,
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //     const Spacer(),
                                  //     const Text('\$2.90', style: AppTextStyle.titleSmall),
                                  //     HorizontalSpacing.d15px(),
                                  //   ],
                                  // ),
                                ],
                              ),
                            )),
                        VerticalSpacing.d30px(),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 17),
                          child: Text('Order Summary', style: AppTextStyle.titleSmall),
                        ),
                        VerticalSpacing.d10px(),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(14))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Row(
                                  children: [
                                    Text('Subtotal', style: AppTextStyle.titleSmall.copyWith(color: Colors.black45)),
                                    const Spacer(),
                                    Text('\$6,521.52', style: AppTextStyle.labelLarge.copyWith(color: Colors.black54)),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 0.5,
                                color: Colors.black.withOpacity(0.09),
                                height: 0,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Row(
                                  children: [
                                    Text('Shipping, Handling & Insurance', style: AppTextStyle.titleSmall.copyWith(color: Colors.black54)),
                                    const Spacer(),
                                    Text('\$9.95', style: AppTextStyle.labelLarge.copyWith(color: Colors.black54)),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 0.5,
                                color: Colors.black.withOpacity(0.09),
                                height: 0,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Row(
                                  children: [
                                    Text('Taxes', style: AppTextStyle.titleSmall.copyWith(color: Colors.black54)),
                                    const Spacer(),
                                    Text('\$5.60', style: AppTextStyle.labelLarge.copyWith(color: Colors.black54)),
                                  ],
                                ),
                              ),

                              // Container(
                              //   padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                              //   margin: const EdgeInsets.only(left: 10,top: 0),
                              //   decoration: BoxDecoration(
                              //     color: Colors.white,
                              //      borderRadius: const BorderRadius.all(Radius.circular(8)),
                              //     boxShadow: [
                              //       BoxShadow(color: Colors.black.withOpacity(0.06), offset: const Offset(0, 2), blurRadius: 12),
                              //     ],
                              //   ),
                              //   child: Text('See How its Calculated  ▼',style: AppTextStyle.bodySmall.copyWith(fontWeight: FontWeight.w500,color: Colors.black54)),
                              // ),
                              VerticalSpacing.d10px(),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                child: Row(
                                  children: [
                                    const Text('Total', style: AppTextStyle.titleMedium),
                                    const Spacer(),
                                    Text('\$6,521.52', style: AppTextStyle.titleMedium.copyWith(color: Colors.black87)),
                                  ],
                                ),
                              ),
                              VerticalSpacing.d10px()
                            ],
                          ),
                        ),
                        VerticalSpacing.d15px(),
                        Center(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                'CheckOut Information and updated will be emailed to\nJohn@apmex.com | Cart Id: 328657',
                                style: AppTextStyle.labelSmall.copyWith(color: Colors.black38),
                                textAlign: TextAlign.center,
                              )),
                        ),
                        VerticalSpacing.custom(value: 150),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 12)]),
                child: SafeArea(
                    child: Column(
                  children: [
                    VerticalSpacing.d5px(),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'By Placing an Order, I agree to ',
                            style: AppTextStyle.labelSmall.copyWith(fontSize: 8),
                          ),
                          Text(
                            'Terms and cancellation policy ',
                            style: AppTextStyle.labelSmall.copyWith(fontSize: 8, color: AppColor.primary, decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                    VerticalSpacing.d15px(),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const BoxDecoration(color: AppColor.primary, borderRadius: BorderRadius.all(Radius.circular(4)), boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 12)]),
                      child: Center(child: Text('Place Order', style: AppTextStyle.titleMedium.copyWith(color: const Color.fromARGB(255, 249, 248, 248)))),
                    ),
                    // VerticalSpacing.d15px(),
                  ],
                )),
              ),
            )
          ],
        ));
  }

  @override
  CkeckOutPageViewModel viewModelBuilder(BuildContext context) {
    return CkeckOutPageViewModel();
  }
}
