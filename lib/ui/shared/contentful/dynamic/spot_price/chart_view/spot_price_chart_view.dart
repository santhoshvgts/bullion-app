import 'package:bullion/core/models/chart/spot_price.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/shared/contentful/dynamic/spot_price/chart_view/area_chart_widget.dart';
import 'package:bullion/ui/shared/contentful/dynamic/spot_price/chart_view/spot_price_chart_view_model.dart';
import 'package:bullion/ui/shared/contentful/dynamic/spot_price/chart_view/spot_price_header.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../core/models/chart/chart_selection_info.dart';

class SpotPriceChartView extends VGTSBuilderWidget<SpotPriceChartViewModel> {
  final String? slug;
  final dynamic spotPrice;
  final Function(String)? onTimeFilterSelect;

  SpotPriceChartView(this.slug, this.spotPrice, {this.onTimeFilterSelect});

  @override
  void onViewModelReady(SpotPriceChartViewModel viewModel) {
    viewModel.init(slug, spotPrice);
  }

  @override
  SpotPriceChartViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SpotPriceChartViewModel();

  @override
  Widget viewBuilder(
    BuildContext context,
    AppLocalizations locale,
    SpotPriceChartViewModel viewModel,
    Widget? child,
  ) {
    return SafeArea(
      child: Container(
        color: AppColor.white,
        margin: const EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            StreamBuilder(
              stream: viewModel.trackedSpotController.stream,
              initialData: viewModel.chartSelectionInfoModel,
              builder: (context, snapshot) {
                return SpotPriceHeader(viewModel,
                  snapshot.data as ChartSelectionInfoModel,
                );
              },
            ),

            // BODY CONTENT
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
//              CHARTS
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(right: 10),
                    child: AreaChartWidget(
                      viewModel.spotPriceChartData!.chartData,
                      viewModel
                          .spotPriceTimeRangeFilters[
                              viewModel.spotTimeRangeSelectedIndex]
                          .value,
                      viewModel.selectedSpotPriceMetal,
                    ),
                  ),
                ),

                VerticalSpacing.d20px(),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Row(
                    children: [
                      ...viewModel.spotPriceTimeRangeFilters
                          .asMap()
                          .map((index, e) {
                            return MapEntry(
                              index,
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    viewModel.setSelectedTimePeriod(index);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: index ==
                                              viewModel
                                                  .spotTimeRangeSelectedIndex
                                          ? AppColor.secondaryMetalColor(
                                              viewModel.spotPriceChartData
                                                      ?.metalName ??
                                                  '')
                                          : AppColor.secondaryBackground,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    margin: index <
                                            viewModel.spotPriceTimeRangeFilters
                                                    .length -
                                                1
                                        ? const EdgeInsets.only(right: 5)
                                        : null,
                                    child: Text(
                                      viewModel.spotPriceTimeRangeFilters[index]
                                          .displayName,
                                      
                                      style: AppTextStyle.labelMedium.copyWith(
                                        color: index ==
                                                viewModel
                                                    .spotTimeRangeSelectedIndex
                                            ? AppColor.white
                                            : AppColor.text,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })
                          .values
                          .toList()
                    ],
                  ),
                ),

                VerticalSpacing.d10px(),
              ],
            ),

            if (viewModel.spotPriceChartData!.metalId! >= 1 &&
                viewModel.spotPriceChartData!.metalId! <= 4)
              _SpotPriceBreakUp(viewModel: viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildSubItem(String key, String? value) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: <Widget>[
          Text(
            key,
            
            style: const TextStyle(
              fontSize: 13,
              color: AppColor.text,
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 5)),
          Text(
            value ?? "",
            
            style: const TextStyle(
                fontSize: 14,
                color: AppColor.black,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _SpotPriceBreakUp extends StatelessWidget {
  const _SpotPriceBreakUp({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final SpotPriceChartViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    SpotPrice spotPrice = viewModel.spotPriceChartData!;

    return Container(
      color: AppColor.secondaryBackground,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Text(
          //   "${spotPrice.metalName} Spot Prices (${viewModel.selectedFilterValue.displayName})",
          //   
          //   style: AppTextStyle.titleMedium,
          // ),
          // VerticalSpacing.d5px(),
          // Text(
          //   "${spotPrice.formattedLastUpdated}",
          //   
          //   style: AppTextStyle.bodySmall,
          // ),
          // VerticalSpacing.d15px(),
          _BreakUpItem(
            "Per Ounce",
            spotPrice.formattedAsk,
            spotPrice.formattedChange,
            spotPrice.change,
          ),
          VerticalSpacing.d10px(),
          _BreakUpItem(
            "Per Gram",
            spotPrice.formattedPerGramAsk,
            spotPrice.formattedPerGramChange,
            spotPrice.change,
          ),
          VerticalSpacing.d10px(),
          _BreakUpItem(
            "Per Kilo",
            spotPrice.formattedPerKiloAsk,
            spotPrice.formattedPerKiloChange,
            spotPrice.change,
          ),
        ],
      ),
    );
  }
}

class _BreakUpItem extends StatelessWidget {
  final String itemKey;
  final String? value;
  final String? formattedChange;
  final double? changeValue;

  _BreakUpItem(
      this.itemKey, this.value, this.formattedChange, this.changeValue);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemKey,
                  
                  style: AppTextStyle.labelMedium.copyWith(
                    color: AppColor.secondaryText,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      value!,
                      
                      style: AppTextStyle.titleMedium,
                    ),
                    Text(
                      "${formattedChange!}",
                      
                      style: AppTextStyle.titleMedium.copyWith(
                          color:
                              changeValue! < 0 ? AppColor.red : AppColor.green),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetalChipItem extends StatelessWidget {
  SpotPrice item;

  _MetalChipItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColor.metalColor(item.metalName!),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.metalName ?? '',
            
            style: AppTextStyle.bodySmall,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                item.formmatedChangePercentage,
                
                style: AppTextStyle.labelSmall.copyWith(
                  color: item.changeColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                item.formattedChange!,
                
                style: AppTextStyle.labelSmall.copyWith(
                  color: item.changeColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
