import 'package:auto_size_text/auto_size_text.dart';
import 'package:bullion/core/models/module/product_detail/competitor_price.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/models/module/product_detail/specifications.dart';
import 'package:bullion/core/models/module/product_item.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/analytics_service.dart';
import 'package:bullion/ui/shared/contentful/dynamic/product/product_detail_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/apmex_html_widget.dart';
import 'package:bullion/ui/widgets/network_image_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:stacked/stacked.dart';

class ProductDetailSection extends  VGTSBuilderWidget<ProductDetailViewModel> {

  final ProductDetails? setting;

  const ProductDetailSection(this.setting, {super.key});

  @override
  void onViewModelReady(ProductDetailViewModel vm) {
    vm.init(setting);
    super.onViewModelReady(vm);
  }

  @override
  ProductDetailViewModel viewModelBuilder(BuildContext context) => ProductDetailViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, ProductDetailViewModel viewModel, Widget? child) {
    return Container(
      width: double.infinity,
      color: AppColor.secondaryBackground,
      child: Column(
        children: [

          if (viewModel.productOverview?.showPrice == true)
            _CompetitorPricing(
              viewModel.productDetails!.overview!,
              viewModel.productDetails?.competitorPrices ?? []
            ),

          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: ExpansionTile(
              onExpansionChanged: (state){
                if(state)
                {
                  locator<AnalyticsService>().logProductDetailViewInteraction(viewModel.productDetails!.overview!);
                }
              },
              title: const Text("Product Overview", style: AppTextStyle.titleMedium,),
              tilePadding: const EdgeInsets.symmetric(horizontal: 12),
              childrenPadding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                ApmexHtmlWidget(
                  viewModel.productDetails?.description ?? '',
                  textStyle: AppTextStyle.bodyMedium.copyWith(height: 1.7),
                )
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
            decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(10)
            ),

            child: ExpansionTile(
              onExpansionChanged: (state){
                if(state)
                {
                  locator<AnalyticsService>().logProductSpecViewInteraction(viewModel.productDetails!.overview!);
                }
              },
              title: const Text("Product Specification", style: AppTextStyle.titleMedium,),
              tilePadding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                ListView.separated(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: viewModel.productDetails?.specifications?.length ?? 0,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    separatorBuilder: (context, index) {
                      return AppStyle.customDivider;
                    },
                    itemBuilder: (context, index) {
                      return SpecificationItem(viewModel.productDetails!.specifications![index]);
                    }
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
}


class SpecificationItem extends StatelessWidget {
  Specifications data;

  SpecificationItem(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Text(
              data.key!,

              style: AppTextStyle.bodyMedium,
            ),
            if (data.keyHelpText!.isNotEmpty)
              InkWell(
                onTap: () {
                  // TODO - Volume Discount
                  // locator<DialogService>().showBottomSheet(title: data.key, child: VolumeInfoBottomSheet(data.keyHelpText));
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.info_outline,
                    size: 16,
                  ),
                ),
              ),
            Expanded(
                child: Text(
                  data.value!,

                  style:
                  AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.right,
                )),
          ],
        ),
      ),
    );
  }
}

class _CompetitorPricing extends StatelessWidget {

  ProductOverview overview;
  List<CompetitorPrice> competitorPrice;

  _CompetitorPricing(this.overview, this.competitorPrice);

  @override
  Widget build(BuildContext context) {

    if (competitorPrice.isEmpty) {
      return const SizedBox();
    }

    return Container(
     color: AppColor.secondaryBackground,
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [

         const Padding(
           padding: EdgeInsets.only(left: 15, top: 15),
           child: Text("Lowest Price Guarantee",  style: AppTextStyle.titleMedium,),
         ),

          Padding(
           padding: const EdgeInsets.only(left: 15, top: 10),
           child: Text("Please see below how the pricing of ${overview.name} "
               "compares against some of other bullion dealers. Our rate comparison table is for your information only "
               "and is primarily used as a benchmark.",
              style: AppTextStyle.bodyMedium,),
         ),

         SingleChildScrollView(
           scrollDirection: Axis.horizontal,
           padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
           child: Container(
             decoration: BoxDecoration(
                 color: AppColor.white,
                 border: Border.all(
                   color: AppColor.border,
                 ),
                 borderRadius: BorderRadius.circular(5)
             ),
             child: IntrinsicHeight(
               child: Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [

                   Container(
                     width: MediaQuery.of(context).size.width / 3,
                     padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                     margin: const EdgeInsets.only(right: 5),
                     color: AppColor.primary,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [

                         Text("Bullion.com",  style: AppTextStyle.bodyLarge.copyWith(color: AppColor.white),),

                         VerticalSpacing.custom(value: 25),

                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(overview.pricing?.badgeText ?? '',  style: AppTextStyle.labelSmall.copyWith(color: AppColor.white),),
                             Text(overview.pricing?.formattedNewPrice ?? '',  style: AppTextStyle.titleLarge.copyWith(color: AppColor.white)  ,),

                             VerticalSpacing.d5px(),

                             Container(
                                 decoration: BoxDecoration(
                                     color: const Color(0xff0CBC87),
                                     borderRadius: BorderRadius.circular(5)
                                 ),
                                 padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                                 child: Text("Lowest Price",
                                   style: AppTextStyle.labelSmall.copyWith(color: AppColor.white),
                                 )
                             ),
                           ],
                         )
                       ],
                     ),
                   ),

                   CompetitorPricingSection(competitorPrice),
                 ],
               ),
             ),
           ),
         ),

       ],
     ),
   );
  }

}

class CompetitorPricingSection extends StatelessWidget {

  List<CompetitorPrice> competitorPrice;

  CompetitorPricingSection(this.competitorPrice, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...competitorPrice.asMap().map((index, e) => MapEntry(
            index,
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  margin: const EdgeInsets.only(right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 3,
                          minWidth: MediaQuery.of(context).size.width / 3,
                        ),
                        child: Text(e.competitorName ?? '',  style: AppTextStyle.bodyLarge,)
                      ),

                      VerticalSpacing.custom(value: 25),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          if (e.isLowest == true)
                            Container(
                                decoration: BoxDecoration(
                                    color: AppColor.greenText,
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                                child: Text("Lowest Price",
                                  style: AppTextStyle.labelSmall.copyWith(color: AppColor.white),
                                )
                            ),

                          VerticalSpacing.d5px(),

                          const Text("As low as",  style: AppTextStyle.labelSmall,),

                          Text(e.formattedPrice.toString(),  style: AppTextStyle.titleLarge,),

                          VerticalSpacing.d5px(),

                          Container(
                              decoration: BoxDecoration(
                                  color: (e.isLower != true || e.inStock == false ? AppColor.red : AppColor.greenText).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [

                                  if (e.inStock == true)
                                    Icon(e.isLower == true ? Icons.arrow_downward : Icons.arrow_upward, size: 12, color: e.isLower == true ? AppColor.greenText : AppColor.red,),

                                  Text(e.badgeText ?? '',
                                    style: AppTextStyle.labelSmall.copyWith(
                                        color: e.isLower != true || e.inStock == false ? AppColor.red : AppColor.greenText
                                    ),
                                  ),
                                ],
                              )
                          ),

                        ],
                      )
                    ],
                  ),
                ),
                const VerticalDivider(
                  thickness: 0.5,
                  width: 0.5,
                ),
              ],
            )),
        ).values.toList() ?? []

      ],
    );
  }

}
