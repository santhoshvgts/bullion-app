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
          appBar: AppBar(
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
          ),
          body: viewModel.isBusy
              ? const Align(
                  alignment: Alignment.bottomCenter,
                  child: LinearProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: [
                    MyOrdersPage(viewModel.ordersList, OrderStatus.ALL),
                    MyOrdersPage(viewModel.ordersList, OrderStatus.INPROGRESS),
                    MyOrdersPage(viewModel.ordersList, OrderStatus.SHIPPED),
                    MyOrdersPage(viewModel.ordersList, OrderStatus.CANCELLED),
                  ],
                ),
        );
      },
    );
  }
}
