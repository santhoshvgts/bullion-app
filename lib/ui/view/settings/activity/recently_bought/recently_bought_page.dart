

import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/shared/contentful/product/product_item_card.dart';
import 'package:bullion/ui/view/settings/activity/recently_bought/recently_bought_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bullion/core/enums/viewstate.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:stacked/stacked.dart';


class RecentlyBoughtPage extends VGTSBuilderWidget<RecentlyBoughtViewModel> {

  @override
  RecentlyBoughtViewModel viewModelBuilder(BuildContext context) => RecentlyBoughtViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, RecentlyBoughtViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buy Again", textScaleFactor: 1, style: AppTextStyle.titleMedium.copyWith(color: AppColor.text, fontFamily: AppTextStyle.fontFamily),),
      ),
      backgroundColor: AppColor.secondaryBackground,
      body: RefreshIndicator(
        onRefresh: () async {
          return await viewModel.getRecentlyBought();
        },
        child: Container(
          height: double.infinity,
          child: !viewModel.isBusy && viewModel.productList!.length == 0
              ? Container(
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
                  "Buy Again",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.titleLarge,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  "You don’t have any recently bought products to display.",
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

                ListView.separated(
                    itemCount: viewModel.isBusy ? 4 : viewModel.productList!.length,
                    primary: false,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10,);
                    },
                    itemBuilder: (context, index) {
                      if (viewModel.isBusy) {
                        return ShimmerEffect(height: 130,);
                      }
                      return ProductItemCard(ProductDetails(overview: viewModel.productList![index]), ProductItemCardType.Favorite,
                        onPressed: (ProductDetails detail) {
                          locator<NavigationService>().pushNamed(detail.overview!.targetUrl, arguments: detail);
                        },
                      );
                    }),


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

