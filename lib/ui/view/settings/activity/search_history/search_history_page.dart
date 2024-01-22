import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/view/settings/activity/search_history/search_history_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/page_will_pop.dart';
import 'package:bullion/ui/widgets/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/models/module/product_item.dart';

class SearchHistoryPage extends VGTSBuilderWidget<SearchHistoryViewModel> {

  @override
  SearchHistoryViewModel viewModelBuilder(BuildContext context) => SearchHistoryViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, SearchHistoryViewModel viewModel, Widget? child) {
    return PageWillPop(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Search History", textScaleFactor: 1, style: AppTextStyle.titleMedium.copyWith(color: AppColor.text, fontFamily: AppTextStyle.fontFamily),),
        ),
        backgroundColor: AppColor.white,
        body: RefreshIndicator(
          onRefresh: () async {
            return await viewModel.fetchSearchHistory();
          },
          child: SizedBox(
            height: double.infinity,
            child: !viewModel.isBusy && viewModel.list?.isEmpty == true ?
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 1.5,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Images.cartIcon,
                    width: 150,
                  ),
                  const SizedBox(height: 32.0),
                  const Text(
                    "Search History",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.titleLarge,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    "You don’t have any search history to display.",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.bodySmall,
                  ),
                ],
              ),
            )
            : ListView.separated(
                itemCount: viewModel.isBusy ? 4 : viewModel.list?.length ?? 0,
                padding: EdgeInsets.symmetric(vertical: 10),
                separatorBuilder: (context, index) {
                  return AppStyle.customDivider;
                },
                itemBuilder: (context, index) {
                  if (viewModel.isBusy) {
                    return ShimmerEffect(height: 130);
                  }

                  ProductOverview? detail = viewModel.list?[index];

                  return InkWell(
                    onTap: (){
                      locator<NavigationService>().pushNamed(detail?.targetUrl ?? '');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Text(detail?.name ?? '', textScaleFactor: 1, style: AppTextStyle.bodyMedium.copyWith(color: AppColor.text),),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

}