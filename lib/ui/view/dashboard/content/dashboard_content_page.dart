import 'package:bullion/services/page_storage_service.dart';
import 'package:bullion/ui/shared/cart/cart_button.dart';
import 'package:bullion/ui/shared/loading_widget.dart';
import 'package:bullion/ui/shared/search_card_section.dart';
import 'package:bullion/ui/view/core/content_wrapper.dart';
import 'package:bullion/ui/view/dashboard/content/dashboard_content_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/ui/widgets/page_will_pop.dart';
import 'package:stacked/stacked.dart';


class DashboardContentPage extends StatelessWidget {

  final String? path;

  const DashboardContentPage({ key, this.path }) : super(key: key);

  // final double _searchBarHeight = 35;
  final double _appBarCollapsedHeight = kToolbarHeight;
  final double _appBarExpandedHeight = 70 + 35; // 115

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardContentViewModel>.reactive(
      onViewModelReady: (viewModel) {
         viewModel.init();
      },
      onDispose: (viewModel){
      },
      builder: (context, viewModel, child) {
        if(path == '/pages/home') {
          return PageWillPop(
            child: Scaffold(
              backgroundColor: AppColor.secondaryBackground,
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.dark,
                child: NestedScrollView(
                    controller: viewModel.scrollController,
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return  <Widget>[
                        SliverLayoutBuilder(
                            builder: (context, constraints) {
                            return SliverAppBar(
                                backgroundColor: AppColor.white,
                                titleSpacing: 0,
                                toolbarHeight: _appBarCollapsedHeight,
                                collapsedHeight: _appBarCollapsedHeight,
                                expandedHeight: _appBarExpandedHeight,
                                floating: false,
                                pinned: true,
                                forceElevated: true,
                                elevation: 1,
                                shadowColor: AppColor.secondaryBackground,
                                flexibleSpace: FlexibleSpaceBar.createSettings(
                                  currentExtent: _appBarCollapsedHeight,
                                  minExtent: _appBarCollapsedHeight,
                                  toolbarOpacity: 1.0,
                                  child: FlexibleSpaceBar(
                                    centerTitle: true,
                                    titlePadding: const EdgeInsets.only(top: 10, bottom: 10.0),
                                    title: SearchCardSection(
                                      rightPadding: viewModel.titlePaddingHorizontal,
                                    ),
                                    background: AppBar(
                                      backgroundColor: AppColor.white,
                                      centerTitle: false,
                                      elevation: 1,
                                      shadowColor: AppColor.secondaryBackground,
                                      title: Image.asset(Images.appLogo, height: 20,),
                                    ),
                                   ),
                                ),
                                actions: const [
                                  CartButton.light(),
                                ],
                              );
                        })
                      ];
                    },
                    body: _BodyContent(path ?? '',key!)
                ),)
              ),
          );
        }
        else {
          return PageWillPop(
            child: Scaffold(
              appBar: _AppBar(path: path ?? ''),
              body: _BodyContent(path ?? '',key!),
            ),
          );
        }

      },
      viewModelBuilder:()=> DashboardContentViewModel(),
    );
  }

}

class _AppBar extends PreferredSize  {

  final String path;

  _AppBar({ required this.path,}) : super(
    preferredSize:  const Size.fromHeight(kToolbarHeight),
    child: AppBar(
      backgroundColor: AppColor.white,
      titleSpacing: 0,
      elevation: 1,
      shadowColor: AppColor.secondaryBackground,
      title: SearchCardSection(rightPadding: 0,),
      actions: const [
        CartButton.light()
      ],
    )
  );

}

//
// class SearchComponent extends ViewModelWidget<DashboardContentViewModel> {
//
//   @override
//   Widget build(BuildContext context, DashboardContentViewModel viewModel) {
//
//     return InkWell(
//       onTap: ()=> viewModel.Search(),
//       child: Container(
//           height: _searchBarHeight,
//           margin: EdgeInsets.only(left: 15, right: viewModel.titlePaddingHorizontal),
//           padding: const EdgeInsets.only(left: 10.0),
//           decoration: BoxDecoration(
//               color: AppColor.white,
//               borderRadius: BorderRadius.circular(50),
//               border: Border.all(color: Colors.black12)
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//
//               const Icon(CupertinoIcons.search, size: 22,),
//
//               HorizontalSpacing.d10px(),
//
//               Padding(
//                 padding: const EdgeInsets.only(bottom:2.0),
//                 child: Text("Search Products and Deals", style: AppTextStyle.text.copyWith(fontSize: 16, color: AppColor.secondaryText), textAlign: TextAlign.center,textScaleFactor: 1,),
//               )
//
//             ],
//           )
//       ),
//     );
//   }
//
// }

class _BodyContent extends ViewModelWidget<DashboardContentViewModel> {

  String path;
  Key pageKey;

  _BodyContent(this.path,this.pageKey);

  @override
  Widget build(BuildContext context, DashboardContentViewModel viewModel) {
    return ContentWrapper(path,
        enableController: false,
        initialValue: locator<PageStorageService>().read(context, pageKey),
        onPageFetched: (pageSetting) {
          viewModel.pageSettings = pageSetting;
          locator<PageStorageService>().write(context, pageKey, viewModel.pageSettings);
          viewModel.notifyListeners();
        }
    );
  }

}

