import 'dart:async';

import 'package:bullion/locator.dart';
import 'package:bullion/services/filter_service.dart';
import 'package:bullion/services/shared/analytics_service.dart';
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

import '../../shared/search_card_section.dart';

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
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      SpotPriceDetailViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        title: SearchCardSection(
          leftPadding: 0,
          rightPadding: 0,
        ),
        // title: Text(
        //   "Spot Price",
        //   textScaleFactor: 1,
        //   style: AppTextStyle.titleMedium.copyWith(color: AppColor.text),
        // ),
        elevation: 0,
        actions: const [CartButton.light()],
        bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 60),
            child: SpotPriceTabBar(
              tabList: viewModel.spotPriceList ?? [],
              initialIndex: viewModel.selectedIndex,
              controller: viewModel.controller,
              onChange: (int index, String metalName) {
                if (viewModel.loading == false) {
                  viewModel.selectedIndex = index;
                  viewModel.name = viewModel.spotPriceList?[index].metalName;
                  viewModel.controller.animateTo(
                    index * 100,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                  );
                  locator<FilterService>().alertMetal = metalName;
                  if (controller.onMetalChange != null) {
                    controller.onMetalChange!(metalName);
                  }
                  locator<AnalyticsService>()
                      .logScreenView(metalName, className: "spotprices");
                  viewModel.notifyListeners();
                }
              },
            )),
      ),
      body: viewModel.isBusy
          ? LoadingData()
          : Column(
              children: [
                Flexible(
                  child: ContentWrapper(
                    viewModel.selectedIndex == null
                        ? '$targetUrl?type=week'
                        : targetUrl,
                    controller: controller,
                    metalName: viewModel.name,
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
  }
}
