// import 'package:bullion/ui/shared/cart/inline_block_section.dart';
// import 'package:bullion/ui/shared/contentful/banner/banner_ui_container.dart';
// import 'package:bullion/ui/shared/contentful/product/product_module.dart';
// import 'package:bullion/ui/shared/contentful/standard/standard_module.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:bullion/core/constants/module_type.dart';
// import 'package:bullion/core/enums/viewstate.dart';
// import 'package:bullion/core/models/module/cart/cart_item.dart';
// import 'package:bullion/core/models/module/cart/display_message.dart';
// import 'package:bullion/core/models/module/cart/order_total_summary.dart';
// import 'package:bullion/core/models/module/checkout/payment_method.dart';
// import 'package:bullion/core/models/user_address.dart';
// import 'package:bullion/core/res/colors.dart';
// import 'package:bullion/core/res/images.dart';
// import 'package:bullion/core/res/spacing.dart';
// import 'package:bullion/core/res/styles.dart';
// import 'package:bullion/helper/utils.dart';
// import 'package:bullion/locator.dart';
// import 'package:bullion/router.dart';
// import 'package:bullion/services/shared/dialog_service.dart';
// import 'package:bullion/services/shared/navigation_service.dart';
// import 'package:bullion/ui/shared/loading_widget.dart';
// import 'package:bullion/ui/v2/shared/banner/banner_ui_container.dart';
// import 'package:bullion/ui/v2/shared/cart/cart_summary_help_text.dart';
// import 'package:bullion/ui/v2/shared/inline_block_section.dart';
// import 'package:bullion/ui/v2/shared/product/product_module.dart';
// import 'package:bullion/ui/v2/shared/standard/standard_module.dart';
// import 'package:bullion/ui/v2/shared/warning_card.dart';
// import 'package:bullion/ui/v2/views/checkout/delivery_address/delivery_address_view_model.dart';
// import 'package:bullion/ui/v2/views/checkout/payment_method/payment_method_view_model.dart';
// import 'package:bullion/ui/v2/views/checkout/review_order/review_order_view_model.dart';
// import 'package:bullion/ui/widgets/button.dart';
// import 'package:bullion/ui/widgets/network_image_loader.dart';
// import 'package:bullion/ui/widgets/shimmer_effect.dart';
// import 'package:stacked/stacked.dart';
//
// class ReviewOrderPage extends ViewModelBuilderWidget<ReviewOrderViewModel> {
//
//   bool? fromPriceExpiry = false;
//
//   ReviewOrderPage({this.fromPriceExpiry});
//
//   @override
//   ReviewOrderViewModel viewModelBuilder(BuildContext context) => ReviewOrderViewModel(fromPriceExpiry);
//
//   @override
//   void onViewModelReady(ReviewOrderViewModel viewModel) {
//     viewModel.init();
//   }
//
//   @override
//   Widget builder(BuildContext context, ReviewOrderViewModel viewModel, Widget? child)  {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar (
//           automaticallyImplyLeading: fromPriceExpiry! ? false : true,
//           title: Text(fromPriceExpiry! ? "Price Expired" : "Review Order", textScaleFactor: 1,),
//           actions: [
//
//             if (fromPriceExpiry!)
//               IconButton(icon: Icon(Icons.close), onPressed: (){
//                 locator<NavigationService>().popUntil(Routes.dashboard);
//               })
//
//           ],
//         ),
//         body: viewModel.cart == null ? LoadingWidget(allowPop: true,) : Container(
//           color: AppColor.secondaryBackground,
//           child: ListView(
//             children: [
//
//               if (fromPriceExpiry!)
//                 Container(
//                   color: AppColor.white,
//                   padding: EdgeInsets.all(15),
//                   child: Text(viewModel.shoppingCart!.expiredCartMessage!,
//                     textScaleFactor: 1,
//                     style: AppTextStyle.body,
//                   ),
//                 ),
//
//
//               viewModel.state == ViewState.Busy ?
//               SizedBox(
//                   height: 2,
//                   child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColor.primary),)
//               ) : Container(),
//
//               if(viewModel.shoppingCart!.errors != null)
//                 _ErrorNotes(),
//
//               if (viewModel.inlineMessage != null)
//                 InlineBlockSection(viewModel.inlineMessage),
//
//               VerticalSpacing.d10px(),
//
//               _ItemListSection(),
//
//               // VerticalSpacing.d10px(),
//
//               if (viewModel.shoppingCart!.warnings != null)
//                 ...viewModel.shoppingCart!.warnings!.map((warning) {
//                   return Container(
//                     padding: EdgeInsets.all(15),
//                     margin: EdgeInsets.only(top: 10),
//                     color: AppColor.white,
//                     child: Text(warning, textScaleFactor: 1, style: AppTextStyle.body.copyWith(color: AppColor.red),),
//                   );
//                 }).toList(),
//
//               if (viewModel.shoppingCart!.showPotentialSavings! && viewModel.totalItems! > 0) _PotentialSavings(),
//
//               if (viewModel.totalItems! > 0)
//                 _OrderSummary(),
//
//               if (viewModel.modules != null)
//                 ...viewModel.modules!.map((module){
//                   switch(module!.moduleType){
//
//                     case ModuleType.standard:
//                       return StandardModule(module);
//
//                     case ModuleType.product:
//                     case ModuleType.productList:
//                       return ProductModule(module,);
//
//                     case ModuleType.banner:
//                       return BannerModule(module);
//
//                     default:
//                       return Container();
//                   }
//
//                 }).toList(),
//
//             ],
//           ),
//         ),
//         bottomNavigationBar: fromPriceExpiry! && viewModel.state == ViewState.Idle ? SafeArea(
//           child: Container(
//             color: AppColor.white,
//             padding: EdgeInsets.all(15),
//             child: Button(
//               "Accept Updated Pricing",
//               color: AppColor.orange,
//               borderColor: AppColor.orange,
//               valueKey: Key("btnAccept"),
//               onPressed: (){
//                 locator<NavigationService>().pushReplacementNamed(Routes.checkout);
//               },
//             ),
//           ),
//         ) : null,
//       ),
//     );
//   }
//
// }
//
// class _ItemListSection extends ViewModelWidget<ReviewOrderViewModel> {
//
//   @override
//   Widget build(BuildContext context, ReviewOrderViewModel viewModel) {
//
//     if (viewModel.shoppingCart!.hasTaxableItems!){
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text("Non-Taxable Products", textScaleFactor: 1, style: AppTextStyle.subtitle,),
//           ),
//
//           ListView.separated(
//             itemCount: viewModel.nonTaxCartItems.length,
//             shrinkWrap: true,
//             primary: false,
//             separatorBuilder: (context, index) {
//               return Container(height: 1, child: AppStyle.customDivider);
//             },
//             itemBuilder: (context, index) {
//               return _ItemCard(viewModel.nonTaxCartItems[index],);
//             },
//           ),
//
//           Container(color: AppColor.white, child: AppStyle.customDivider),
//
//           Container(
//             color: AppColor.white,
//             padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 15),
//             child: Row(
//               children: [
//
//                 Expanded(child: Text("Non-Taxable Subtotal", textScaleFactor: 1, style: AppTextStyle.subtitle,)),
//
//                 Text(viewModel.shoppingCart!.formattedNonTaxableSubTotal!, textScaleFactor: 1, style: AppTextStyle.subtitle,),
//
//               ],
//             ),
//           ),
//
//           VerticalSpacing.d10px(),
//
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text("Taxable Products", textScaleFactor: 1, style: AppTextStyle.subtitle,),
//           ),
//
//           ListView.separated(
//             itemCount: viewModel.taxCartItems.length,
//             shrinkWrap: true,
//             primary: false,
//             separatorBuilder: (context, index) {
//               return Container(height: 1, child: AppStyle.customDivider);
//             },
//             itemBuilder: (context, index) {
//               return _ItemCard(viewModel.taxCartItems[index],);
//             },
//           ),
//
//           Container(color: AppColor.white, child: AppStyle.customDivider),
//
//           Container(
//             color: AppColor.white,
//             padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 15),
//             child: Row(
//               children: [
//
//                 Expanded(child: Text("Taxable Subtotal", textScaleFactor: 1, style: AppTextStyle.subtitle,)),
//
//                 Text(viewModel.shoppingCart!.formattedTaxableSubTotal!, textScaleFactor: 1, style: AppTextStyle.subtitle,),
//
//               ],
//             ),
//           ),
//
//           Container(
//             color: AppColor.white,
//             padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
//             child: Row(
//               children: [
//
//                 Expanded(child: Text("Tax", textScaleFactor: 1, style: AppTextStyle.subtitle,)),
//
//                 Text(viewModel.shoppingCart!.formattedTaxableItemsTax!, textScaleFactor: 1, style: AppTextStyle.subtitle,),
//
//               ],
//             ),
//           ),
//
//         ],
//       );
//     }
//
//     return Container(
//       color: AppColor.white,
//       child: ListView.separated(
//         itemCount: viewModel.cartItems!.length,
//         shrinkWrap: true,
//         primary: false,
//         separatorBuilder: (context, index) {
//           return Container(height: 1, child: AppStyle.customDivider);
//         },
//         itemBuilder: (context, index) {
//           return _ItemCard(viewModel.cartItems![index],);
//         },
//       ),
//     );
//   }
//
// }
//
//
// class _ItemCard extends StatelessWidget {
//
//   CartItem item;
//
//   _ItemCard(this.item);
//
//   @override
//   Widget build(BuildContext context) {
//     return  Container(
//       color: AppColor.white,
//       padding: EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               NetworkImageLoader(
//                 image: item.primaryImageUrl,
//                 fit: BoxFit.cover,
//                 width: 70,
//                 height: 70,
//               ),
//
//               HorizontalSpacing.d10px(),
//
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//
//                     Text(item.productName!,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       textScaleFactor: 1,
//                       style: AppTextStyle.subtitle,
//                     ),
//
//                     VerticalSpacing.d5px(),
//
//                     Row(
//                       children: [
//
//                         Text(item.formattedUnitPrice! + " x ${item.quantity}",
//                           style: AppTextStyle.title,
//                           textScaleFactor: 1,
//                         ),
//
//
//                         Expanded(
//                           child:  Text(item.formattedSubTotal!,
//                             style: AppTextStyle.title,
//                             textScaleFactor: 1,
//                             textAlign: TextAlign.end,
//                           ),
//                         )
//
//                       ],
//                     ),
//
//                   ],
//                 ),
//               ),
//
//
//             ],
//           ),
//
//           if (item.offers != null)
//             ...item.offers!.map((offer) {
//               return Padding(
//                 padding: EdgeInsets.only(top: 10),
//                 child: Text(offer, textScaleFactor: 1, style: AppTextStyle.body.copyWith(color: AppColor.green),),
//               );
//             }).toList(),
//
//           if (item.warnings != null)
//             ...item.warnings!.map((warning) {
//               return Padding(
//                 padding: EdgeInsets.only(top: 10),
//                 child: Text(warning, textScaleFactor: 1, style: AppTextStyle.body.copyWith(color: AppColor.red),),
//               );
//             }).toList(),
//
//         ],
//       ),
//     );
//   }
//
// }
//
//
//
// class _PotentialSavings extends ViewModelWidget<ReviewOrderViewModel> {
//
//   @override
//   Widget build(BuildContext context, ReviewOrderViewModel viewModel) {
//
//     return Container(
//       color: AppColor.background,
//       width: double.infinity,
//       margin: EdgeInsets.only(top: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           Padding(
//             padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
//             child: Text(
//               "Potential Savings",
//               textScaleFactor: 1,
//               style: AppTextStyle.title.copyWith(fontSize: 16),
//             ),
//           ),
//
//           Padding(
//             padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
//             child: Text(
//               viewModel.shoppingCart!.potentialSavings!,
//               style: AppTextStyle.body.copyWith(color: AppColor.primary),
//               textScaleFactor: 1,
//             ),
//           ),
//         ],
//       ),
//     );
//
//   }
// }
//
// class _OrderSummary extends ViewModelWidget<ReviewOrderViewModel> {
//
//   @override
//   Widget build(BuildContext context, ReviewOrderViewModel viewModel) {
//
//     return Container(
//       color: AppColor.background,
//       margin: EdgeInsets.only(top: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Text(
//               "Order Summary",
//               textScaleFactor: 1,
//               style: AppTextStyle.title.copyWith(fontSize: 17),
//             ),
//           ),
//
//           ListView.separated(
//               itemCount: viewModel.shoppingCart!.orderTotalSummary!.length,
//               primary: false,
//               shrinkWrap: true,
//               separatorBuilder: (context, index){
//                 return AppStyle.customDivider;
//               },
//               itemBuilder: (context, index) {
//
//                 OrderTotalSummary item = viewModel.shoppingCart!.orderTotalSummary![index];
//
//                 return Container(
//                   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//                   child: Row(
//                     children: [
//                       Text(item.key!, textScaleFactor: 1, style: AppTextStyle.body.copyWith(fontSize: 15)),
//
//                       HorizontalSpacing.d5px(),
//
//                       if (item.keyHelpText!.isNotEmpty)
//                         InkWell(
//                             onTap: () => locator<DialogService>().showBottomSheet(title: item.key, child: CartSummaryHelpText(item.keyHelpText)),
//                             child: Icon(
//                               Icons.error_outline,
//                               size: 18,
//                               color: AppColor.text,
//                             )
//                         ),
//
//                       Expanded(child: Container()),
//
//                       HorizontalSpacing.d15px(),
//
//                       Text(item.value!, style: AppTextStyle.body.copyWith(color: item.textColor, fontSize: 15))
//
//                     ],
//                   ),
//                 );
//
//               }
//           ),
//
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//             color: AppColor.white,
//             child: Row(
//               children: [
//                 Text("Total", textScaleFactor: 1, style: AppTextStyle.title.copyWith(fontSize: 17)),
//
//                 Expanded(child: Container()),
//
//                 Text(viewModel.shoppingCart!.formattedOrderTotal!, style: AppTextStyle.title.copyWith(fontSize: 17))
//
//               ],
//             ),
//           ),
//
//         ],
//       ),
//     );
//   }
//
// }
//
// class _ErrorNotes extends ViewModelWidget<ReviewOrderViewModel> {
//
//   @override
//   Widget build(BuildContext context, ReviewOrderViewModel viewModel) {
//
//     return Column(
//       children: viewModel.shoppingCart!.errors!.map((e) {
//         if (e == null)
//           return Container();
//
//         return WarningCard(e);
//       }).toList(),
//     );
//   }
//
// }
