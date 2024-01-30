import 'package:auto_size_text/auto_size_text.dart';
import 'package:bullion/core/constants/display_type.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/models/module/product_detail/product_price.dart';
import 'package:bullion/core/models/module/product_detail/product_variant.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/appconfig_service.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/shared/contentful/dynamic/product/product_detail_view_model.dart';
import 'package:bullion/ui/shared/web_view/apmex_web_view.dart';
import 'package:bullion/ui/view/product/detail/product_specification_page.dart';
import 'package:bullion/ui/view/product/detail/volume_info_bottom_sheet.dart';
import 'package:bullion/ui/view/product/product_images_full_view.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/chip_item.dart';
import 'package:bullion/ui/widgets/network_image_loader.dart';
import 'package:bullion/ui/widgets/shimmer_effect.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';

import '../../../../../helper/utils.dart';
import '../../../../../services/authentication_service.dart';
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
  ProductDetailViewModel viewModelBuilder(BuildContext context) => ProductDetailViewModel();

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
          Stack(
            children: [
              _ImageList(
                viewModel.productDetails?.productPictures?.map((e) => e.imageUrl ?? '').toList() ??
                    [viewModel.productDetails!.overview!.primaryImageUrl!],
              ),
              if (viewModel.productDetails?.overview?.ribbonText?.isNotEmpty == true)
                Positioned(
                  top: 10,
                  left: 15,
                  child: Container(
                    decoration: BoxDecoration(
                      color: viewModel.productDetails!.overview!.ribbonTextBackgroundColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5,),
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
                right: 15,
                child: InkWell(
                  onTap: () {
                    if (!locator<AuthenticationService>().isAuthenticated) {
                      Util.showLoginAlert();
                      return;
                    }
                    viewModel.addAsFavorite(setting?.productId);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: viewModel.busy(viewModel.productDetails!.isInUserWishList) ? SizedBox(
                      height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation(Colors.red.shade400)
                        )
                    ) : Icon(
                      setting!.isInUserWishList! ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                      size: 20,
                      color: setting!.isInUserWishList! ? Colors.red.shade400 : Colors.black38,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 60,
                right: 15,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        if (!locator<AuthenticationService>().isAuthenticated) {
                          Util.showLoginAlert();
                          return;
                        }
                        viewModel.priceAlert(setting?.overview, context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          setting!.isInUserPriceAlert! ? CupertinoIcons.bell_fill : CupertinoIcons.bell,
                          size: 20,
                          color: setting!.isInUserPriceAlert! ? Colors.orange.shade400 : Colors.black38,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 80,
                right: 15,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Share.share(
                          "Check out this product on BULLION.com:\n${viewModel.productDetails!.overview!.name!}\n\n${locator<AppConfigService>()
                                  .config!
                                  .appLinks!
                                  .webUrl!}${viewModel.productDetails!.overview!.targetUrl!}",
                          subject: "Bullion.com",
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.share,
                          size: 20,
                          color: AppColor.text,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _ProductInfoSection(),
          if (viewModel.productDetails!.productNotes != null)
            _ProductNotes(),
          if (viewModel.productDetails!.volumePricing == null)
            _VolumePriceLoading()
          else if (viewModel.productDetails!.volumePricing!.isEmpty)
            Container()
          else
            _VolumePricing(),
          if (viewModel.productDetails!.coinGradeSpecification.isNotEmpty)
            _CoinGradeSpecification(),

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
        SizedBox(
          height: MediaQuery.of(context).size.height / 1.8,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  if (viewModel.productDetails?.productPictures != null) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ProductImagesFullViewPage(viewModel.productDetails?.productPictures, viewModel.activeIndex)));
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  color: AppColor.secondaryBackground,
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
            controller: viewModel.productImageController,
          ),
        ),
        VerticalSpacing.d10px(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ImagePaginationBuilder(
            activeBorderColor: AppColor.primary,
            activeSize: 40,
            size: 40,
            images: images,
            activeIndex: viewModel.activeIndex,
            controller: viewModel.productImageController
          ),
        )
      ],
    );
  }
}

class _ProductInfoSection extends ViewModelWidget<ProductDetailViewModel> {
  @override
  Widget build(BuildContext context, ProductDetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 10),
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

          if (viewModel.productDetails!.overview!.productAction ==
              ProductInfoDisplayType.addToCart)
            _PriceInfo()
          else
            _AlertText(),

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

          VerticalSpacing.d10px(),

          AppStyle.customDivider,

          _VariationSelection(),

        ],
      ),
    );
  }
}

class _ProductNotes extends ViewModelWidget<ProductDetailViewModel> {
  @override
  Widget build(BuildContext context, ProductDetailViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: AppColor.white,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: viewModel.productDetails?.productNotes?.map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColor.info.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10)
                ),
                margin: const EdgeInsets.only(bottom: 10),
                width: double.infinity,
                child: Text(
                  e,
                  style: AppTextStyle.bodyMedium.copyWith(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.start,
                ),
              );
            }).toList() ?? [],
          ),
        ),

        AppStyle.customDivider,

      ],
    );
  }
}

class _VolumePriceLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Volume Discount Pricing",
                    textScaleFactor: 1,
                    style: AppTextStyle.titleMedium,
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      locator<DialogService>().showBottomSheet(title: "Volume Discount Pricing", child: VolumeInfoBottomSheet(viewModel.productDetails?.volumePricingHelpText));
                    },
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

            VerticalSpacing.d20px(),

            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Wrap(
                  spacing: 7,
                  children: [
                    ...viewModel.productDetails?.volumePricing?.first
                        .productPricesByPaymentType
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

            VerticalSpacing.d5px(),

            Container(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...viewModel.productDetails?.volumePricing?.asMap()
                            .map((index, volumePricing) {
                          ProductPricesByPaymentType? pricing = volumePricing
                              .productPricesByPaymentType
                              ?.firstWhere((element) =>
                                  element.name ==
                                  viewModel.selectedPaymentType?.name);

                          return MapEntry(
                            index,
                            Padding(
                              padding: const EdgeInsets.only(right: 0),
                              child: _VolumeDiscountCard(
                                title: volumePricing.tier ?? '-',
                                price: pricing?.formattedPrice ?? "-",
                                strikeThrough: viewModel
                                    .selectedVolumePricing!.strikeThroughEnabled!,
                                selected: viewModel.selectedVolumePricing ==
                                    volumePricing,
                                offerText: index == 0 ? "" : pricing?.formattedPriceSavings ?? '',
                                onTap: () {
                                  viewModel.selectedVolumePricing = volumePricing;
                                },
                              ),
                            ),
                          );
                        }).values.toList() ??
                        []
                  ],
                ),
              ),
            ),

            if (viewModel.productOverview?.orderMin?.toString().isNotEmpty == true)
              Container(
                decoration: BoxDecoration(
                  color: AppColor.primary.withOpacity(0.05),
                  border: Border.all(color: AppColor.primary),
                  borderRadius: BorderRadius.circular(5)
                ),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.center,
                child: Text(
                    "Min Qty of ${viewModel.productOverview?.orderMin?.toString() ?? ''} is required for purchase.",
                  style: AppTextStyle.labelMedium.copyWith(color: AppColor.primary),
                ),
              ),

            VerticalSpacing.d15px(),

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
          color: AppColor.white,
          border: Border.all(
            color: AppColor.border,
            width: 0.6
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
            AutoSizeText(
              price,
              style: AppTextStyle.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                  decoration:
                      strikeThrough ? TextDecoration.lineThrough : null),
              textAlign: TextAlign.center,
            ),

            VerticalSpacing.d2px(),

            Text((offerText?.isEmpty == true) ? "" : "Save ${offerText!}", textScaleFactor: 1, style: AppTextStyle.bodySmall.copyWith(color: AppColor.offerText),),
          ],
        ),
      ),
    );
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
    return Text(
      viewModel.productDetails?.overview?.availabilityText ?? '-',
      style: AppTextStyle.titleMedium.copyWith(color: AppColor.red),
    );
  }
}

class _ShippingInfoCard extends ViewModelWidget<ProductDetailViewModel> {
  @override
  Widget build(BuildContext context, ProductDetailViewModel viewModel) {

    if (viewModel.productOverview?.quickShip != true) {
      return const SizedBox();
    }

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

    List<ProductVariant> variantList = viewModel.productDetails?.productVariants?.where((element) => (element.options?.length ?? 0) > 1).toList() ?? [];

    if (variantList.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
          width: double.infinity,
          child: ListView.separated(
            primary: false,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: variantList.length,
            separatorBuilder: (context, index) {
              return VerticalSpacing.d20px();
            },
            itemBuilder: (context, index) {
              ProductVariant variant = variantList[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    variant.variantGroupName ?? '',
                    style:
                    AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                  ),
                  VerticalSpacing.d10px(),
                  Wrap(
                    spacing: 5,
                    children: [
                      ...variant.options?.asMap().map((index, option) => MapEntry(
                        index,
                        InkWell(
                          onTap: () {
                            viewModel.applyVariation(option.targetUrl ?? '');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                color: option.isSelected!
                                    ? AppColor.primary.withOpacity(0.05) : Colors.white,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: option.isSelected!
                                      ? AppColor.primary
                                      : AppColor.border,
                                )),
                            child: Text(
                              option.variantOptionName ?? '',
                              style: AppTextStyle.bodyMedium.copyWith(
                                color: option.isSelected! ? AppColor.primary : AppColor.text,
                                fontWeight:  option.isSelected! ? FontWeight.w500 : null
                              ),
                            ),
                          ),
                        ),
                      )).values.toList() ?? []
                    ],
                  ),
                ],
              );
            }
          ),
        ),
        AppStyle.customDivider,
      ],
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
                  text:
                  "${viewModel.productOverview!.pricing!.formattedNewPrice} ",
                  style: AppTextStyle.titleLarge.copyWith(
                      fontSize: 20,
                      fontFamily: AppTextStyle.fontFamily,
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
