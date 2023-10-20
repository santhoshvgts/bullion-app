import 'package:bullion/core/models/chart/spot_price.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/shared/contentful/dynamic/spot_price/chart_view/area_chart_widget.dart';
import 'package:bullion/ui/shared/contentful/dynamic/spot_price/chart_view/spot_price_chart_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  SpotPriceChartViewModel viewModelBuilder(BuildContext context) =>
      SpotPriceChartViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale,
      SpotPriceChartViewModel viewModel, Widget? child) {
    return SafeArea(
      child: Container(
        color: AppColor.white,
        margin: const EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 10)),

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

                Container(
                  alignment: Alignment.center,
                  height: 55,
                  color: AppColor.metalColor(
                          viewModel.spotPriceChartData?.metalName ?? '')
                      .withOpacity(0.2),
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    itemCount: viewModel.spotPriceTimeRangeFilters.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          viewModel.setSelectedTimePeriod(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: index == viewModel.spotTimeRangeSelectedIndex
                                ? viewModel.spotPriceChartData!.color
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            vertical: 7,
                            horizontal:
                                index == viewModel.spotTimeRangeSelectedIndex
                                    ? 15
                                    : 10,
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            viewModel
                                .spotPriceTimeRangeFilters[index].displayName,
                            textScaleFactor: 1,
                            style: TextStyle(
                              color:
                                  index == viewModel.spotTimeRangeSelectedIndex
                                      ? AppColor.white
                                      : AppColor.text,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            if (viewModel.spotPriceChartData!.metalId! >= 1 &&
                viewModel.spotPriceChartData!.metalId! <= 4)
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Button.outline('Create Spot Price Alert',
                    textStyle: AppTextStyle.titleLarge
                        .copyWith(color: AppColor.secondary),
                    borderColor: AppColor.secondary,
                    valueKey: const Key('btnShopNow'),
                    width: double.infinity,
                    onPressed: () => viewModel.onCreateSpotPriceClick()),
              ),

            if (viewModel.spotPriceChartData!.metalId! >= 1 &&
                viewModel.spotPriceChartData!.metalId! <= 4)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 7),
                color: AppColor.secondaryBackground,
                margin: const EdgeInsets.only(top: 15),
                child: Row(
                  children: <Widget>[
                    _buildSubItem("Bid Price",
                        viewModel.spotPriceChartData!.formattedBid),
                    Expanded(child: Container()),
                    _buildSubItem("Ask Price",
                        viewModel.spotPriceChartData!.formattedAsk),
                  ],
                ),
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
            textScaleFactor: 1,
            style: const TextStyle(
              fontSize: 13,
              color: AppColor.text,
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 5)),
          Text(
            value == null ? "" : value,
            textScaleFactor: 1,
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

    return Column(
      children: <Widget>[
        _BreakUpItem("Per Ounce", spotPrice.formattedAsk,
            spotPrice.formattedChange, spotPrice.change),
        _BreakUpItem("Per Gram", spotPrice.formattedPerGramAsk,
            spotPrice.formattedPerGramChange, spotPrice.change),
        _BreakUpItem(
          "Per Kilo",
          spotPrice.formattedPerKiloAsk,
          spotPrice.formattedPerKiloChange,
          spotPrice.change,
        ),
      ],
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
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColor.divider))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              itemKey,
              textScaleFactor: 1,
              style: AppTextStyle.titleSmall
                  .copyWith(fontWeight: FontWeight.normal, fontSize: 16),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Expanded(
            child: Text(
              value!,
              textScaleFactor: 1,
              style: AppTextStyle.titleSmall,
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "${changeValue! < 0 ? "-" : "+"} ${formattedChange!}",
                  textScaleFactor: 1,
                  style: AppTextStyle.titleSmall.copyWith(
                      color: changeValue! < 0 ? AppColor.red : AppColor.green),
                ),

                // Padding(padding: EdgeInsets.only(left: 5)),

                // Icon(changeValue < 0 ? Icons.arrow_drop_down : Icons.arrow_drop_up, color: changeValue < 0 ? AppColor.red : AppColor.green,),
              ],
            ),
          )
        ],
      ),
    );
  }
}
