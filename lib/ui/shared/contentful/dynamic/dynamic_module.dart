import 'package:bullion/core/constants/module_type.dart';
import 'package:bullion/core/models/module/module_settings.dart';
import 'package:bullion/core/models/module/page_settings.dart';
import 'package:bullion/ui/shared/contentful/dynamic/product/product_overview_section.dart';
import 'package:bullion/ui/shared/contentful/dynamic/search/trending_section.dart';
import 'package:bullion/ui/shared/contentful/dynamic/spot_price/chart_view/spot_price_chart_view.dart';
import 'package:bullion/ui/shared/contentful/dynamic/spot_price/grid/spot_price_grid.dart';
import 'package:bullion/ui/shared/contentful/module/module_ui_container.dart';
import 'package:flutter/cupertino.dart';

class DynamicModule extends StatelessWidget {
  final ModuleSettings? _setting;
  final PageSettings? _pageSettings;
  final String? metalName;

  DynamicModule(this._setting, this._pageSettings, {this.metalName});

  @override
  Widget build(BuildContext context) {
    return ModuleUIContainer(
      _setting,
      hideHeadSection: false,
      children: [
        DynamicItem(
          setting: _setting,
          pageSettings: _pageSettings,
          metalName: metalName,
        )
      ],
    );
  }
}

class DynamicItem extends StatelessWidget {
  @required
  final ModuleSettings? setting;
  final PageSettings? pageSettings;
  final String? metalName;

  DynamicItem({required this.setting, this.pageSettings, this.metalName});

  @override
  Widget build(BuildContext context) {
    switch (setting!.itemSource) {
      //
      // case DynamicType.spotPriceStrip:
      //   return SpotPriceStripList(itemData:setting!.dynamicItemData,);
      //
      case DynamicType.spotPrice:
        return SpotPriceGrid(pageSettings!.spotPriceWithPortfolio);

      case DynamicType.spotPriceChart:
        return SpotPriceChartView(
          pageSettings!.slug,
          pageSettings!.spotPrice,
          onTimeFilterSelect: (filterValue) {},
        );

      case DynamicType.productView:
        return ProductOverviewSection(
            pageSettings!.productDetails, pageSettings!.slug);

      // case DynamicType.productDetail:
      //   return ProductDetailSection(pageSettings!.productDetails);

      // case DynamicType.marketNews:
      //   return MarketNewsList(setting!.dynamicItemData,metalName: metalName,);
      //
      // case DynamicType.knowledgeCenter:
      //   return KnowledgeCenterList(setting!.dynamicItemData);
      //
      // case DynamicType.searchHistory:
      //   return SearchHistorySection(setting);
      //
      case DynamicType.searchTrending:
        return TrendingSection(setting);

      // case DynamicType.orderSection:
      //   return OrderCardSection(setting!);
      //
      // case DynamicType.bullionOverView:
      //   return BullionClubOverviewSection(setting!);
      //
      // case DynamicType.authenticationSection:
      //   return LoginSectionCard();

      default:
        return Container();
    }
  }
}
