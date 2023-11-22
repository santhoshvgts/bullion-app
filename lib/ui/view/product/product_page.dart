import 'package:bullion/core/constants/module_type.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/ui/shared/cart/cart_button.dart';
import 'package:bullion/ui/shared/contentful/banner/banner_ui_container.dart';
import 'package:bullion/ui/shared/contentful/dynamic/dynamic_module.dart';
import 'package:bullion/ui/shared/contentful/dynamic/product/product_overview_section.dart';
import 'package:bullion/ui/shared/contentful/product/product_module.dart';
import 'package:bullion/ui/shared/contentful/standard/standard_module.dart';
import 'package:bullion/ui/shared/search_card_section.dart';
import 'package:bullion/ui/view/product/product_page_viewmodel.dart';
import 'package:bullion/ui/widgets/page_will_pop.dart';
import 'package:bullion/ui/widgets/tap_outside_unfocus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ProductPage extends StatelessWidget with WidgetsBindingObserver {
  final ProductDetails? productDetails;
  final String? targetUrl;

  late BuildContext _buildContext;

  ProductPage({Key? key, required this.productDetails, this.targetUrl})
      : super(key: key);

  late ProductPageViewModel _productPageViewModel;

  @override
  Widget build(BuildContext context) {
    _buildContext = context;

    return ViewModelBuilder.reactive(
      onViewModelReady: (dynamic viewModel) {
        _productPageViewModel = viewModel;
        WidgetsBinding.instance.addObserver(this);
      },
      onDispose: (ProductPageViewModel viewModel) {
        WidgetsBinding.instance.removeObserver(this);
      },
      builder: (context, ProductPageViewModel viewModel, child) {
        return PageWillPop(
          child: Scaffold(
            backgroundColor: AppColor.white,
            appBar: AppBar(
              elevation: 0,
              titleSpacing: 0,
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.search),
                ),
                const CartButton.light()
              ],
            ),
            body: SafeArea(
              top: false,
              child: RefreshIndicator(
                onRefresh: () async {
                  await viewModel.init(viewModel.productDetail, targetUrl!);
                },
                child: Container(
                  color: AppColor.white,
                  child: TapOutsideUnFocus(
                    child: Stack(
                      children: [
                        if (viewModel.productDetail != null ||
                            viewModel.pageSetting != null)
                          Column(
                            children: [
                              Flexible(
                                child: SizedBox(
                                  height: double.infinity,
                                  child: SingleChildScrollView(
                                    controller: viewModel.scrollController,
                                    physics: const ClampingScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    child: Column(children: [
                                      if (viewModel.isBusy)
                                        ProductOverviewSection(
                                          viewModel.productDetail,
                                          "",
                                        )
                                      else
                                        ...viewModel.modules?.map((module) {
                                              switch (module?.moduleType) {
                                                case ModuleType.dynamic:
                                                  return DynamicModule(
                                                    module,
                                                    viewModel.pageSetting,
                                                  );

                                                case ModuleType.standard:
                                                  return StandardModule(module);

                                                case ModuleType.product:
                                                case ModuleType.productList:
                                                  return ProductModule(
                                                    module,
                                                  );

                                                case ModuleType.banner:
                                                  return BannerModule(module);

                                                default:
                                                  return Container();
                                              }
                                            }).toList() ??
                                            [],
                                    ]),
                                  ),
                                ),
                              ),
                              // BottomActionCard(viewModel.productDetail)
                            ],
                          )
                        else
                          const SizedBox(
                              height: double.infinity,
                              child: Center(
                                child: SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                        AppColor.primary),
                                    strokeWidth: 2,
                                  ),
                                ),
                              )),
                        // Positioned(
                        //   left: 0,
                        //   right: 0,
                        //   top: 0,
                        //   child: AnimatedOpacity(
                        //     duration: const Duration(milliseconds: 200),
                        //     opacity: viewModel.showAppBar ? 1 : 0,
                        //     child: AppBar(
                        //       elevation: 1,
                        //       titleSpacing: 0,
                        //       centerTitle: true,
                        //       title: SearchCardSection(
                        //         leftPadding: 0,
                        //         rightPadding: 0,
                        //       ),
                        //       actions: const [CartButton.light()],
                        //     ),
                        //   ),
                        // ),
                        // Positioned(
                        //   left: 0,
                        //   right: 0,
                        //   top: 0,
                        //   child: AnimatedOpacity(
                        //     duration: const Duration(milliseconds: 200),
                        //     opacity: viewModel.showAppBar ? 0 : 1,
                        //     child: AppBar(
                        //       backgroundColor: Colors.transparent,
                        //       elevation: 0,
                        //       actions: const [CartButton.light()],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => ProductPageViewModel(productDetails, targetUrl!),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      print('Product Page state: Paused audio playback');
    }
    if (state == AppLifecycleState.resumed) {
      if (ModalRoute.of(_buildContext)?.isCurrent == true) {
        _productPageViewModel.init(productDetails, targetUrl!);
      }
      print('Product Page state: Resumed audio playback');
    }
  }
}
