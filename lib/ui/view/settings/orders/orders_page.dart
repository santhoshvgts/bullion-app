import 'package:bullion/core/models/module/cart/order_total_summary.dart';
import 'package:bullion/core/models/module/order.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/staggered_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:stacked/stacked.dart';
import '../../../../helper/utils.dart';
import '../../../widgets/animated_flexible_space.dart';
import '../../../widgets/loading_data.dart';
import 'orders_view_model.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with TickerProviderStateMixin {
  late TabController _tabController;
  static const double _expandedHeight = 154;
  static const double _scrollOffset = 40;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrdersViewModel>.reactive(
      onViewModelReady: (viewModel) {
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
                      icon: Util.showArrowBackward(),
                      onPressed: () {
                        Navigator.of(context).maybePop();
                      },
                    ),
                    expandedHeight: _expandedHeight,
                    pinned: true,
                    flexibleSpace: const AnimatedFlexibleSpace.withTab(title: "My Orders"),
                    bottom: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      tabs: viewModel.tabs.values.map((e) => Tab(text: e,)).toList(),
                      onTap: (int index) {
                        viewModel.onTabSelected(index);
                      },
                    ),
                    forceElevated: innerBoxIsScrolled,
                  )
                ];
              },
              controller: viewModel.scrollController,
              body: Column(
                children: [

                  if (viewModel.isBusy) Flexible(
                    child: LoadingData(
                      loadingStyle: LoadingStyle.LOGO,
                    ),
                  ) else if (viewModel.ordersList?.isEmpty != false)
                    Flexible(
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 1.5,
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                Images.iconEmptyOrders,
                                width: 150,
                              ),
                              const SizedBox(height: 32.0),
                              const Text(
                                "No Orders Found!",
                                textAlign: TextAlign.center,
                                style: AppTextStyle.titleLarge,
                              ),
                              const SizedBox(height: 16.0),
                              const Text(
                                "Explore our metal collection and be among the first to shop. Shop now and add a touch of metal to your style!",
                                textAlign: TextAlign.center,
                                style: AppTextStyle.bodySmall,
                              ),

                              const SizedBox(height: 16.0),

                              Button("Shop Now", valueKey: const ValueKey('btnShopNow'),
                                  onPressed: () {
                                    locator<NavigationService>().pushNamed(Routes.deals);
                                  }
                              )
                            ],
                          ),
                        ),
                    )
                   else Flexible(
                    child: AnimationLimiter(
                      child: ListView.separated(
                        itemCount: viewModel.ordersList?.length ?? 0,
                        padding: const EdgeInsets.all(15),
                        separatorBuilder: (context, index) {
                          return VerticalSpacing.d15px();
                        },
                        itemBuilder: (context, index) {
                          Order order = viewModel.ordersList![index];
                          return StaggeredAnimation.staggeredList(
                              index: index,
                              child: GestureDetector(
                                onTap: () {
                                  locator<NavigationService>().pushNamed(Routes.myOrderDetails, arguments: { "order_id": order.orderId, "from_success": false });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: AppStyle.elevatedCardShadow,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "#${order.orderId}",
                                                style: AppTextStyle.titleMedium,
                                              ),
                                            ),
                                            const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16,
                                            )
                                          ],
                                        ),
                                      ),

                                      AppStyle.dottedDivider,

                                      ListView.separated(
                                          primary: false,
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                          itemBuilder: (context, index) {
                                            OrderTotalSummary summary = order.orderSummary![index];

                                            return Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                              child: Row(
                                                children: [
                                                  Expanded(child: Text(summary.key ?? '', style: AppTextStyle.bodyMedium,)),
                                                  Expanded(child: Text(summary.value ?? '', style: AppTextStyle.bodyMedium.copyWith(color: summary.textColor))),
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return AppStyle.customDivider;
                                          },
                                          itemCount: order.orderSummary?.length ?? 0
                                      ),

                                    ],
                                  ),
                                ),
                              ));
                        },
                      ),
                    ),
                  ),

                ],
              )
            ),
          ),
        );
      },
    );
  }
}
