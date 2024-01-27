import 'dart:async';

import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/page_storage_service.dart';
import 'package:bullion/services/shared/eventbus_service.dart';
import 'package:bullion/ui/shared/cart/cart_button.dart';
import 'package:bullion/ui/shared/metal_tab_view.dart';
import 'package:bullion/ui/view/core/content_wrapper.dart';
import 'package:bullion/ui/view/spot_price/spot_price_detail_view_model.dart';
import 'package:bullion/ui/view/spot_price/spotprice_tab_bar.dart';
import 'package:bullion/ui/widgets/loading_data.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SpotPriceDetailPage extends StatefulWidget {
  final String metalName;
  String? targetUrl = "";

  SpotPriceDetailPage(this.metalName, this.targetUrl);

  @override
  State<SpotPriceDetailPage> createState() => _SpotPriceDetailPageState();
}

class _SpotPriceDetailPageState extends State<SpotPriceDetailPage>
    with TickerProviderStateMixin {
  late StreamSubscription<SelfRedirectEvent> subscription;
  final ContentWrapperController controller = ContentWrapperController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SpotPriceDetailViewModel>.reactive(
      viewModelBuilder: () => SpotPriceDetailViewModel(),
      onViewModelReady: (viewModel) {
        subscription = locator<EventBusService>()
            .eventBus
            .registerTo<SelfRedirectEvent>(true)
            .listen((event) {
          controller.onMetalChange!(event.targetUrl);
        });
        viewModel.init(widget.metalName, this);
      },
      builder: (context, viewModel, child) {
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
                  viewModel.pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease);
                },
                controller: viewModel.controller,
              ),
            ),
          ),
          body: PageView(
            controller: viewModel.pageController,
            onPageChanged: (int index) {
              viewModel.selectedIndex = index;
            },
            children: [
              ...viewModel.spotPriceList?.map((e) {
                    return ContentWrapper(
                      e.targetUrl,
                      controller: controller,
                      metalName: viewModel.name,
                      loadingStyle: LoadingStyle.LOGO,
                      initialValue: locator<PageStorageService>().read(
                        context,
                        ValueKey("spot_price_chart_${e.metalName})"),
                      ),
                      onPageFetched: (pageSetting) {
                        viewModel.pageSettings = pageSetting;
                        locator<PageStorageService>().write(
                          context,
                          ValueKey("spot_price_chart_${e.metalName})"),
                          pageSetting,
                        );
                      },
                    );
                  }).toList() ??
                  []
            ],
          ),
        );
      },
    );
  }
}
