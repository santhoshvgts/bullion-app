// import 'dart:io';
//
// import 'package:bullion/core/res/colors.dart';
//
// import 'package:bullion/core/res/styles.dart';
//
// import 'package:bullion/ui/view/checkout_bk/checkout_view_model.dart';
// import 'package:bullion/ui/view/checkout_bk/widgets/ck_address.dart';
// import 'package:bullion/ui/view/checkout_bk/widgets/ck_notes.dart';
// import 'package:bullion/ui/view/checkout_bk/widgets/ck_order_summary.dart';
// import 'package:bullion/ui/view/checkout_bk/widgets/ck_payment.dart';
// import 'package:bullion/ui/view/checkout_bk/widgets/ck_place_order_button.dart';
// import 'package:bullion/ui/view/checkout_bk/widgets/ck_timer.dart';
// import 'package:bullion/ui/view/vgts_builder_widget.dart';
// import 'package:bullion/ui/widgets/loading_data.dart';
// import 'package:flutter/material.dart';
//
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// class CheckoutPage extends VGTSBuilderWidget<CheckoutPageViewModel> {
//   const CheckoutPage({super.key});
//
//   @override
//   Widget viewBuilder(BuildContext context, AppLocalizations locale, CheckoutPageViewModel viewModel, Widget? child) {
//     return Scaffold(
//         backgroundColor: AppColor.secondaryBackground,
//         //
//         //
//         appBar: AppBar(
//           shadowColor: Colors.black54,
//           centerTitle: false,
//           actions: const [CkTimer()],
//           title: Text(
//             'Confirm your Order',
//             style: AppTextStyle.titleMedium.copyWith(color: AppColor.headerBlack),
//           ),
//         ),
//         //
//
//         //
//         body: SingleChildScrollView(
//             physics: const ScrollPhysics(parent: ClampingScrollPhysics()),
//             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               //viewModel.isBusy ? ,
//              viewModel.isBusy
//                       ? LoadingData(
//                     loadingStyle: LoadingStyle.LOGO,
//                   )
//                   :
//
//                     const Column(
//                       children: [
//                         CkAddress(),
//                        CkPayment(),
//                       // CkShippingOption(),
//                         CkOrderSummary(),
//                         CkNotes(),
//                       ],
//                     ),
//             ])),
//
//
//         //
//         //
//         bottomNavigationBar: viewModel.isBusy
//             ? const SizedBox()
//             : Container(
//                 padding:  EdgeInsets.only(top: 20, left: 15, right: 15,bottom: Platform.isAndroid ? 15 : 0),
//                 width: double.infinity,
//                 decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 8)]),
//                 child: SafeArea(
//                   child: Wrap(
//                     children: [
//                       Padding(
//                           padding: const EdgeInsets.only(bottom: 15),
//                           child: Center(
//                               child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Text(
//                                 'By Placing an Order, I agree to ',
//                                 style: AppTextStyle.labelSmall,
//                               ),
//                               Text(
//                                 'terms and cancellation policy ',
//                                 style: AppTextStyle.labelSmall.copyWith(color: AppColor.primary, decoration: TextDecoration.underline),
//                               ),
//                             ],
//                           ))),
//                       const CkPlaceOrderButton(),
//                     ],
//                   ),
//                 ),
//               ));
//   }
//
//   @override
//   CheckoutPageViewModel viewModelBuilder(BuildContext context) {
//     return CheckoutPageViewModel();
//   }
// }
//
//
//
// // Padding(
// //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
// // child: Column(
// //   crossAxisAlignment: CrossAxisAlignment.start,
// //   children: [
// //     Row(
// //       children: [
// //         const Icon(
// //           FontAwesomeIcons.solidCreditCard,
// //           color: AppColor.primary,
// //           size: 15,
// //         ),
// //         HorizontalSpacing.d15px(),
// //         const Text(
// //           'Debit/Credit Cards',
// //           style: AppTextStyle.bodyMedium,
// //         ),
// //         const Spacer(),
// //         const Icon(
// //           Icons.keyboard_arrow_down_rounded,
// //           size: 19,
// //         )
// //       ],
// //     ),
// //     Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 20),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           VerticalSpacing.d15px(),
// //           Text(
// //             'XXXX XXXX XXXX 9089',
// //             style: AppTextStyle.bodySmall.copyWith(color: Colors.black45),
// //           ),
// //           VerticalSpacing.d15px(),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.start,
// //             children: [
// //               const Icon(Icons.add_card_outlined, color: AppColor.green, size: 15),
// //               HorizontalSpacing.d5px(),
// //               const Text(
// //                 'Add new card',
// //                 style: AppTextStyle.bodySmall,
// //               ),
// //             ],
// //           )
// //         ],
// //       ),
// //     )
// //   ],
// // ),
// // ),
// //  const Divider(thickness: 0.8, color: AppColor.divider, height: 0),
//
// //////? // Padding(
// //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
// //   child: Row(
// //     children: [
// //       const Icon(
// //         FontAwesomeIcons.moneyCheckDollar,
// //         color: AppColor.primary,
// //         size: 15,
// //       ),
// //       HorizontalSpacing.d15px(),
// //       Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Text(
// //             'Crytocurrency via Bitpay',
// //             style: AppTextStyle.bodyMedium,
// //           ),
// //           VerticalSpacing.d2px(),
// //           Text(
// //             'Up to 5 Business Days',
// //             style: AppTextStyle.bodySmall.copyWith(color: Colors.black54, fontSize: 11),
// //           ),
// //         ],
// //       ),
// //       const Spacer(),
// //       const Icon(
// //         Icons.keyboard_arrow_down_rounded,
// //         size: 19,
// //       )
// //     ],
// //   ),
// // ),
// // const Divider(thickness: 0.4, color: AppColor.divider, height: 0),
// // Padding(
// //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
// //   child: Row(
// //     children: [
// //       const Icon(
// //         FontAwesomeIcons.bitcoin,
// //         color: AppColor.primary,
// //         size: 15,
// //       ),
// //       HorizontalSpacing.d15px(),
// //       Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Text(
// //             'Crytocurrency via Bitpay',
// //             style: AppTextStyle.bodyMedium,
// //           ),
// //           VerticalSpacing.d2px(),
// //           Text(
// //             'Up to 5 Business Days',
// //             style: AppTextStyle.bodySmall.copyWith(color: Colors.black54, fontSize: 11),
// //           ),
// //         ],
// //       ),
// //       const Spacer(),
// //       const Icon(
// //         Icons.keyboard_arrow_down_rounded,
// //         size: 19,
// //       )
// //     ],
// //   ),
// // ),
//
// /////// ?
// // Row(
// //   crossAxisAlignment: CrossAxisAlignment.center,
// //   children: [
// //     Radio(
// //       value: true,
// //       activeColor: AppColor.primary,
// //       fillColor: MaterialStatePropertyAll(AppColor.primary),
// //       groupValue: false,
// //       onChanged: (value) {},
// //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
// //     ),
// //     Expanded(
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Text('Standard Delivery', style: AppTextStyle.bodyMedium),
// //           VerticalSpacing.d5px(),
// //           Text(
// //             'Expeted to delivery within 18,Fri',
// //             style: AppTextStyle.bodySmall.copyWith(fontSize: 10),
// //             maxLines: 1,
// //           ),
// //         ],
// //       ),
// //     ),
// //     const Spacer(),
// //     const Text('\$2.90', style: AppTextStyle.titleSmall),
// //     HorizontalSpacing.d15px(),
// //   ],
// // ),
//
// // Padding(
// //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
// //   child: Column(
// //     crossAxisAlignment: CrossAxisAlignment.start,
// //     children: [
// //       Row(
// //         children: [
// //           const Icon(
// //             FontAwesomeIcons.solidCreditCard,
// //             color: AppColor.primary,
// //             size: 15,
// //           ),
// //           HorizontalSpacing.d15px(),
// //           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// //             Row(
// //               children: [
// //                 const Text(
// //                   'Credit/Debit Cards',
// //                   style: AppTextStyle.bodyMedium,
// //                 ),
// //                 HorizontalSpacing.d5px(),
// //                 const Icon(
// //                   FontAwesomeIcons.solidCircleCheck,
// //                   size: 12,
// //                   color: AppColor.primary,
// //                 )
// //               ],
// //             ),
// //             VerticalSpacing.d2px(),
// //             Text(
// //               '1-3 Business Days',
// //               style: AppTextStyle.bodySmall.copyWith(color: Colors.black54, fontSize: 11),
// //             )
// //           ]),
// //           const Spacer(),
// //           const Icon(Icons.info_outline, size: 16, color: Colors.black45),
// //           HorizontalSpacing.d10px(),
// //         ],
// //       ),
// //       Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 30),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             VerticalSpacing.d15px(),
//
// //             Text(
// //               'XXXX XXXX XXXX 8564',
// //               style: AppTextStyle.bodySmall.copyWith(color: AppColor.primary),
// //             ),
// //             VerticalSpacing.d15px(),
// //             Text(
// //               'Others',
// //               style: AppTextStyle.bodySmall.copyWith(color: Colors.black54),
// //             ),
// //             VerticalSpacing.d15px(),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.start,
// //               children: [
// //                 const Icon(Icons.add_card_outlined, color: AppColor.green, size: 15),
// //                 HorizontalSpacing.d5px(),
// //                 const Text(
// //                   'Add new card',
// //                   style: AppTextStyle.bodySmall,
// //                 ),
// //               ],
// //             )
// //           ],
// //         ),
// //       )
// //     ],
// //   ),
// // ),
//
// // Padding(
// //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
// //   child: Row(
// //     children: [
// //       const Icon(
// //         FontAwesomeIcons.wallet,
// //         color: AppColor.primary,
// //         size: 15,
// //       ),
// //       HorizontalSpacing.d20px(),
// //       Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Text(
// //             'Bank Wire',
// //             style: AppTextStyle.bodyMedium,
// //           ),
// //           VerticalSpacing.d2px(),
// //           Text(
// //             '1-3 Business Days',
// //             style: AppTextStyle.bodySmall.copyWith(color: Colors.black54, fontSize: 11),
// //           ),
// //         ],
// //       ),
// //       const Spacer(),
// //       const Icon(Icons.info_outline, size: 16, color: Colors.black45),
// //       HorizontalSpacing.d10px(),
// //     ],
// //   ),
// // ),
