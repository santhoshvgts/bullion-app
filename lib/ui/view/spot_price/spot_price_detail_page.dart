import 'dart:async';

import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/filter_service.dart';
import 'package:bullion/services/shared/eventbus_service.dart';
import 'package:bullion/ui/shared/cart/cart_button.dart';
import 'package:bullion/ui/shared/metal_tab_view.dart';
import 'package:bullion/ui/view/core/content_wrapper.dart';
import 'package:bullion/ui/view/spot_price/spot_price_detail_view_model.dart';
import 'package:bullion/ui/view/spot_price/spotprice_tab_bar.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/loading_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SpotPriceDetailPage extends VGTSBuilderWidget<SpotPriceDetailViewModel> {
  final String metalName;
  String? targetUrl = "";

  SpotPriceDetailPage(this.metalName, this.targetUrl);

  late StreamSubscription<SelfRedirectEvent> subscription;

  @override
  void onViewModelReady(SpotPriceDetailViewModel viewModel) {
    subscription = locator<EventBusService>()
        .eventBus
        .registerTo<SelfRedirectEvent>(true)
        .listen((event) {
      controller.onMetalChange!(event.targetUrl);
    });
    viewModel.init(metalName);
  }

  final ContentWrapperController controller = ContentWrapperController();

  @override
  SpotPriceDetailViewModel viewModelBuilder(BuildContext context) =>
      SpotPriceDetailViewModel();

  @override
  Widget viewBuilder(
    BuildContext context,
    AppLocalizations locale,
    SpotPriceDetailViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        elevation: 0.5,
        title: Text(
          "Spot Price",
          textScaleFactor: 1,
          style: AppTextStyle.titleMedium.copyWith(
            color: AppColor.text,
            fontFamily: AppTextStyle.fontFamily,
          ),
        ),
        actions: const [CartButton.light()],
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 40),
          child: SpotPriceTabBar(
            tabList: viewModel.spotPriceList ?? [],
            initialIndex: viewModel.selectedIndex,
            onChange: (int index, String metalName) {
              viewModel.selectedIndex = index;
              viewModel.name = metalName;

              locator<FilterService>().alertMetal = metalName;

              if (controller.onMetalChange != null) {
                controller.onMetalChange!(metalName);
              }
              viewModel.notifyListeners();
            },
            controller: viewModel.controller,
          ),
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: ContentWrapper(
              viewModel.selectedIndex == null
                  ? '$targetUrl?type=week'
                  : targetUrl,
              controller: controller,
              metalName: viewModel.name,
              loadingStyle: LoadingStyle.LOGO,
              onLoading: (bool val) {
                viewModel.loading = val;
              },
              onPageFetched: (pageSetting) {
                viewModel.pageSettings = pageSetting;
              },
            ),
          ),
        ],
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     centerTitle: true,
    //     titleSpacing: 0,
    //     elevation: 0,
    //     title: Container(
    //       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
    //       child: Wrap(
    //         crossAxisAlignment: WrapCrossAlignment.center,
    //         children: [
    //           Image.asset(
    //             Images.appBullLogo,
    //             width: 18,
    //           ),
    //           HorizontalSpacing.d5px(),
    //           Text(
    //             viewModel.selectedSpotPrice?.metalName ?? '',
    //             textScaleFactor: 1,
    //             style: AppTextStyle.bodyLarge.copyWith(
    //                 color: AppColor.text,
    //                 fontFamily: AppTextStyle.fontFamily,
    //                 fontWeight: FontWeight.w600),
    //           ),
    //         ],
    //       ),
    //     ),
    //     actions: const [CartButton.light()],
    //   ),
    //   body: viewModel.isBusy
    //       ? LoadingData()
    //       : Column(
    //           children: [
    //             Flexible(
    //               child: ContentWrapper(
    //                 viewModel.selectedIndex == null
    //                     ? '$targetUrl?type=week'
    //                     : targetUrl,
    //                 controller: controller,
    //                 metalName: viewModel.name,
    //                 onLoading: (bool val) {
    //                   viewModel.loading = val;
    //                 },
    //                 onPageFetched: (pageSetting) {
    //                   viewModel.pageSettings = pageSetting;
    //                 },
    //               ),
    //             ),
    //           ],
    //         ),
    // );
    // return Scaffold(
    //   body: NestedScrollView(
    //     headerSliverBuilder: (
    //       BuildContext context,
    //       bool innerBoxIsScrolled,
    //     ) {
    //       return <Widget>[
    //         SliverAppBar(
    //           expandedHeight: 120.0,
    //           floating: false,
    //           pinned: true,
    //           titleSpacing: 0,
    //           backgroundColor: AppColor.opacityColor(viewModel.name ?? ''),
    //           flexibleSpace: LayoutBuilder(
    //             builder: (context, BoxConstraints constraints) {
    //               double leftPadding = 160 - constraints.biggest.height;
    //
    //               return FlexibleSpaceBar(
    //                 expandedTitleScale: 1.5,
    //                 centerTitle: true,
    //                 titlePadding: EdgeInsets.only(
    //                   left: leftPadding < 15 ? 15 : leftPadding,
    //                   bottom: 15,
    //                 ),
    //                 title: Wrap(
    //                   children: [
    //                     Wrap(
    //                       crossAxisAlignment: WrapCrossAlignment.center,
    //                       children: <Widget>[
    //                         Text(
    //                           viewModel.selectedSpotPrice!.formattedAsk!,
    //                           textScaleFactor: 1,
    //                           style: AppTextStyle.titleMedium.copyWith(
    //                             color: AppColor.text,
    //                           ),
    //                         ),
    //                         const Padding(
    //                           padding: EdgeInsets.only(left: 5),
    //                         ),
    //                         Text(
    //                           'USD',
    //                           textScaleFactor: 1,
    //                           style: AppTextStyle.bodySmall.copyWith(
    //                             color: AppColor.text,
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       crossAxisAlignment: CrossAxisAlignment.center,
    //                       textBaseline: TextBaseline.alphabetic,
    //                       children: <Widget>[
    //                         Text(
    //                           "${viewModel.selectedSpotPrice!.changePct! > 0 ? "+" : "-"} ${viewModel.selectedSpotPrice!.formmatedChangePercentage!}",
    //                           textScaleFactor: 1,
    //                           style: AppTextStyle.bodySmall.copyWith(
    //                             color: viewModel.selectedSpotPrice!.changeColor,
    //                             fontWeight: FontWeight.w600,
    //                           ),
    //                         ),
    //                         const Padding(
    //                           padding: EdgeInsets.only(left: 5),
    //                         ),
    //                         Text(
    //                           "(${viewModel.selectedSpotPrice!.changePct! > 0 ? "+" : ""}${viewModel.selectedSpotPrice!.formattedChange})",
    //                           textScaleFactor: 1,
    //                           style: AppTextStyle.bodySmall.copyWith(
    //                             color: viewModel.selectedSpotPrice!.changeColor,
    //                             fontWeight: FontWeight.w600,
    //                           ),
    //                         ),
    //                         // const Padding(
    //                         //   padding: EdgeInsets.only(left: 5),
    //                         // ),
    //                         // Text(
    //                         //   viewModel
    //                         //       .selectedSpotPrice!.formattedLastUpdated!,
    //                         //   textScaleFactor: 1,
    //                         //   style: const TextStyle(
    //                         //     fontSize: 13,
    //                         //     color: AppColor.secondaryText,
    //                         //   ),
    //                         // ),
    //
    //                         // Icon(
    //                         //   _mySpotPrice.changeIcon,
    //                         //   color: _mySpotPrice.changeColor,
    //                         // ),
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //               );
    //             },
    //           ),
    //           // bottom: PreferredSize(
    //           //     preferredSize: const Size(double.infinity, 60),
    //           //     child: SpotPriceTabBar(
    //           //       tabList: viewModel.spotPriceList ?? [],
    //           //       initialIndex: viewModel.selectedIndex,
    //           //       controller: viewModel.controller,
    //           //       onChange: (int index, String metalName) {
    //           //         if (viewModel.loading == false) {
    //           //           viewModel.selectedIndex = index;
    //           //           viewModel.name =
    //           //               viewModel.spotPriceList?[index].metalName;
    //           //           //TODO SCROLL TO POSITION ANIMATION
    //           //           // viewModel.controller.animateTo(
    //           //           //   index * 100,
    //           //           //   duration: const Duration(milliseconds: 500),
    //           //           //   curve: Curves.fastOutSlowIn,
    //           //           // );
    //           //           locator<FilterService>().alertMetal = metalName;
    //           //           if (controller.onMetalChange != null) {
    //           //             controller.onMetalChange!(metalName);
    //           //           }
    //           //           locator<AnalyticsService>()
    //           //               .logScreenView(metalName, className: "spotprices");
    //           //           viewModel.notifyListeners();
    //           //         }
    //           //       },
    //           //     )),
    //         ),
    //         SliverList(
    //           delegate: SliverChildListDelegate([
    //             SpotPriceTabBar(
    //               tabList: viewModel.spotPriceList ?? [],
    //               initialIndex: viewModel.selectedIndex,
    //               controller: viewModel.controller,
    //               onChange: (int index, String metalName) {
    //                 if (viewModel.loading == false) {
    //                   viewModel.selectedIndex = index;
    //                   viewModel.name =
    //                       viewModel.spotPriceList?[index].metalName;
    //                   //TODO SCROLL TO POSITION ANIMATION
    //                   // viewModel.controller.animateTo(
    //                   //   index * 100,
    //                   //   duration: const Duration(milliseconds: 500),
    //                   //   curve: Curves.fastOutSlowIn,
    //                   // );
    //                   locator<FilterService>().alertMetal = metalName;
    //                   if (controller.onMetalChange != null) {
    //                     controller.onMetalChange!(metalName);
    //                   }
    //                   locator<AnalyticsService>()
    //                       .logScreenView(metalName, className: "spotprices");
    //                   viewModel.notifyListeners();
    //                 }
    //               },
    //             )
    //           ]),
    //         ),
    //       ];
    //     },
    //     body: viewModel.isBusy
    //         ? LoadingData()
    //         : ContentWrapper(
    //             viewModel.selectedIndex == null
    //                 ? '$targetUrl?type=week'
    //                 : targetUrl,
    //             controller: controller,
    //             metalName: viewModel.name,
    //             onLoading: (bool val) {
    //               viewModel.loading = val;
    //             },
    //             onPageFetched: (pageSetting) {
    //               viewModel.pageSettings = pageSetting;
    //             },
    //           ),
    //   ),
    // );
  }
}
