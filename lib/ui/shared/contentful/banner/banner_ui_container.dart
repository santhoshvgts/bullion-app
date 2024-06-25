import 'dart:async';

import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/shared/contentful/banner/banner_view_model.dart';
import 'package:bullion/ui/shared/contentful/module/module_ui_container.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/shimmer_effect.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:bullion/core/constants/module_type.dart';
import 'package:bullion/core/models/module/module_settings.dart';
import 'package:bullion/core/models/module/banner_module.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/ui/widgets/network_image_loader.dart';
import 'dart:ui' as ui;

class BannerModule extends StatelessWidget {
  final ModuleSettings? setting;

  BannerModule(this.setting);

  @override
  Widget build(BuildContext context) {
    return ModuleUIContainer(
      setting,
      hideHeadSection: false,
      children: [_BannerModuleSection(setting)],
    );
  }
}

class _BannerModuleSection extends VGTSBuilderWidget<BannerViewModel> {
  final ModuleSettings? moduleSetting;

  _BannerModuleSection(this.moduleSetting);

  Completer<ui.Image> completer = Completer<ui.Image>();

  ImageStreamListener? listener;

  void _loadImage(String imageUrl) {
      Image image = Image.network(imageUrl);
      listener = ImageStreamListener((ImageInfo imageInfo, bool synCall) {
        if (!completer.isCompleted) {
          completer.complete(imageInfo.image);
        }
      });
      image.image.resolve(const ImageConfiguration()).addListener(listener!);
  }

  @override
  void onViewModelReady(BannerViewModel viewModel) {
    viewModel.init(this.moduleSetting!);

    if (viewModel.items?.isNotEmpty == true) {
      _loadImage(viewModel.items!.first.imageUrl!);
    }
  }

  @override
  BannerViewModel viewModelBuilder(BuildContext context) => BannerViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, BannerViewModel viewModel, Widget? child) {
    switch (moduleSetting!.displayType) {
      case BannerType.full:
        return FutureBuilder<ui.Image>(
          future: completer.future,
          builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                height: (snapshot.data!.height / snapshot.data!.width) * MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: PageView.builder(
                        itemBuilder: (context, index) {
                          return _BannerItemWidget(viewModel.items![index]);
                        },
                        controller: viewModel.bannerPageController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: viewModel.items!.length,
                        onPageChanged: (index) {},
                      ),
                    ),
                    Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SmoothPageIndicator(
                            controller: viewModel.bannerPageController,
                            count: viewModel.items!.length,
                            effect: const WormEffect(dotColor: AppColor.secondaryBackground,
                                activeDotColor: AppColor.primary,
                                dotHeight: 7, dotWidth: 7,
                            ),
                          ),
                        ))
                  ],
                ),

              );
            } else {
              return SizedBox(
                  height: 145,
                  child: ShimmerEffect(
                    shape: BoxShape.circle,
                    color: AppColor.secondaryBackground,
                    margin: const EdgeInsets.all(10.0),
                  ));
            }
          },
        );

      case BannerType.single:
        return FutureBuilder<ui.Image>(
            future: completer.future,
            builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
              if (snapshot.hasData) {
                return Container(
                  color: AppColor.white,
                  height: ((snapshot.data!.height / snapshot.data!.width) * MediaQuery.of(context).size.width) + 20,
                  child: Column(
                    children: [
                      Flexible(
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 15, bottom: 30),
                              child: _BannerSingleItemWidget(viewModel.items![index]),
                            );
                          },
                          index: viewModel.items!.length > 1 ? 1 : 0,
                          itemCount: viewModel.items!.length,
                          viewportFraction: 0.9,
                          scale: 0.95,
                          layout: SwiperLayout.DEFAULT,
                          loop: true,
                          pagination: const SwiperPagination(
                            alignment: Alignment.bottomCenter,
                            builder: DotSwiperPaginationBuilder(
                                color: Colors.black26,
                                activeColor: AppColor.primary,
                                size: 7.0,
                                activeSize: 9
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SizedBox(
                    height: 145,
                    child: ShimmerEffect(
                      shape: BoxShape.circle,
                      color: AppColor.secondaryBackground,
                      margin: const EdgeInsets.all(10.0),
                    )
                );
              }

            }
        );

      default:
        return Container();
    }
  }
}

class _BannerItemWidget extends VGTSBuilderWidget<BannerViewModel> {
  final BannerItem _items;
  _BannerItemWidget(this._items);

  @override
  BannerViewModel viewModelBuilder(BuildContext context) => BannerViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, BannerViewModel viewModel, Widget? child) {
    return InkWell(
        onTap: () => viewModel.onTap(_items.targetUrl),
        child: NetworkImageLoader(
          image: _items.imageUrl,
          fit: BoxFit.fitWidth,
        ));
  }
}

class _BannerSingleItemWidget extends VGTSBuilderWidget<BannerViewModel> {
  final BannerItem _items;
  _BannerSingleItemWidget(this._items);

  @override
  BannerViewModel viewModelBuilder(BuildContext context) => BannerViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, BannerViewModel viewModel, Widget? child) {
    return InkWell(
        onTap: () => viewModel.onTap(_items.targetUrl),
        borderRadius: BorderRadius.circular(7),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            boxShadow: AppStyle.mildCardShadow
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: NetworkImageLoader(
              image: _items.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ));
  }
}
