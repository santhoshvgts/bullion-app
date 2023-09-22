import 'dart:ui';

import 'package:bullion/core/constants/display_type.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/shared/contentful/dynamic/product/product_detail_view_model.dart';
import 'package:bullion/ui/shared/web_view/apmex_web_view.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/network_image_loader.dart';
import 'package:bullion/ui/widgets/shimmer_effect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked/stacked.dart';

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
  ProductDetailViewModel viewModelBuilder(BuildContext context) => ProductDetailViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, ProductDetailViewModel viewModel, Widget? child) {
    return Container(
      color: AppColor.secondaryBackground,
      child: Column(
        children: [


          Stack(
            children: [

              if (viewModel.productDetails!.productPictures == null)
                Positioned(
                    child: Container(
                      color: AppColor.secondaryBackground,
                      height: MediaQuery.of(context).size.height / 2,
                      width: double.infinity,
                      child: NetworkImageLoader(
                        image: viewModel.productDetails!.overview!.primaryImageUrl,
                        fit: BoxFit.contain,
                      ),
                    )
                )
              else
                Positioned(child: _ImageList(viewModel.productDetails!.productPictures)),


              Positioned(
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: viewModel.productDetails!.overview!.ribbonTextBackgroundColor,
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(8)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    viewModel.productDetails!.overview!.ribbonText!,
                    style: const TextStyle(fontSize: 12, color: AppColor.white),
                    textScaleFactor: 1,
                  )
                ),
              )


            ],
          ),



          _ProductInfoSection(),

          if (viewModel.productDetails!.productNotes != null) _ProductNotes(),

          if (viewModel.productDetails!.volumePricing == null)
            _VolumePriceLoading()
          else if (viewModel.productDetails!.volumePricing!.isEmpty)
            Container()
          else
            _VolumePricing(),

          if (viewModel.productDetails!.coinGradeSpecification.isNotEmpty)
            _CoinGradeSpecification()
        ],
      ),
    );
  }
}

class _ImageList extends ViewModelWidget<ProductDetailViewModel> {
  final List<String>? images;

  _ImageList(this.images);

  @override
  Widget build(BuildContext context, ProductDetailViewModel viewModel) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      color: AppColor.secondaryBackground,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => ProductImagesFullViewPage(images, index)));
            },
            child: NetworkImageLoader(
              image: images![index],
              fit: BoxFit.contain,
            ),
          );
        },
        onIndexChanged: (index) {
          viewModel.activeIndex = index;
        },
        itemCount: images!.length,
        loop: true,
        layout: SwiperLayout.DEFAULT,
        pagination: const SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: DotSwiperPaginationBuilder(
              color: AppColor.secondaryBackground,
              activeColor: AppColor.primary,
              size: 7.0,
              activeSize: 7.0),
        ),
      ),
    );
  }
}

class _ProductInfoSection extends ViewModelWidget<ProductDetailViewModel> {
  @override
  Widget build(BuildContext context, ProductDetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: AppColor.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (viewModel.productDetails!.overview!.ribbonText != null)
            Container(
                decoration: BoxDecoration(
                    color: viewModel.productDetails!.overview!.ribbonTextBackgroundColor
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text(
                  viewModel.productDetails!.overview!.ribbonText!,
                  style: const TextStyle(fontSize: 12, color: AppColor.white),
                  textScaleFactor: 1,
                )),

          VerticalSpacing.d5px(),

          Text(
            viewModel.productDetails!.overview!.name!,
            style: AppTextStyle.title,
            textScaleFactor: 1,
          ),

          Row(
            children: [
              if (viewModel.productDetails!.overview!.reviewCount != 0)
                // RatingBar.readOnly(
                //   initialRating: viewModel.productDetails!.overview!.avgRatings!,
                //   isHalfAllowed: true,
                //   halfFilledIcon: Icons.star_half,
                //   filledIcon: Icons.star,
                //   emptyIcon: Icons.star_border,
                //   size: 16,
                // ),
              HorizontalSpacing.d5px(),
              Expanded(
                  child: Text(
                viewModel.productDetails!.overview!.reviewCount == 0
                    ? ""
                    : "(${viewModel.productDetails!.overview!.reviewCount})",
                textScaleFactor: 1,
                textAlign: TextAlign.left,
                style: AppTextStyle.body,
              )),

            ],
          ),

          // Container(height: 1, child: AppStyle.customDivider),

          if (viewModel.productDetails!.overview!.productAction == ProductInfoDisplayType.addToCart)
            _PriceInfo()
          else
            _AlertText()
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
              style: AppTextStyle.body.copyWith(
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
                    style: AppTextStyle.title,
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
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: SizedBox(height: 2, child: AppStyle.customDivider),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    "Quantity",
                    textScaleFactor: 1,
                    style: AppTextStyle.title.copyWith(fontSize: 14),
                    textAlign: TextAlign.left,
                  )),
                  ...viewModel.productDetails!.volumePricing![0]
                      .productPricesByPaymentType!
                      .map((e) {
                    return Expanded(
                        child: Text(
                      e.name!,
                      style: AppTextStyle.title.copyWith(fontSize: 14),
                      textAlign: TextAlign.center,
                    ));
                  }).toList()
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: SizedBox(height: 2, child: AppStyle.customDivider),
            ),
            ListView.separated(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              itemCount: viewModel.productDetails!.volumePricing!.length,
              separatorBuilder: (BuildContext context, index) =>
                  AppStyle.customDivider,
              itemBuilder: (BuildContext context, index) {
                return Opacity(
                  opacity: viewModel.productDetails!.volumePricing![index]
                          .strikeThroughEnabled!
                      ? 0.8
                      : 1,
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        viewModel.productDetails!.volumePricing![index].tier!,
                        style: AppTextStyle.text.copyWith(
                            decoration: viewModel.productDetails!.volumePricing![index]
                                    .strikeThroughEnabled!
                                ? TextDecoration.lineThrough
                                : null),
                        textAlign: TextAlign.left,
                      )),
                      ...viewModel.productDetails!.volumePricing![index]
                          .productPricesByPaymentType!
                          .map((e) {
                        return Expanded(
                            child: Text(
                          e.formattedPrice!,
                          style: AppTextStyle.text.copyWith(
                              decoration: viewModel
                                      .productDetails!
                                      .volumePricing![index]
                                      .strikeThroughEnabled!
                                  ? TextDecoration.lineThrough
                                  : null),
                          textAlign: TextAlign.center,
                        ));
                      }).toList()
                    ],
                  ),
                );
              },
            ),
          ],
        ));
  }
}

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
                          image:
                          viewModel.productDetails!.coinHeaderSpecification!.value,
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
              // ListView.separated(
              //   shrinkWrap: true,
              //   primary: false,
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              //   itemCount: viewModel.productDetails!.coinGradeSpecification.length,
              //   separatorBuilder: (BuildContext context, index) =>
              //       AppStyle.customDivider,
              //   itemBuilder: (BuildContext context, index) {
              //     return SpecificationItem(
              //         viewModel.productDetails!.coinGradeSpecification[index]);
              //   },
              // ),
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
                          style: AppTextStyle.body,
                        ),
                        NetworkImageLoader(
                          image: viewModel.productDetails!.coinFooterSpecification!
                              .keyHelpText,
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
        style: AppTextStyle.title.copyWith(color: AppColor.red),
      ),
    );
  }
}

class _PriceInfo extends ViewModelWidget<ProductDetailViewModel> {
  @override
  Widget build(BuildContext context, ProductDetailViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 2.0),
            child: RichText(
              textScaleFactor: 1,
              textAlign: TextAlign.left,
              text: TextSpan(
                  text: "${viewModel.productOverview!.pricing!.formattedNewPrice} ",
                  style: AppTextStyle.title.copyWith(
                      fontSize: 20,
                      color: viewModel.productOverview!.pricing!.strikeThroughEnabled!
                          ? const Color(0xffC30000)
                          : AppColor.primaryDark),
                  children: <TextSpan>[
                    if (viewModel.productOverview!.pricing!.strikeThroughEnabled!)
                      TextSpan(
                          text: viewModel.productOverview!.pricing!.formattedOldPrice,
                          style: AppTextStyle.title.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                              color: const Color(0xff666666),
                              decoration: TextDecoration.lineThrough))
                  ]),
            )),

        Text(
          viewModel.productDetails?.priceBadgeText ?? '',
          textAlign: TextAlign.left,
          style: AppTextStyle.body.copyWith(fontSize: 14),
        ),

        if (viewModel.productOverview!.pricing!.strikeThroughEnabled!)
          Text(viewModel.productOverview!.pricing!.discountText ?? '',
              textAlign: TextAlign.left,
              style: AppTextStyle.body.copyWith(
                  color: AppColor.offerText,
                  fontWeight: FontWeight.w600,
                  fontSize: 14)),

        // VerticalSpacing.d15px(),
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

  AlertToast(
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
                  style: AppTextStyle.body
                      .copyWith(color: titleColor, fontWeight: FontWeight.bold),
                ),
                VerticalSpacing.d2px(),
                Text(
                  productDetails!.overview!.name!,
                  textScaleFactor: 1,
                  style: AppTextStyle.body.copyWith(fontSize: 12),
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
                  style:
                      AppTextStyle.body.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            )
        ],
      ),
    );
  }
}
