

import 'package:bullion/core/constants/module_type.dart';
import 'package:bullion/core/models/module/display_settings.dart';
import 'package:bullion/core/models/module/item_display_settings.dart';
import 'package:bullion/core/models/module/module_settings.dart';
import 'package:bullion/core/models/module/product_item.dart';
import 'package:bullion/core/models/module/product_listing/product_list_module.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/shared/contentful/product/product_item_card.dart';
import 'package:bullion/ui/shared/contentful/product/product_module.dart';
import 'package:bullion/ui/view/settings/activity/recently_viewed/recently_viewed_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:bullion/core/enums/viewstate.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/shimmer_effect.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecentlyViewedPage extends VGTSBuilderWidget<RecentlyViewedViewModel> {

  @override
  RecentlyViewedViewModel viewModelBuilder(BuildContext context) => RecentlyViewedViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, RecentlyViewedViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recently Viewed", textScaleFactor: 1, style: AppTextStyle.titleMedium.copyWith(color: AppColor.text, fontFamily: AppTextStyle.fontFamily),),
      ),
      backgroundColor: AppColor.secondaryBackground,
      body: RefreshIndicator(
        onRefresh: () async {
          return await viewModel.getRecentlyViewed();
        },
        child: SizedBox(
          height: double.infinity,
          child: !viewModel.isBusy && viewModel.productList!.length == 0
              ?  Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 1.5,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Images.cartIcon,
                        width: 150,
                      ),
                      const SizedBox(height: 32.0),
                      const Text(
                        "Recently Viewed",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.titleLarge,
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        "You don’t have any recently viewed products to display.",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.bodySmall,
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: viewModel.scrollController,
                  child: Column(
                    children: [

                      ProductWrapItemList(
                        wrap: true,
                        spacing: 0,
                        runSpacing: 0,
                        gridCols: 2,
                        children: viewModel.productList!
                            .asMap()
                            .map((index, item) {
                          return MapEntry(index, VerticalItem(item,
                            itemWidth: (MediaQuery.of(context).size.width/2) - 1,
                            wrapItems: true,
                            gridCols: 2,
                            textColor: AppColor.text,
                            onItemTap: (ProductOverview overview) {
                              locator<NavigationService>().pushNamed(overview.targetUrl, arguments: ProductDetails(overview: overview));
                            },
                          ));
                        }).values.toList(),
                      ),

                      // ListView.separated(
                      //     itemCount: viewModel.isBusy ? 4 : viewModel.productList!.length,
                      //     primary: false,
                      //     shrinkWrap: true,
                      //     separatorBuilder: (context, index) {
                      //       return const SizedBox(height: 10,);
                      //     },
                      //     padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      //     itemBuilder: (context, index) {
                      //       if (viewModel.isBusy) {
                      //         return ShimmerEffect(height: 130,);
                      //       }
                      //       return ProductItemCard(ProductDetails(overview: viewModel.productList![index]), ProductItemCardType.Favorite,
                      //         onPressed: (ProductDetails detail) {
                      //           locator<NavigationService>().pushNamed(detail.overview!.targetUrl, arguments: detail);
                      //         },
                      //       );
                      //     }),

                      if (viewModel.isPaginationLoading)
                        Container(
                          padding: const EdgeInsets.all(15),
                          height: 60,
                          width: 60,
                          child: const CircularProgressIndicator(strokeWidth: 1.5, valueColor: AlwaysStoppedAnimation(AppColor.primary),),
                        )

                    ],
                  ),
          ),
        ),
      ),
    );
  }

}
