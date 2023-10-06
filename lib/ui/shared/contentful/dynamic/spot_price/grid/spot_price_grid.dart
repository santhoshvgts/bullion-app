
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bullion/core/models/spot_price.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/shared/chart/spotprice_sparkline.dart';
import 'package:bullion/ui/shared/contentful/dynamic/spot_price/spot_price_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SpotPriceGrid extends VGTSBuilderWidget<SpotPriceViewModel> {

  final dynamic spotPriceList;

  SpotPriceGrid(this.spotPriceList);

  @override
  void onViewModelReady(SpotPriceViewModel viewModel) {
    viewModel.init(spotPriceList);
  }

  @override
  SpotPriceViewModel viewModelBuilder(BuildContext context) => SpotPriceViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, SpotPriceViewModel viewModel, Widget? child) {
    return GridView.builder(
        primary: false,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: viewModel.spotPriceList!.isEmpty
            ? 4
            : viewModel.spotPriceList!.length,
        padding: const EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15),
        itemBuilder: (context, index) {
          if (viewModel.spotPriceList!.isEmpty) {
            return Container(
              decoration: BoxDecoration(
                  color: AppColor.white,
                  boxShadow: AppStyle.mildCardShadow,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              width: double.infinity,
              child: ShimmerEffect(
                  borderRadius:
                  const BorderRadius.all(Radius.circular(10))),
            );
          }

          return _SpotPriceTile(viewModel.spotPriceList![index],
              graphLoading: viewModel.graphLoading,
              onPressed: () {
                //TODO FILTERSERVICE
                // locator<FilterService>().spotPriceTag = viewModel.spotPriceList![index].metalName;
                locator<NavigationService>().pushNamed("${Routes.spotPrice}/${viewModel.spotPriceList![index].metalName}",);
              }
          );
        });
  }


}

class _SpotPriceTile extends StatelessWidget {
  final SpotPrice data;
  final VoidCallback? onPressed;
  final bool? graphLoading;

  _SpotPriceTile(this.data, {this.graphLoading, this.onPressed});

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          color: AppColor.white,
          boxShadow: AppStyle.mildCardShadow,
          borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      width: double.infinity,
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [

            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    data.metalName!,
                    textScaleFactor: 1,
                    style: AppTextStyle.subHeader.copyWith(
                        color: data.color, fontWeight: FontWeight.w600),
                  ),

                  const Padding(padding: EdgeInsets.only(top: 5)),

                  Text(data.formattedAsk!,
                      textScaleFactor: 1,
                      style: AppTextStyle.header.copyWith(fontSize: 20)),

                  const Padding(padding: EdgeInsets.only(top: 5)),

                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 2.5, bottom: 5),
                    decoration: BoxDecoration(
                        color: data.change! < 0 ? AppColor.red.withOpacity(0.1) : AppColor.green.withOpacity(0.1),
                        borderRadius: const BorderRadius.all(Radius.circular(25))
                    ),
                    child: AutoSizeText( "${data.change! < 0 ? "-" : "+"} ${data.formattedChange}  (${data.changePct! > 0 ? "+" : ""}${data.changePct}%)",
                        textScaleFactor: 1,
                        style: AppTextStyle.label.copyWith(fontWeight: FontWeight.w600, color: data.change! < 0 ? AppColor.red : AppColor.green)),
                  ),


                ],
              ),
            ),

            Flexible(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                  child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: SpotPriceSparkLineView(data.metalName, data.chartData, loading: graphLoading,),
                  ),
                )
            ),

            graphLoading! ? Container(
                height: 1,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColor.secondaryText.withOpacity(0.3)),)) : Container()

          ],
        ),
      ),
    );
  }
}
