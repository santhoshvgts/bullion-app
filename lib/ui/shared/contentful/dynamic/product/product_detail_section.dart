import 'package:auto_size_text/auto_size_text.dart';
import 'package:bullion/core/models/module/product_detail/competitor_price.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/models/module/product_item.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/ui/shared/contentful/dynamic/product/product_detail_view_model.dart';
import 'package:bullion/ui/view/product/detail/product_specification_page.dart';
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

  const ProductDetailSection(this.setting);

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
           child: Text("Lowest Price Guarantee", textScaleFactor: 1, style: AppTextStyle.titleMedium,),
         ),

         const Padding(
           padding: EdgeInsets.only(left: 15, top: 10),
           child: Text("Please see below how the pricing of 2023 1 oz American Silver Eagle Coin BU "
               "compares against some of other bullion dealers. Our rate comparison table is for your information only "
               "and is primarily used as a benchmark.",
             textScaleFactor: 1, style: AppTextStyle.bodyMedium,),
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

                         Text("Bullion.com", textScaleFactor: 1, style: AppTextStyle.bodyLarge.copyWith(color: AppColor.white),),

                         VerticalSpacing.custom(value: 25),

                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(overview.pricing?.badgeText ?? '', textScaleFactor: 1, style: AppTextStyle.labelSmall.copyWith(color: AppColor.white),),
                             Text(overview.pricing?.formattedNewPrice ?? '', textScaleFactor: 1, style: AppTextStyle.titleLarge.copyWith(color: AppColor.white)  ,),

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

  CompetitorPricingSection(this.competitorPrice);

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
                        child: Text(e.competitorName ?? '', textScaleFactor: 1, style: AppTextStyle.bodyLarge,)
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

                          Text("As low as", textScaleFactor: 1, style: AppTextStyle.labelSmall,),

                          Text(e.formattedPrice.toString(), textScaleFactor: 1, style: AppTextStyle.titleLarge,),

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
                                    Icon( e.isLower == true ? Icons.arrow_downward : Icons.arrow_upward, size: 12, color: e.isLower != true ? AppColor.red : AppColor.greenText,),

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
