import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../core/res/colors.dart';
import '../../../../core/res/spacing.dart';
import '../../../../core/res/styles.dart';
import '../../../../helper/utils.dart';
import '../../../widgets/animated_flexible_space.dart';
import '../../../widgets/button.dart';
import '../../../widgets/loading_data.dart';
import '../../../widgets/network_image_loader.dart';
import '../../../widgets/staggered_animation.dart';
import '../../vgts_builder_widget.dart';
import 'favorites_view_model.dart';

class FavoritesPage extends VGTSBuilderWidget<FavoritesViewModel> {
  const FavoritesPage({super.key});

  @override
  void onViewModelReady(FavoritesViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget viewBuilder(
      BuildContext context, AppLocalizations locale, viewModel, Widget? child) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                icon: Util.showArrowBackward(),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
              ),
              expandedHeight: 100,
              pinned: true,
              flexibleSpace:
                  const AnimatedFlexibleSpace.withoutTab(title: "Favorites"),
            ),
            SliverToBoxAdapter(
              child: viewModel.isBusy
                  ? LoadingData(
                      loadingStyle: LoadingStyle.LOGO,
                    )
                  : viewModel.favoritesResponse == null
                      ? const Center(child: Text("No data available"))
                      : viewModel.favoritesResponse!.isNotEmpty
                          ? SingleChildScrollView(
                              child: AnimationLimiter(
                                child: ListView.separated(
                                  itemCount: viewModel.favoritesResponse?.length ?? 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder: (context, index) {
                                    return VerticalSpacing.d10px();
                                  },
                                  itemBuilder: (context, index) {
                                    return StaggeredAnimation.staggeredList(
                                        index: index,
                                        child: _FavoriteCard(
                                          viewModel.favoritesResponse![index],
                                          onRemove: (productId) {
                                            viewModel.removeFavorite(productId);
                                          },
                                        )
                                    );
                                  },
                                ),
                              ),
                            )
                          : Container(
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
                                    "Favorites",
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.titleLarge,
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    "You don’t have any favorite products to display.",
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.bodySmall,
                                  ),
                                ],
                              ),
                            )
            )
          ],
        ),
      ),
    );
  }

  @override
  viewModelBuilder(BuildContext context) {
    return FavoritesViewModel();
  }
}

class _FavoriteCard extends StatelessWidget {

  ProductDetails details;
  Function onRemove;

  _FavoriteCard(this.details, { required this.onRemove });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppStyle.elevatedCardShadow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 55,
                height: 55,
                child: NetworkImageLoader(
                  image: details.overview?.primaryImageUrl ?? "",
                  fit: BoxFit.cover,
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${details.overview?.name}", style: AppTextStyle.titleSmall,),
                    VerticalSpacing.d5px(),

                    IgnorePointer(
                      ignoring: true,
                      child: RatingBar(
                        initialRating: details.overview?.avgRatings ?? 0,
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
                    ),

                    VerticalSpacing.custom(value: 7),

                    Text("${details.overview?.pricing?.badgeText} : ${details.overview?.pricing?.formattedNewPrice.toString()}", style: AppTextStyle.titleSmall),

                  ],
                ),
              ),

            ],
          ),

          const SizedBox(height: 4.0),
          const Divider(
            thickness: 1,
            color: AppColor.border,
          ),
          const SizedBox(
            height: 4.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Button(
                width: 96,
                height: 35,
                color: AppColor.primary,
                "Buy now",
                valueKey: const Key("btnBuyNow"),
                borderRadius: BorderRadius.circular(24),
                onPressed: () {
                  locator<NavigationService>().pushNamed(details.overview?.targetUrl, arguments: details);
                },
              ),
              const SizedBox(
                width: 16,
              ),

              InkWell(
                onTap: () async {
                  AlertResponse response = await locator<DialogService>().showConfirmationDialog(
                      title: "Delete",
                      description: "Do you want to delete this Alert ?",
                      buttonTitle: "Delete"
                  );

                  if (response.status == true) {
                    onRemove(details.overview?.productId);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(right: 4.0),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: AppColor.red,
                        ),
                      ),
                      Text("Delete", style: AppTextStyle.titleSmall.copyWith(color: AppColor.red),
                      )
                    ],
                  ),
                ),
              ),



            ],
          ),
        ],
      ),
    );
  }

}
