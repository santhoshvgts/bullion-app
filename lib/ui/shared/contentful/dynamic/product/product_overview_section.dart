import 'package:bullion/core/constants/display_type.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/models/module/product_detail/product_price.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/shared/contentful/dynamic/product/product_detail_view_model.dart';
import 'package:bullion/ui/shared/web_view/apmex_web_view.dart';
import 'package:bullion/ui/view/product/detail/product_specification_page.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/chip_item.dart';
import 'package:bullion/ui/widgets/network_image_loader.dart';
import 'package:bullion/ui/widgets/shimmer_effect.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:stacked/stacked.dart';

import '../../../../widgets/image_pagination_builder.dart';

class ProductOverviewSection extends VGTSBuilderWidget<ProductDetailViewModel> {
  final ProductDetails? setting;
  final String? slug;

  const ProductOverviewSection(this.setting, this.slug, {super.key});

  @override
  void onViewModelReady(ProductDetailViewModel viewModel) {
    viewModel.init(setting, slug: slug);
    super.onViewModelReady(viewModel);
  }

  @override
  ProductDetailViewModel viewModelBuilder(BuildContext context) =>
      ProductDetailViewModel();

  @override
  Widget viewBuilder(
    BuildContext context,
    AppLocalizations locale,
    ProductDetailViewModel viewModel,
    Widget? child,
  ) {
    return Container(
      color: AppColor.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Stack(
              children: [
                _ImageList(
                  viewModel.productDetails?.productPictures ??
                      [viewModel.productDetails!.overview!.primaryImageUrl!],
                ),
                if (viewModel
                        .productDetails?.overview?.ribbonText?.isNotEmpty ==
                    true)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: viewModel.productDetails!.overview!
                            .ribbonTextBackgroundColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Text(
                        viewModel.productDetails!.overview!.ribbonText!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColor.white,
                        ),
                        textScaleFactor: 1,
                      ),
                    ),
                  ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: AppColor.outlineBorder,
                              width: 0.5,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            CupertinoIcons.heart,
                            size: 20,
                            color: AppColor.outlineBorder,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 60,
                  right: 10,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: AppColor.outlineBorder,
                              width: 0.5,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            CupertinoIcons.bell,
                            size: 20,
                            color: AppColor.outlineBorder,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          VerticalSpacing.d5px(),
          _ProductInfoSection(),
          if (viewModel.productDetails!.productNotes != null) _ProductNotes(),
          if (viewModel.productDetails!.volumePricing == null)
            _VolumePriceLoading()
          else if (viewModel.productDetails!.volumePricing!.isEmpty)
            Container()
          else
            _VolumePricing(),
          if (viewModel.productDetails!.coinGradeSpecification.isNotEmpty)
            _CoinGradeSpecification(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Button(
              "Add To Cart",
              width: double.infinity,
              valueKey: const ValueKey("btnAddToCart"),
              color: AppColor.secondary,
              borderColor: AppColor.secondary,
              onPressed: () {
                viewModel.addToCart();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends ViewModelWidget<ProductDetailViewModel> {
  @override
  Widget build(BuildContext context, ProductDetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
      color: AppColor.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            viewModel.productDetails?.overview?.name ?? "-",
            style: AppTextStyle.titleMedium,
            textScaleFactor: 1,
          ),
          VerticalSpacing.d10px(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RatingBar(
                initialRating:
                    viewModel.productDetails?.overview?.avgRatings ?? 0,
                allowHalfRating: true,
                itemSize: 15,
                glow: true,
                glowColor: Colors.red,
                maxRating: 5,
                unratedColor: AppColor.disabled,
                ratingWidget: RatingWidget(
                  full: const Icon(
                    CupertinoIcons.star_fill,
                    color: AppColor.primary,
                  ),
                  half: const Icon(
                    CupertinoIcons.star_lefthalf_fill,
                    color: AppColor.primary,
                  ),
                  empty: const Icon(
                    CupertinoIcons.star,
                    color: AppColor.primary,
                  ),
                ),
                onRatingUpdate: (double value) {},
              ),
              HorizontalSpacing.d5px(),
              Expanded(
                  child: Text(
                viewModel.productDetails!.overview!.reviewCount == 0
                    ? ""
                    : "${viewModel.productDetails?.overview?.avgRatings} (${viewModel.productDetails!.overview!.reviewCount})",
                textScaleFactor: 1,
                textAlign: TextAlign.left,
                style: AppTextStyle.bodySmall,
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImageList extends ViewModelWidget<ProductDetailViewModel> {
  final List<String>? images;

  const _ImageList(this.images);

  @override
  Widget build(BuildContext context, ProductDetailViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColor.border,
              style: BorderStyle.solid,
              width: 0.5,
            ),
          ),
          child: Stack(
            children: [
              Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => ProductImagesFullViewPage(images, index)));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: NetworkImageLoader(
                        image: images![index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
                onIndexChanged: (index) {
                  viewModel.activeIndex = index;
                },
                itemCount: images!.length,
                loop: false,
                layout: SwiperLayout.DEFAULT,
                // pagination: const SwiperPagination(
                //   alignment: Alignment.bottomCenter,
                //   builder: DotSwiperPaginationBuilder(
                //     activeSize: 7,
                //     size: 7,
                //     space: 2,
                //     activeColor: AppColor.primary,
                //     color: AppColor.shadowColor,
                //   ),
                // ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: InkWell(
                  onTap: () {
                    locator<NavigationService>()
                        .pushNamed(Routes.threeSixtyPage);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: AppColor.outlineBorder,
                        width: 0.5,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      Images.threeSixtyDegree,
                      width: 25,
                      height: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        VerticalSpacing.d10px(),
        ImagePaginationBuilder(
          activeBorderColor: AppColor.primary,
          activeSize: 40,
          size: 40,
          images: images,
          activeIndex: viewModel.activeIndex,
        )
      ],
    );
  }
}

class _ProductInfoSection extends ViewModelWidget<ProductDetailViewModel> {
  @override
  Widget build(BuildContext context, ProductDetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      color: AppColor.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (viewModel.productDetails!.overview!.productAction ==
              ProductInfoDisplayType.addToCart)
            _PriceInfo()
          else
            _AlertText(),
          VerticalSpacing.d20px(),
          _ShippingInfoCard(),
          VerticalSpacing.d10px(),
          _VariationSelection(),
        ],
      ),
    );
  }
}

class _ProductNotes extends ViewModelWidget<ProductDetailViewModel> {
  @override
  Widget build(BuildContext context, ProductDetailViewModel viewModel) {
    return Container(
      color: AppColor.white,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      margin: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: viewModel.productDetails!.productNotes!.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              e,
              style: AppTextStyle.bodyMedium.copyWith(
                fontSize: 14,
              ),
              textAlign: TextAlign.start,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _VolumePriceLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerEffect(
            height: 20,
            width: 170,
            color: AppColor.secondaryBackground,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
          ),
          ShimmerEffect(
            height: 20,
            color: AppColor.secondaryBackground,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
          ),
          ShimmerEffect(
            height: 20,
            color: AppColor.secondaryBackground,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
          ),
          ShimmerEffect(
            height: 20,
            color: AppColor.secondaryBackground,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
          ),
          ShimmerEffect(
            height: 20,
            color: AppColor.secondaryBackground,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
          ),
        ],
      ),
    );
  }
}

class _VolumePricing extends ViewModelWidget<ProductDetailViewModel> {
  @override
  Widget build(BuildContext context, ProductDetailViewModel viewModel) {
    return Container(
        color: AppColor.white,
        margin: const EdgeInsets.only(
          top: 10.0,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Volume Discount Pricing",
                    textScaleFactor: 1,
                    style: AppTextStyle.titleMedium,
                  ),
                  HorizontalSpacing.d5px(),
                  InkWell(
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.only(top: 3.0),
                      child: Icon(
                        Icons.info_outline,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Wrap(
                  spacing: 7,
                  children: [
                    ...viewModel.productDetails?.volumePricing?.first
                            ?.productPricesByPaymentType
                            ?.map((e) {
                          return ChipItem(
                            text: e.name ?? '-',
                            onTap: () {
                              viewModel.selectedPaymentType = e;
                            },
                            isSelected: viewModel.selectedPaymentType == e,
                          );
                        }).toList() ??
                        []
                  ],
                ),
              ),
            ),

            Container(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...viewModel.productDetails?.volumePricing
                            ?.map((volumePricing) {
                          ProductPricesByPaymentType? pricing = volumePricing
                              ?.productPricesByPaymentType
                              ?.firstWhere((element) =>
                                  element.name ==
                                  viewModel.selectedPaymentType?.name);

                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: _VolumeDiscountCard(
                              title: volumePricing?.tier ?? '-',
                              price: pricing?.formattedPrice ?? "-",
                              strikeThrough: viewModel
                                  .selectedVolumePricing!.strikeThroughEnabled!,
                              selected: viewModel.selectedVolumePricing ==
                                  volumePricing,
                              onTap: () {
                                viewModel.selectedVolumePricing = volumePricing;
                              },
                            ),
                          );
                        }).toList() ??
                        []
                  ],
                ),
              ),
            ),

            // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            //   width: double.infinity,
            //   height: 100,
            //   child: ListView.separated(
            //     primary: false,
            //     shrinkWrap: true,
            //     itemCount: viewModel.productDetails?.volumePricing?.length ?? 0,
            //     padding: const EdgeInsets.symmetric(vertical: 10),
            //     scrollDirection: Axis.horizontal,
            //     separatorBuilder: (context, index) {
            //       return Container();
            //     },
            //     itemBuilder: (context, index) {
            //       VolumePricing? volumePricing =
            //           viewModel.productDetails?.volumePricing?[index];
            //
            //       ProductPricesByPaymentType? pricing = volumePricing
            //           ?.productPricesByPaymentType
            //           ?.firstWhere((element) =>
            //               element.name == viewModel.selectedPaymentType?.name);
            //
            //       return _VolumeDiscountCard(
            //         title: volumePricing?.tier ?? '-',
            //         price: pricing?.formattedPrice ?? "-",
            //         strikeThrough:
            //             viewModel.selectedVolumePricing!.strikeThroughEnabled!,
            //       );
            //     },
            //   ),
            // ),
          ],
        ));
  }
}

class _VolumeDiscountCard extends StatelessWidget {
  String title;
  String price;
  String? offerText;
  bool strikeThrough;

  bool selected;
  Function onTap;

  _VolumeDiscountCard({
    required this.title,
    required this.price,
    required this.strikeThrough,
    required this.onTap,
    this.offerText,
    this.selected = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: AppColor.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: AppColor.primary,
          ),
        ),
        width: MediaQuery.of(context).size.width / 3.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Qty",
              style: AppTextStyle.bodySmall.copyWith(
                  decoration:
                      strikeThrough ? TextDecoration.lineThrough : null),
            ),

            Text(
              title,
              style: AppTextStyle.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  decoration:
                      strikeThrough ? TextDecoration.lineThrough : null),
            ),
            VerticalSpacing.d5px(),
            Text(
              price,
              style: AppTextStyle.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                  decoration:
                      strikeThrough ? TextDecoration.lineThrough : null),
              textAlign: TextAlign.center,
            ),
            // if (offerText?.isNotEmpty == true) Text(offerText!),
          ],
        ),
      ),
    );
  }
}

// BK - Payment Top and Qty Second
// class _VolumePricing extends ViewModelWidget<ProductDetailViewModel> {
//   @override
//   Widget build(BuildContext context, ProductDetailViewModel viewModel) {
//     return Container(
//         color: AppColor.white,
//         margin: const EdgeInsets.only(
//           top: 10.0,
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Volume Discount Pricing",
//                     textScaleFactor: 1,
//                     style: AppTextStyle.titleLarge
//                   ),
//                   HorizontalSpacing.d5px(),
//                   InkWell(
//                       onTap: () {},
//                       child: const Padding(
//                         padding: EdgeInsets.only(top: 3.0),
//                         child: Icon(
//                           Icons.info_outline,
//                           size: 20,
//                         ),
//                       ))
//                 ],
//               ),
//             ),
//             SizedBox(
//               width: double.infinity,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: Wrap(
//                   spacing: 7,
//                   children: [
//                     ...viewModel.productDetails?.volumePricing?.firstOrNull
//                             ?.productPricesByPaymentType
//                             ?.map((e) {
//                           return ChipItem(
//                             text: e.name ?? '-',
//                             onTap: () {
//                               viewModel.selectedPaymentType = e;
//                             },
//                             isSelected: viewModel.selectedPaymentType == e,
//                           );
//                         }).toList() ??
//                         []
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 color: AppColor.primary.withOpacity(0.05),
//                 borderRadius: BorderRadius.circular(5),
//                 border: Border.all(color: AppColor.primary),
//               ),
//               margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//               width: double.infinity,
//               child: ListView.separated(
//                 primary: false,
//                 shrinkWrap: true,
//                 itemCount: viewModel.productDetails?.volumePricing?.length ?? 0,
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 separatorBuilder: (context, index) {
//                   return AppStyle.customDivider;
//                 },
//                 itemBuilder: (context, index) {
//                   VolumePricing pricing =
//                       viewModel.productDetails!.volumePricing![index];
//
//                   String price = pricing.productPricesByPaymentType
//                           ?.firstWhere((element) =>
//                               element.name ==
//                               viewModel.selectedPaymentType?.name)
//                           ?.formattedPrice ??
//                       '-';
//
//                   return _VolumeDiscountCard(
//                     title: pricing.tier ?? '-',
//                     price: price,
//                     strikeThrough: pricing.strikeThroughEnabled!,
//                   );
//                 },
//               ),
//             ),
//           ],
//         ));
//   }
// }

// class _VolumeDiscountCard extends StatelessWidget {
//   String title;
//   String price;
//   String? offerText;
//   bool strikeThrough;
//
//   _VolumeDiscountCard({
//     required this.title,
//     required this.price,
//     required this.strikeThrough,
//     this.offerText,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       width: double.infinity,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: AppTextStyle.titleMedium.copyWith(
//                 fontWeight: FontWeight.w500,
//                 decoration: strikeThrough ? TextDecoration.lineThrough : null),
//           ),
//           VerticalSpacing.d5px(),
//           Text(
//             price,
//             style: AppTextStyle.titleMedium.copyWith(
//                 fontWeight: FontWeight.w500,
//                 decoration: strikeThrough ? TextDecoration.lineThrough : null),
//             textAlign: TextAlign.center,
//           ),
//           // if (offerText?.isNotEmpty == true) Text(offerText!),
//         ],
//       ),
//     );
//   }
// }

class _CoinGradeSpecification extends ViewModelWidget<ProductDetailViewModel> {
  @override
  Widget build(BuildContext context, ProductDetailViewModel viewModel) {
    if (viewModel.productDetails?.coinGradeSpecification.isEmpty != false) {
      return Container();
    }

    return Container(
        color: AppColor.primary,
        margin: const EdgeInsets.only(
          top: 10.0,
        ),
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColor.white,
          ),
          child: Column(
            children: [
              Container(
                color: AppColor.primaryDark,
                width: double.infinity,
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: NetworkImageLoader(
                          image: viewModel
                              .productDetails!.coinHeaderSpecification!.value,
                          height: 18,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: () {
                          ApmexWebView.open(
                              viewModel.productDetails!.coinHeaderSpecification!
                                  .keyHelpText,
                              title: "Coin Grade");
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.info_outline,
                            size: 20,
                            color: AppColor.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                itemCount:
                    viewModel.productDetails!.coinGradeSpecification.length,
                separatorBuilder: (BuildContext context, index) {
                  return AppStyle.customDivider;
                },
                itemBuilder: (BuildContext context, index) {
                  return SpecificationItem(
                    viewModel.productDetails!.coinGradeSpecification[index],
                  );
                },
              ),
              VerticalSpacing.d5px(),
              InkWell(
                onTap: () {
                  ApmexWebView.open(
                      viewModel.productDetails!.coinFooterSpecification!.value);
                },
                child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Information Provided By ",
                          textScaleFactor: 1,
                          style: AppTextStyle.bodyMedium,
                        ),
                        NetworkImageLoader(
                          image: viewModel.productDetails!
                              .coinFooterSpecification!.keyHelpText,
                          height: 18,
                          fit: BoxFit.fitHeight,
                        ),
                      ],
                    )),
              ),
              VerticalSpacing.d5px(),
            ],
          ),
        ));
  }
}

class _AlertText extends ViewModelWidget<ProductDetailViewModel> {
  @override
  Widget build(BuildContext context, ProductDetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        viewModel.productDetails!.overview!.availabilityText!,
        style: AppTextStyle.titleLarge.copyWith(color: AppColor.red),
      ),
    );
  }
}

class _ShippingInfoCard extends ViewModelWidget<ProductDetailViewModel> {
  @override
  Widget build(BuildContext context, ProductDetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xffFAF3DD)),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Quick Shipping",
                style: AppTextStyle.bodyMedium
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              HorizontalSpacing.d5px(),
              const Icon(
                CupertinoIcons.info,
                size: 16,
              ),
            ],
          ),
          VerticalSpacing.d2px(),
          const Text("Ships in 6 business days from receipt",
              style: AppTextStyle.bodyMedium),
        ],
      ),
    );
  }
}

class _VariationSelection extends ViewModelWidget<ProductDetailViewModel> {
  @override
  Widget build(BuildContext context, ProductDetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Weight",
            style:
                AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w500),
          ),
          VerticalSpacing.d10px(),
          Wrap(
            spacing: 5,
            children: [
              ...["1 oz", "1/2 oz", "1/4 oz", "1/10 oz"]
                  .map((e) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: e == "1 oz"
                                  ? AppColor.primary
                                  : AppColor.border,
                            )),
                        child: Text(
                          e,
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.text,
                          ),
                        ),
                      ))
                  .toList()
            ],
          ),
          VerticalSpacing.d15px(),
          Text(
            "Year",
            style:
                AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w500),
          ),
          VerticalSpacing.d10px(),
          Wrap(
            spacing: 5,
            children: [
              ...["Random", "2023"]
                  .map((e) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: e == "Random"
                                  ? AppColor.primary
                                  : AppColor.border,
                            )),
                        child: Text(
                          e,
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.text,
                          ),
                        ),
                      ))
                  .toList()
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceInfo extends ViewModelWidget<ProductDetailViewModel> {
  @override
  Widget build(BuildContext context, ProductDetailViewModel viewModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 2.0),
                  child: RichText(
                    textScaleFactor: 1,
                    textAlign: TextAlign.left,
                    text: TextSpan(
                        text:
                            "${viewModel.productOverview!.pricing!.formattedNewPrice} ",
                        style: AppTextStyle.titleLarge.copyWith(
                            fontSize: 20,
                            color: viewModel.productOverview!.pricing!
                                    .strikeThroughEnabled!
                                ? const Color(0xffC30000)
                                : AppColor.primaryDark),
                        children: <TextSpan>[
                          if (viewModel
                              .productOverview!.pricing!.strikeThroughEnabled!)
                            TextSpan(
                                text: viewModel.productOverview!.pricing!
                                    .formattedOldPrice,
                                style: AppTextStyle.titleLarge.copyWith(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20,
                                    color: const Color(0xff666666),
                                    decoration: TextDecoration.lineThrough))
                        ]),
                  )),

              if (viewModel.productDetails?.priceBadgeText?.isNotEmpty == true)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    viewModel.productDetails?.priceBadgeText ?? '',
                    textAlign: TextAlign.left,
                    style: AppTextStyle.bodyMedium.copyWith(fontSize: 14),
                  ),
                ),

              if (viewModel.productOverview?.pricing?.strikeThroughEnabled ==
                  true)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                      viewModel.productOverview!.pricing!.discountText ?? '',
                      textAlign: TextAlign.left,
                      style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColor.offerText,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                ),

              // VerticalSpacing.d15px(),
            ],
          ),
        ),
        Button(
          "Add To Cart",
          width: 140,
          valueKey: const ValueKey("btnAddToCart"),
          color: AppColor.secondary,
          borderColor: AppColor.secondary,
          onPressed: () {
            viewModel.addToCart();
          },
        )
      ],
    );
  }
}

class AlertToast extends StatelessWidget {
  final ProductDetails? productDetails;
  final String title;
  final Color titleColor;
  final Function? onViewAllTap;
  final bool? showView;

  const AlertToast(
      this.productDetails, this.title, this.titleColor, this.onViewAllTap,
      {this.showView = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 65),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
      height: 60,
      decoration: BoxDecoration(
          color: AppColor.secondaryBackground,
          boxShadow: AppStyle.cardShadow,
          border: Border.all(color: titleColor),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 30,
            color: titleColor,
          ),

          // CircleAvatar(
          //     backgroundColor: Colors.transparent,
          //     child: ClipOval(child: NetworkImageLoader(image: productDetails.overview.primaryImageUrl))),

          HorizontalSpacing.d10px(),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  textScaleFactor: 1,
                  style: AppTextStyle.bodyMedium
                      .copyWith(color: titleColor, fontWeight: FontWeight.bold),
                ),
                VerticalSpacing.d2px(),
                Text(
                  productDetails!.overview!.name!,
                  textScaleFactor: 1,
                  style: AppTextStyle.bodyMedium.copyWith(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          if (showView!)
            InkWell(
              onTap: onViewAllTap as void Function()?,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "View",
                  textScaleFactor: 1,
                  style: AppTextStyle.bodyMedium
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            )
        ],
      ),
    );
  }
}
