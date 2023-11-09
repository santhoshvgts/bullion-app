import 'dart:io';

import 'package:bullion/ui/view/my_orders_section.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/enums/order_status.dart';
import '../../../core/res/styles.dart';
import 'orders_view_model.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late OrdersViewModel ordersViewModel;
  static const double _expandedHeight = 154;
  static const double _scrollOffset = 40;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      onViewModelReady: (viewModel) {
        ordersViewModel = viewModel;
      },
      viewModelBuilder: () => OrdersViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
          body: SafeArea(
            child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    leading: IconButton(
                      icon: Platform.isAndroid
                          ? const Icon(Icons.arrow_back)
                          : const Icon(Icons.arrow_back_ios),
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
                                  offset: Offset(
                                    dx,
                                    constraints.maxHeight - kToolbarHeight,
                                  ),
                                  child: const Text(
                                    "My Orders",
                                    style: AppTextStyle.titleLarge,
                                  ),
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
                      tabs: const [
                        Tab(text: "All Orders"),
                        Tab(text: "In Progress"),
                        Tab(text: "Shipped Orders"),
                        Tab(text: "Cancelled Orders"),
                      ],
                    ),
                    forceElevated: innerBoxIsScrolled,
                  )
                ];
              },
              controller: viewModel.scrollController,
              body: viewModel.isBusy
                  ? const Align(
                      alignment: Alignment.bottomCenter,
                      child: LinearProgressIndicator())
                  : SizedBox(
                      height: MediaQuery.of(context).size.height -
                          viewModel.scrollController.offset,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          MyOrdersPage(viewModel.ordersList, OrderStatus.ALL),
                          MyOrdersPage(
                              viewModel.ordersList, OrderStatus.INPROGRESS),
                          MyOrdersPage(
                              viewModel.ordersList, OrderStatus.SHIPPED),
                          MyOrdersPage(
                              viewModel.ordersList, OrderStatus.CANCELLED),
                        ],
                      ),
                    ),
              /*child: AppBar(
                toolbarHeight: 80,
                leadingWidth: double.infinity,
                leading: const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.arrow_back_ios),
                      Text(
                        "My Orders",
                        style: AppTextStyle.titleLarge,
                      ),
                    ],
                  ),
                ),*/
            ),
          ),
        );
      },
    );
  }
}
