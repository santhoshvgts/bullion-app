import 'package:bullion/ui/view/settings/alerts/price_alert_section.dart';
import 'package:bullion/ui/view/settings/alerts/custom_spot_price_section.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../../core/res/styles.dart';
import '../../../../helper/utils.dart';
import '../../../widgets/loading_data.dart';
import 'alert_me_section.dart';
import 'alerts_view_model.dart';

class AlertsPage extends StatefulWidget {
  final int initialIndex;

  const AlertsPage({super.key, required this.initialIndex});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late AlertsViewModel alertsViewModel;
  static const double _expandedHeight = 154;

  _AlertsPageState();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        initialIndex: widget.initialIndex, length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      onViewModelReady: (viewModel) {
        alertsViewModel = viewModel;
      },
      viewModelBuilder: () => AlertsViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
          body: SafeArea(
            child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    leading: IconButton(
                      icon: Util.showArrowBackward(),
                      onPressed: () {
                        Navigator.of(context).maybePop();
                      },
                    ),
                    expandedHeight: _expandedHeight,
                    pinned: true,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.only(bottom: kTextTabBarHeight),
                      child: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          double percent =
                              (((constraints.maxHeight - 56) - kToolbarHeight) *
                                  100 /
                                  (10 - kToolbarHeight));
                          double dx = 0;

                          dx = -13 + percent;
                          /*if (constraints.maxHeight == 100) {
                            dx = 0;
                          }*/

                          //To reduce the space between start to end
                          dx = (dx * 64) / 100;

                          return Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: kToolbarHeight / 4,
                                  left: 16,
                                ),
                                child: Transform.translate(
                                  offset: Offset(dx,
                                      constraints.maxHeight - kToolbarHeight),
                                  child: const Text("Alerts",
                                      style: AppTextStyle.titleLarge),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    bottom: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      tabs: const [
                        Tab(text: "Custom Spot Price"),
                        Tab(text: "Price Alert"),
                        Tab(text: "Alert Me"),
                      ],
                    ),
                    forceElevated: innerBoxIsScrolled,
                  )
                ];
              },
              controller: viewModel.scrollController,
              body: viewModel.isBusy
                  ? LoadingData(
                      loadingStyle: LoadingStyle.LOGO,
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height -
                          viewModel.scrollController.offset,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          CustomSpotPricePage(viewModel),
                          PriceAlertPage(viewModel),
                          AlertMePage(viewModel),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
