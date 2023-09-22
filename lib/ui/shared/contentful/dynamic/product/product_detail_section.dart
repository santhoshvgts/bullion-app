// import 'package:bullion/core/models/module/product_detail/product_detail.dart';
// import 'package:bullion/core/res/colors.dart';
// import 'package:bullion/services/shared/navigator_service.dart';
// import 'package:bullion/ui/shared/contentful/dynamic/product/product_detail_view_model.dart';
// import 'package:bullion/ui/view/vgts_builder_widget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:spot/core/models/module/product_detail/product_detail.dart';
// import 'package:spot/core/res/colors.dart';
// import 'package:spot/core/res/spacing.dart';
// import 'package:spot/core/res/styles.dart';
// import 'package:spot/services/shared/navigation_service.dart';
// import 'package:spot/ui/v2/shared/dynamic/product/product_detail_view_model.dart';
// import 'package:spot/ui/widgets/rating_bar.dart';
// import 'package:stacked/stacked.dart';
// import '../../../../../locator.dart';
// import '../../../../../router.dart';
//
// class ProductDetailSection extends  VGTSBuilderWidget<ProductDetailViewModel> {
//
//   final ProductDetails? setting;
//
//   ProductDetailSection(this.setting);
//
//   @override
//   void onViewModelReady(ProductDetailViewModel vm) {
//     vm.init(setting);
//     super.onViewModelReady(vm);
//   }
//
//   @override
//   ProductDetailViewModel viewModelBuilder(BuildContext context) => ProductDetailViewModel();
//
//   @override
//   Widget viewBuilder(BuildContext context, AppLocalizations locale, ProductDetailViewModel viewModel, Widget? child) {
//     return Container(
//       color: AppColor.secondaryBackground,
//       child: Column(
//         children: [
//           _DetailItem(title: "Product Details", onTap:()=> locator<NavigationService>().pushNamed(Routes.productDesc(vm.productDetails!.productId),arguments: vm.productDetails!.description)),
//           _DetailItem(title: "Product Specification", onTap:()=>  locator<NavigationService>().pushNamed(Routes.productSpec(vm.productDetails!.productId),arguments: vm.productDetails!.specifications),),
//           _DetailItem(title: "Product Reviews", showRating: true, onTap:()=> locator<NavigationService>().pushNamed(Routes.productReview(vm.productDetails!.productId), arguments: vm.productDetails),),
//         ],
//       ),
//     );
//   }
// }
//
// class _DetailItem extends ViewModelWidget<ProductDetailViewModel> {
//
//   final String? title;
//   final bool showRating;
//   final Function? onTap;
//
//   _DetailItem({this.title,this.onTap, this.showRating = false});
//
//   @override
//   Widget build(BuildContext context, ProductDetailViewModel viewModel) {
//    return InkWell(
//      onTap: onTap as void Function()?,
//      child: Container(
//        color: AppColor.white,
//        margin: EdgeInsets.only(top: 10.0),
//        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title!,style: AppTextStyle.title.copyWith(fontSize: 17)),
//
//                   if (showRating)
//                     Container(
//                     margin: EdgeInsets.only(top: 5),
//                     child: Row(
//                       children: [
//                         RatingBar.readOnly(
//                           initialRating: viewModel.productDetails!.overview!.avgRatings!,
//                           isHalfAllowed: true,
//                           halfFilledIcon: Icons.star_half,
//                           filledIcon: Icons.star,
//                           emptyIcon: Icons.star_border,
//                           size: 15,
//                         ),
//
//                         HorizontalSpacing.d5px(),
//
//                         Expanded(
//                             child: Text("(${viewModel.productDetails!.overview!.reviewCount})", textScaleFactor: 1, textAlign: TextAlign.left, style: AppTextStyle.body,)
//                         ),
//                       ],
//                     ),
//                   ),
//
//                 ],
//               ),
//             ),
//             Icon(Icons.arrow_forward_ios,size:15,color: AppColor.primary,)
//           ],
//         ),
//       ),
//    );
//   }
//
// }
//
//
