// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:bullion/core/models/module/checkout/payment_method.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/widgets/apmex_html_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';

import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/view/checkout/checkout_view_model.dart';

class CkPayment extends ViewModelWidget<CheckoutPageViewModel> {
  const CkPayment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, CheckoutPageViewModel viewModel) {
    var visibleMethods = viewModel.paymentMethodList?.where((method) => method.isEnabled == true).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.only(top: 10, left: 15), child: Text('Select Payment Options', style: AppTextStyle.titleMedium)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => AppStyle.dottedDivider,
                itemCount: visibleMethods?.length ?? 0,
                itemBuilder: (context, index) {
                  PaymentMethod payment = visibleMethods![index];
                  return InkWell(
                    onTap: () => viewModel.paymentSelection(payment),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              payment.icon == null ? Container() : Icon(viewModel.paymentFAIcon(payment.icon), color: AppColor.primary, size: 15),
                              HorizontalSpacing.d20px(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(payment.name ?? '', style: AppTextStyle.bodyMedium),
                                      HorizontalSpacing.d5px(),
                                      if (payment.isSelected == true) const Icon(FontAwesomeIcons.solidCircleCheck, size: 12, color: AppColor.primary)
                                    ],
                                  ),
                                  VerticalSpacing.d2px(),
                                  Text(payment.shortDescription ?? '', style: AppTextStyle.bodySmall.copyWith(color: Colors.black54, fontSize: 11)),
                                ],
                              ),
                              const Spacer(),
                              InkWell(
                                key: Key("cardPaymentItem${payment.paymentMethodId}"),
                                onTap: () => locator<DialogService>().showBottomSheet(title: payment.name, child: _PaymentSummaryHelpText(payment?.description)),
                                child: const Icon(
                                  Icons.info_outline,
                                  size: 18,
                                  color: Colors.black45,
                                ),
                              ),
                              HorizontalSpacing.d10px(),
                            ],
                          ),
                          _CreditCard(payment: payment),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CreditCard extends ViewModelWidget<CheckoutPageViewModel> {
  const _CreditCard({required this.payment});

  final PaymentMethod payment;

  @override
  Widget build(BuildContext context, CheckoutPageViewModel viewModel) {
    return ClipRect(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut, // Adding a curve for smoother animation
        child: payment.canExpanded == true && payment.supportsUserPaymentMethod == true
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (payment.hasUserPaymentMethod == true)
                      Row(
                        children: [
                          if (payment.hasUserPaymentMethod == true)
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: payment.userPaymentMethods?[0].accountNumber,
                                onChanged: (String? newValue) {},
                                items: payment.userPaymentMethods?.map((e) {
                                  return DropdownMenuItem<String>(
                                    value: e.accountNumber,
                                    child: Text(
                                      e.accountNumber ?? '',
                                      style: AppTextStyle.bodySmall.copyWith(
                                        color: e.isSelected == true ? AppColor.primary : AppColor.disabled,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    VerticalSpacing.d15px(),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.add_card_outlined, color: AppColor.green, size: 15),
                          HorizontalSpacing.d5px(),
                          const Text(
                            'Add new card',
                            style: AppTextStyle.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _PaymentSummaryHelpText extends StatelessWidget {
  final String? helpText;

  const _PaymentSummaryHelpText(this.helpText);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: ApmexHtmlWidget(
          helpText,
          textStyle: AppTextStyle.bodyMedium,
        ),
      ),
    );
  }
}

// Container(
//                             margin: const EdgeInsets.symmetric(horizontal: 15),
//                             decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(14))),

/// !!!!!!!!!!!!!!!! Payment Method Full !!!!!!!!!!!!!!!!

//                           Column(
//                             children: [
//                               VerticalSpacing.d5px(),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//                                 child: Row(children: [
//                                   const Icon(
//                                     FontAwesomeIcons.solidCreditCard,
//                                     color: AppColor.primary,
//                                     size: 15,
//                                   ),
//                                   HorizontalSpacing.d20px(),
//                                   Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                                     const Text(
//                                       'Credit/Debit Cards',
//                                       style: AppTextStyle.bodyMedium,
//                                     ),
//                                     VerticalSpacing.d2px(),
//                                     Text(
//                                       '1-3 Business Days',
//                                       style: AppTextStyle.bodySmall.copyWith(color: Colors.black54, fontSize: 11),
//                                     )
//                                   ]),
//                                   const Spacer(),
//                                   const Icon(Icons.info_outline, size: 16, color: Colors.black45),
//                                   HorizontalSpacing.d10px(),
//                                 ]),
//                               ),
//                               const Divider(thickness: 0.4, color: AppColor.divider, height: 0),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//                                 child: Row(
//                                   children: [
//                                     const Icon(
//                                       FontAwesomeIcons.wallet,
//                                       color: AppColor.primary,
//                                       size: 15,
//                                     ),
//                                     HorizontalSpacing.d20px(),
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         const Text(
//                                           'Bank Wire',
//                                           style: AppTextStyle.bodyMedium,
//                                         ),
//                                         VerticalSpacing.d2px(),
//                                         Text(
//                                           '1-3 Business Days',
//                                           style: AppTextStyle.bodySmall.copyWith(color: Colors.black54, fontSize: 11),
//                                         ),
//                                       ],
//                                     ),
//                                     const Spacer(),
//                                     const Icon(Icons.info_outline, size: 16, color: Colors.black45),
//                                     HorizontalSpacing.d10px(),
//                                   ],
//                                 ),
//                               ),
//                               const Divider(thickness: 0.4, color: AppColor.divider, height: 0),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//                                 child: Row(
//                                   children: [
//                                     const Icon(
//                                       FontAwesomeIcons.paypal,
//                                       color: AppColor.primary,
//                                       size: 15,
//                                     ),
//                                     HorizontalSpacing.d20px(),
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             const Text(
//                                               'Paypal',
//                                               style: AppTextStyle.bodyMedium,
//                                             ),
//                                             HorizontalSpacing.d5px(),
//                                             const Icon(
//                                               FontAwesomeIcons.solidCircleCheck,
//                                               size: 12,
//                                               color: AppColor.primary,
//                                             )
//                                           ],
//                                         ),
//                                         VerticalSpacing.d2px(),
//                                         Text(
//                                           '1-3 Business Days',
//                                           style: AppTextStyle.bodySmall.copyWith(color: Colors.black54, fontSize: 11),
//                                         ),
//                                       ],
//                                     ),
//                                     const Spacer(),
//                                     const Icon(Icons.info_outline, size: 16, color: Colors.black45),
//                                     HorizontalSpacing.d10px(),
//                                   ],
//                                 ),
//                               ),
//                               const Divider(thickness: 0.4, color: AppColor.divider, height: 0),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//                                 child: Row(
//                                   children: [
//                                     const Icon(
//                                       FontAwesomeIcons.moneyCheck,
//                                       color: AppColor.primary,
//                                       size: 15,
//                                     ),
//                                     HorizontalSpacing.d20px(),
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         const Text(
//                                           'ACH/eCheck',
//                                           style: AppTextStyle.bodyMedium,
//                                         ),
//                                         VerticalSpacing.d2px(),
//                                         Text(
//                                           '6-8 Business Days',
//                                           style: AppTextStyle.bodySmall.copyWith(color: Colors.black54, fontSize: 11),
//                                         ),
//                                       ],
//                                     ),
//                                     const Spacer(),
//                                     const Icon(
//                                       Icons.info_outline,
//                                       size: 16,
//                                       color: Colors.black45,
//                                     ),
//                                     HorizontalSpacing.d10px(),
//                                   ],
//                                 ),
//                               ),
//                               const Divider(thickness: 0.4, color: AppColor.divider, height: 0),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//                                 child: Row(
//                                   children: [
//                                     const Icon(
//                                       FontAwesomeIcons.moneyCheck,
//                                       color: AppColor.primary,
//                                       size: 15,
//                                     ),
//                                     HorizontalSpacing.d20px(),
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         const Text(
//                                           'Paper Check',
//                                           style: AppTextStyle.bodyMedium,
//                                         ),
//                                         VerticalSpacing.d2px(),
//                                         Text(
//                                           'Ships 6-8 Business Days from\nReceived Check',
//                                           style: AppTextStyle.bodySmall.copyWith(color: Colors.black54, fontSize: 11),
//                                         ),
//                                       ],
//                                     ),
//                                     const Spacer(),
//                                     const Icon(
//                                       Icons.info_outline,
//                                       size: 16,
//                                       color: Colors.black45,
//                                     ),
//                                     HorizontalSpacing.d10px(),
//                                   ],
//                                 ),
//                               ),
//                               const Divider(thickness: 0.4, color: AppColor.divider, height: 0),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//                                 child: Row(
//                                   children: [
//                                     const Icon(
//                                       FontAwesomeIcons.bitcoin,
//                                       color: AppColor.primary,
//                                       size: 15,
//                                     ),
//                                     HorizontalSpacing.d20px(),
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         const Text(
//                                           'Cryptocurrency via BitPay',
//                                           style: AppTextStyle.bodyMedium,
//                                         ),
//                                         VerticalSpacing.d2px(),
//                                         Text(
//                                           'Up to 5 Business Days',
//                                           style: AppTextStyle.bodySmall.copyWith(color: Colors.black54, fontSize: 11),
//                                         ),
//                                       ],
//                                     ),
//                                     const Spacer(),
//                                     const Icon(
//                                       Icons.info_outline,
//                                       size: 16,
//                                       color: Colors.black45,
//                                     ),
//                                     HorizontalSpacing.d10px(),
//                                   ],
//                                 ),
//                               ),
//                               VerticalSpacing.d5px(),
//                             ],
//                           ),
// ///////

//   ///!!!!!!!!!!!!!!!!  Payment Method Less !!!!!!!!!!!!!!!!!
//   child: Column(
//     children: [
//       VerticalSpacing.d5px(),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//         child: Row(children: [
//           const Icon(
//             FontAwesomeIcons.solidCreditCard,
//             color: AppColor.black20,
//             size: 15,
//           ),
//           HorizontalSpacing.d20px(),
//           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             const Text(
//               'Credit/Debit Cards',
//               style: AppTextStyle.bodyMedium,
//             ),
//             VerticalSpacing.d2px(),
//             Text(
//               '1-3 Business Days',
//               style: AppTextStyle.bodySmall.copyWith(color: Colors.black54, fontSize: 11),
//             )
//           ]),
//           const Spacer(),
//           const Icon(Icons.info_outline, size: 16, color: Colors.black45),
//           HorizontalSpacing.d10px(),
//         ]),
//       ),
//       const Divider(thickness: 0.4, color: AppColor.divider, height: 0),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const Icon(
//                   FontAwesomeIcons.buildingColumns,
//                   color: AppColor.primary,
//                   size: 15,
//                 ),
//                 HorizontalSpacing.d15px(),
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   Row(
//                     children: [
//                       Text(
//                         'ACH/eCheck',
//                         style: AppTextStyle.bodyMedium.copyWith(color: AppColor.primary),
//                       ),
//                       HorizontalSpacing.d5px(),
//                       const Icon(
//                         FontAwesomeIcons.solidCircleCheck,
//                         size: 12,
//                         color: AppColor.primary,
//                       )
//                     ],
//                   ),
//                   VerticalSpacing.d2px(),
//                   Text(
//                     '6-8 Business Days',
//                     style: AppTextStyle.bodySmall.copyWith(color: AppColor.primary, fontSize: 11),
//                   )
//                 ]),
//                 const Spacer(),
//                 const Icon(Icons.info_outline, size: 16, color: AppColor.primary),
//                 HorizontalSpacing.d10px(),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   VerticalSpacing.d10px(),
//                   Chip(
//                     elevation: 0,
//                     shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24)), side: BorderSide.none),
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),

//                     side: BorderSide.none,
//                     shadowColor: Colors.white,
//                     color: const MaterialStatePropertyAll(
//                       AppColor.red,
//                     ),
//                     label: Text(
//                       'verify your bank account (ACH)',
//                       style: AppTextStyle.bodySmall.copyWith(color: Colors.white),
//                     ), //Text
//                   ),

// Text(
//   'XXXX XXXX XXXX 8564',
//   style: AppTextStyle.bodySmall.copyWith(color: AppColor.primary),
// ),
// VerticalSpacing.d15px(),
// Text(
//   'Others',
//   style: AppTextStyle.bodySmall.copyWith(color: Colors.black54),
// ),
// VerticalSpacing.d15px(),
// Row(
//   mainAxisAlignment: MainAxisAlignment.start,
//   children: [
//     const Icon(Icons.add_card_outlined, color: AppColor.green, size: 15),
//     HorizontalSpacing.d5px(),
//     const Text(
//       'Add new card',
//       style: AppTextStyle.bodySmall,
//     ),
//   ],
// )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//       const Divider(thickness: 0.4, color: AppColor.divider, height: 0),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//         child: Row(
//           children: [
//             const Icon(
//               FontAwesomeIcons.paypal,
//               color: AppColor.black20,
//               size: 15,
//             ),
//             HorizontalSpacing.d20px(),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Row(
//                   children: [
//                     Text(
//                       'Paypal',
//                       style: AppTextStyle.bodyMedium,
//                     ),
//                     // HorizontalSpacing.d5px(),
//                     // const Icon(
//                     //   FontAwesomeIcons.solidCircleCheck,
//                     //   size: 12,
//                     //   color: AppColor.primary,
//                     // )
//                   ],
//                 ),
//                 VerticalSpacing.d2px(),
//                 Text(
//                   '1-3 Business Days',
//                   style: AppTextStyle.bodySmall.copyWith(color: Colors.black54, fontSize: 11),
//                 ),
//               ],
//             ),
//             const Spacer(),
//             const Icon(Icons.info_outline, size: 16, color: Colors.black45),
//             HorizontalSpacing.d10px(),
//           ],
//         ),
//       ),
//       const Divider(thickness: 0.4, color: AppColor.divider, height: 0),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//         child: Row(
//           children: [
//             const Icon(
//               FontAwesomeIcons.moneyCheck,
//               color: AppColor.black20,
//               size: 15,
//             ),
//             HorizontalSpacing.d20px(),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Bank Wire',
//                   style: AppTextStyle.bodyMedium,
//                 ),
//                 VerticalSpacing.d2px(),
//                 Text(
//                   '1-3 Business Days',
//                   style: AppTextStyle.bodySmall.copyWith(color: Colors.black54, fontSize: 11),
//                 ),
//               ],
//             ),
//             const Spacer(),
//             const Icon(
//               Icons.info_outline,
//               size: 16,
//               color: Colors.black45,
//             ),
//             HorizontalSpacing.d10px(),
//           ],
//         ),
//       ),
//       const Divider(thickness: 0.4, color: AppColor.divider, height: 0),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//         child: Row(
//           children: [
//             const Icon(
//               Icons.payments,
//               color: AppColor.black20,
//               size: 15,
//             ),
//             HorizontalSpacing.d20px(),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Others',
//                   style: AppTextStyle.bodyMedium,
//                 ),
//                 VerticalSpacing.d2px(),
//                 Text(
//                   'More Payment Methods',
//                   style: AppTextStyle.bodySmall.copyWith(color: Colors.black54, fontSize: 11),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       VerticalSpacing.d5px(),
//     ],
//   ),
// ),

// if (hasMore) AppStyle.dottedDivider,
              // if (hasMore)
              //   Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              //     child: Row(children: [
              //       const Icon(
              //         FontAwesomeIcons.solidCreditCard,
              //         color: AppColor.primary,
              //         size: 15,
              //       ),
              //       HorizontalSpacing.d20px(),
              //       Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //         const Text(
              //           'Others',
              //           style: AppTextStyle.bodyMedium,
              //         ),
              //         VerticalSpacing.d2px(),
              //         Text(
              //           'More Payment methods',
              //           style: AppTextStyle.bodySmall.copyWith(color: Colors.black54, fontSize: 11),
              //         )
              //       ]),
              //       const Spacer(),
              //       const Icon(Icons.info_outline, size: 18, color: Colors.black45),
              //       HorizontalSpacing.d10px(),
              //     ]),
              //   ),