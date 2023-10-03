import 'package:bullion/services/page_storage_service.dart';
import 'package:bullion/ui/view/core/content_wrapper.dart';
import 'package:bullion/ui/view/dashboard/content/dashboard_content_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/ui/widgets/page_will_pop.dart';
import 'package:stacked/stacked.dart';

const double _searchBarHeight = 35;
const double _appBarCollapsedHeight = kToolbarHeight;
const double _appBarExpandedHeight = 75 + _searchBarHeight; // 115

class DashboardContentPage extends StatelessWidget {

  final String? path;

  DashboardContentPage({ key, this.path }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardContentViewModel>.reactive(
      onViewModelReady: (viewModel) {
         viewModel.init();
      },
      onDispose: (viewModel){
      },
      builder: (context, viewModel, child) {
        if(path == '/pages/home' && viewModel.isAuthenticated) {
          return PageWillPop(
            child: Scaffold(
              backgroundColor: AppColor.secondaryBackground,
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.dark,
                child: SafeArea(
                  child: NestedScrollView(
                      controller: viewModel.scrollController,
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return  <Widget>[
                          SliverLayoutBuilder(
                              builder: (context, constraints) {
                              return SliverAppBar(
                                  backgroundColor: AppColor.secondaryBackground,
                                  titleSpacing: 0,
                                  elevation: 0,
                                  toolbarHeight: _appBarCollapsedHeight,
                                  collapsedHeight: _appBarCollapsedHeight,
                                  expandedHeight: _appBarExpandedHeight,
                                  floating: false,
                                  pinned: true,
                                  flexibleSpace: FlexibleSpaceBar.createSettings(
                                    currentExtent: _appBarCollapsedHeight,
                                    minExtent: _appBarCollapsedHeight,
                                    toolbarOpacity: 1.0,
                                    child: FlexibleSpaceBar(
                                      centerTitle: true,
                                      titlePadding: const EdgeInsets.only(top: 10,bottom: 10.0),
                                      title: _Search(),
                                      background: AnimatedOpacity(
                                        opacity: constraints.scrollOffset < 30.0 ? 1.0 : 0.0,
                                        duration: const Duration(milliseconds: 200),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 15, top: 8.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [

                                              if(viewModel.user?.showclubStatus == true)
                                              Container(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.transparent,
                                                  radius: 23,
                                                  backgroundImage: NetworkImage(viewModel.user?.clubImage ?? '',) ,
                                                ),
                                              ),

                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      viewModel.user?.welcomeMessage ?? '',
                                                      style: AppTextStyle.appBarTitle,
                                                    ),

                                                    Text(
                                                      viewModel.user?.clubStatus ?? '',
                                                      style: AppTextStyle.body,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),),
                                  ),
                                  actions: [
                                    // CartButton(),
                                  ],
                                );
                          })
                        ];
                      },
                      body: _BodyContent(path ?? '',key!)
                  ),
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
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: AppBar(
      backgroundColor: AppColor.secondaryBackground,
      titleSpacing: 0,
      elevation: 0,
      title: _Search(),
      actions: [
        // CartButton()
      ],
    )
  );

}


class _Search extends ViewModelWidget<DashboardContentViewModel> {
  @override
  Widget build(BuildContext context, DashboardContentViewModel viewModel) {
    return InkWell(
      onTap: ()=> viewModel.Search(),
      child: Container(
          height: _searchBarHeight,
          margin: EdgeInsets.only(left: 15,right: viewModel.titlePaddingHorizontal),
          padding: const EdgeInsets.only(left: 10.0),
          decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: const BorderRadius.all(Radius.circular(7.0)),
              border: Border.all(color: Colors.black12)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Image.asset(Images.search,width: 15,),

              HorizontalSpacing.d10px(),

              Padding(
                padding: const EdgeInsets.only(bottom:2.0),
                child: Text("Search Products and Deals",style: AppTextStyle.text.copyWith(fontSize: 16),textAlign: TextAlign.start,textScaleFactor: 1,),
              )

            ],
          )
      ),
    );
  }

}

class _BodyContent extends ViewModelWidget<DashboardContentViewModel> {
  String path;
  Key pageKey;
  _BodyContent(this.path,this.pageKey);
  @override
  Widget build(BuildContext context, DashboardContentViewModel viewModel) {
    return ContentWrapper(path,enableController: false,
        initialValue: locator<PageStorageService>().read(context, pageKey),
        onPageFetched: (pageSetting) {
          viewModel.pageSettings = pageSetting;
          locator<PageStorageService>().write(context, pageKey, viewModel.pageSettings);
          viewModel.notifyListeners();
        }
    );
  }

}

