import 'package:bullion/core/models/alert/product_alert_response_model.dart';
import 'package:bullion/core/models/module/product_item.dart' as product_item;
import 'package:bullion/ui/view/settings/alerts/edit_price_alert_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:bullion/ui/widgets/loading_data.dart';
import 'package:bullion/ui/widgets/tap_outside_unfocus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/res/colors.dart';
import '../../../../core/res/styles.dart';
import '../../../../helper/utils.dart';
import '../../../widgets/animated_flexible_space.dart';

class EditPriceAlertPage extends VGTSBuilderWidget<EditPriceAlertViewModel> {
  final ProductAlert? productAlert;
  final product_item.ProductOverview? productDetails;

  const EditPriceAlertPage({super.key, this.productAlert, this.productDetails});

  @override
  void onViewModelReady(EditPriceAlertViewModel viewModel) {
    viewModel.init(productAlert, productDetails);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget viewBuilder(
      BuildContext context, AppLocalizations locale, viewModel, Widget? child) {
    return TapOutsideUnFocus(
      child: Scaffold(
        body: SafeArea(
            child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                icon: Util.showArrowBackward(),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
              ),
              expandedHeight: 100,
              pinned: true,
              flexibleSpace:
                  const AnimatedFlexibleSpace.withoutTab(title: "Price Alert"),
            ),
            SliverToBoxAdapter(
              child: viewModel.isBusy
                  ? LoadingData(
                      loadingStyle: LoadingStyle.LOGO,
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColor.iconBG,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  width: 56,
                                  height: 56,
                                  child: Image.network(viewModel
                                          .isCreatePriceAlert
                                      ? productDetails?.primaryImageUrl ?? ""
                                      : productAlert?.productOverview
                                              ?.primaryImageUrl ??
                                          ""),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${viewModel.isCreatePriceAlert ? productDetails?.name : productAlert?.productOverview?.name}",
                                        style: AppTextStyle.titleMedium,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            "${viewModel.isCreatePriceAlert ? productDetails?.pricing?.formattedNewPrice.toString() : productAlert?.productOverview?.pricing?.formattedNewPrice.toString()}",
                                            style: AppTextStyle.titleLarge,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Form(
                              key: viewModel.priceAlertGlobalKey,
                              child: EditTextField(
                                "Target Price",
                                viewModel.targetPriceFormFieldController,
                                textStyle: AppTextStyle.titleLarge,
                                autoFocus: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            )
          ],
        )),
        bottomNavigationBar: SafeArea(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Button(
                color: AppColor.turtleGreen,
                viewModel.isCreatePriceAlert ? "Create" : "Update",
                valueKey: const Key("btnUpdate"),
                borderRadius: BorderRadius.circular(24),
                onPressed: () async {
                  if (viewModel.priceAlertGlobalKey.currentState!.validate()) {
                    bool result = await viewModel.editMarketAlert();
                    if (result) {
                      Util.showSnackBar(context, "Submitted successfully");
                      Navigator.of(context).pop();
                    }
                  } else {
                    Util.showSnackBar(context, "Fill all the required fields");
                  }
                },
              )),
        ),
      ),
    );
  }

  @override
  viewModelBuilder(BuildContext context) {
    return EditPriceAlertViewModel();
  }
}
