import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
                                  itemCount:
                                      viewModel.favoritesResponse?.length ?? 0,
                                  padding: const EdgeInsets.all(15),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder: (context, index) {
                                    return VerticalSpacing.d10px();
                                  },
                                  itemBuilder: (context, index) {
                                    return StaggeredAnimation.staggeredList(
                                        index: index,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    width: 1,
                                                    color: AppColor.border),
                                                boxShadow:
                                                    AppStyle.elevatedCardShadow,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              AppColor.iconBG,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        width: 56,
                                                        height: 56,
                                                        child:
                                                            NetworkImageLoader(
                                                          image: viewModel
                                                                  .favoritesResponse![
                                                                      index]
                                                                  .overview
                                                                  ?.primaryImageUrl ??
                                                              "",
                                                          fit: BoxFit.cover,
                                                          height: 100,
                                                          width: 100,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "${viewModel.favoritesResponse?[index].overview?.name}",
                                                              style: AppTextStyle
                                                                  .titleMedium,
                                                            ),
                                                            VerticalSpacing
                                                                .d5px(),
                                                            Row(
                                                              children: [
                                                                Text("Price:",
                                                                    style: AppTextStyle
                                                                        .titleSmall
                                                                        .copyWith(
                                                                            color:
                                                                                AppColor.border)),
                                                                const SizedBox(
                                                                    width: 8),
                                                                Text(
                                                                    viewModel
                                                                            .favoritesResponse?[
                                                                                index]
                                                                            .overview
                                                                            ?.pricing
                                                                            ?.formattedNewPrice
                                                                            .toString() ??
                                                                        "",
                                                                    style: AppTextStyle
                                                                        .titleMedium)
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      const Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 16,
                                                      )
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Button(
                                                        width: 96,
                                                        height: 35,
                                                        color: AppColor
                                                            .turtleGreen,
                                                        "Buy now",
                                                        valueKey: const Key(
                                                            "btnBuyNow"),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24),
                                                        onPressed: () {},
                                                      ),
                                                      const SizedBox(
                                                        width: 16,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          showDialog<String>(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                AlertDialog(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              title: const Text(
                                                                  'Delete'),
                                                              content: const Text(
                                                                  "Do you want to delete this Alert?"),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          'Cancel'),
                                                                  child: const Text(
                                                                      'Cancel'),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    viewModel.removeFavorite(viewModel.favoritesResponse?[index].overview?.productId);
                                                                    Navigator.pop(
                                                                        context);
                                                                      },
                                                                  child: const Text(
                                                                      'Delete'),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 16.0),
                                                          child: Row(
                                                            children: [
                                                              const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            4.0),
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color: AppColor
                                                                      .redOrange,
                                                                ),
                                                              ),
                                                              Text(
                                                                "Delete",
                                                                style: AppTextStyle
                                                                    .titleSmall
                                                                    .copyWith(
                                                                        color: AppColor
                                                                            .redOrange),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ));
                                  },
                                ),
                              ),
                            )
                          : Container(),
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
