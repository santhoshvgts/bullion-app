

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
            leading: IconButton(onPressed: () => locator<NavigationService>().pop(), icon: const Icon(Icons.arrow_back_ios, size: 19), padding: const EdgeInsets.symmetric(horizontal: 15)),
            title: Text(
              '100 gram Gold Bar',
              style: AppTextStyle.titleMedium.copyWith(color: Colors.black),
            )),
        body: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30)),
                      boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 12)],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center, // Centered and spaced
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Your pricing is fixed for:',
                                style: AppTextStyle.labelSmall,
                                maxLines: 1,
                              ),
                              VerticalSpacing.custom(value: 6.5),
                              Text(
                                '0${viewModel.minutes} : ${viewModel.seconds}',
                                style: AppTextStyle.titleLarge.copyWith(
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25, child: VerticalDivider(color: Colors.black12, thickness: 1.5, width: 40)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Shipping Address', style: AppTextStyle.labelMedium),
                              VerticalSpacing.custom(value: 6.5),
                              InkWell(
                                onTap: () {},
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Akshya Nagar 1st Block 1st Cross, Rammurthy nagar, Bangalore-560016',
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyle.bodyMedium.copyWith(color: Colors.black54),
                                        maxLines: 1,
                                        softWrap: true,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.black38,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VerticalSpacing.d20px(),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Shipping Options',
                          style: AppTextStyle.titleMedium,
                        ),
                      ),
                      VerticalSpacing.d10px(),
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Container(
                          height: 155,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(0), bottomLeft: Radius.circular(0)),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.1), offset: const Offset(0, 2), blurRadius: 12),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 0),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(left: 15),
                            children: [
                              Container(
                                width: 200,
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                decoration: BoxDecoration(color: AppColor.secondary.withOpacity(0.04), borderRadius: const BorderRadius.all(Radius.circular(4)), border: Border.all(color: AppColor.primary, width: 1.5)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('\$0.00', style: AppTextStyle.titleSmall.copyWith(color: AppColor.primary)),
                                    VerticalSpacing.d20px(),
                                    const Text('Free Standard shipping with\nthe carrier of your choise', style: AppTextStyle.labelMedium),
                                  ],
                                ),
                              ),
                              HorizontalSpacing.d20px(),
                              Container(
                                width: 200,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(4)), border: Border.all(color: AppColor.border, width: 1.5)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('\$17.30', style: AppTextStyle.titleSmall.copyWith(color: AppColor.primary)),
                                        const Icon(
                                          Icons.info,
                                          size: 20,
                                          color: Colors.black38,
                                        )
                                      ],
                                    ),
                                    VerticalSpacing.d20px(),
                                    const Text('UPS Ground', style: AppTextStyle.labelMedium),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      VerticalSpacing.d20px(),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                          'Bill Details',
                          style: AppTextStyle.titleMedium,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 13,vertical: 5),
                        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(14))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              child: Row(
                                children: [
                                  Text('Subtotal', style: AppTextStyle.titleSmall.copyWith(color: Colors.black45)),
                                  const Spacer(),
                                  Text('\$6,521.52', style: AppTextStyle.labelLarge.copyWith(color: Colors.black54)),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.black.withOpacity(0.09),
                              height: 0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              child: Row(
                                children: [
                                  Text('Shipping, Handling & Insurance', style: AppTextStyle.titleSmall.copyWith(color: Colors.black45)),
                                  const Spacer(),
                                  Text('Free', style: AppTextStyle.labelLarge.copyWith(color: AppColor.primary)),
                                ],
                              ),
                            ),
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
                            VerticalSpacing.d20px()
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              'CheckOut Information and updated will be emailed to\nJohn@apmex.com | Cart Id: 328657',
                              style: AppTextStyle.labelSmall.copyWith(color: Colors.black38,fontSize: 10),
                              textAlign: TextAlign.center,
                            )),
                      )
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 15, 14, 0),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 12)],
                ),
                child: SafeArea(
                    child: Column(
                      children: [
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               Text('By Placing an Order, I agree to ',style: AppTextStyle.labelSmall.copyWith(fontSize: 8),),
                                Text('Terms and cancellation policy ',style: AppTextStyle.labelSmall.copyWith(fontSize: 8,color: AppColor.primary,decoration: TextDecoration.underline),),
                            ],
                          ),
                        ),
                        VerticalSpacing.d15px(),
                        Row(
                  children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(FontAwesomeIcons.ccAmex, color: Colors.blue),
                                HorizontalSpacing.d10px(),
                                Text('PAY USING', style: AppTextStyle.bodySmall.copyWith(color: Colors.black45, fontWeight: FontWeight.w500)),
                                const Icon(Icons.arrow_drop_up_sharp, color: Colors.black45)
                              ],
                            ),
                            VerticalSpacing.d5px(),
                            Text('Credit Card', style: AppTextStyle.titleSmall.copyWith(fontWeight: FontWeight.w500, color: Colors.black.withOpacity(0.75)))
                          ],
                        ),
                        HorizontalSpacing.custom(value: 15),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                            decoration: BoxDecoration(
                              color: AppColor.primary60,
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 12),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('\$6,521.52', style: AppTextStyle.titleMedium.copyWith(color: const Color.fromARGB(255, 249, 248, 248), fontWeight: FontWeight.w500)),
                                    Text('TOTAL', style: AppTextStyle.labelMedium.copyWith(color: const Color.fromARGB(255, 249, 248, 248))),
                                  ],
                                ),
                                HorizontalSpacing.custom(value: 0),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Place Order', style: AppTextStyle.titleMedium.copyWith(color: const Color.fromARGB(255, 249, 248, 248))),
                                    HorizontalSpacing.d2px(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                  ],
                ),
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
