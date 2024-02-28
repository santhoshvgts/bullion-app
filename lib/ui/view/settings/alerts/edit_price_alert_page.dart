import 'package:bullion/core/models/module/product_item.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/view/settings/alerts/edit_price_alert_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:bullion/ui/widgets/loading_data.dart';
import 'package:bullion/ui/widgets/network_image_loader.dart';
import 'package:bullion/ui/widgets/tap_outside_unfocus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../../core/res/colors.dart';
import '../../../../core/res/styles.dart';
import '../../../../helper/utils.dart';
import '../../../widgets/animated_flexible_space.dart';

class EditPriceAlertPage extends VGTSBuilderWidget<EditPriceAlertViewModel> {
  final ProductOverview? productDetails;

  const EditPriceAlertPage({super.key, this.productDetails});

  @override
  void onViewModelReady(EditPriceAlertViewModel viewModel) {
    viewModel.init(productDetails);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, viewModel, Widget? child) {
    return TapOutsideUnFocus(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
                flexibleSpace: const AnimatedFlexibleSpace.withoutTab(title: "Product Price Alert"),
              ),
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  NetworkImageLoader(
                                    image: viewModel.productOverview?.primaryImageUrl ?? "",
                                    width: 80,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Text(
                                          "${viewModel.productOverview?.name}",
                                          style: AppTextStyle.titleMedium,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              "${viewModel.productOverview?.pricing?.formattedNewPrice.toString()}",
                                              style: AppTextStyle.titleLarge,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              VerticalSpacing.d20px(),

                              const Text("If you wish to receive notifications when this product reaches your specified price, please indicate so. Price Alerts will keep you informed of the buying price on Bullion, but please note that it does not apply to selling.",
                                style: AppTextStyle.bodyMedium,
                              ),

                              const SizedBox(height: 24),
                              Form(
                                key: viewModel.priceAlertGlobalKey,
                                child: EditTextField(
                                  "Target Price",
                                  viewModel.targetPriceFormFieldController,
                                  textStyle: AppTextStyle.titleLarge,
                                  autoFocus: true,
                                  enabled: !viewModel.busy(viewModel.productDetails),
                                ),
                              ),

                              VerticalSpacing.d20px(),

                              Button(
                                "Save",
                                valueKey: const Key("btnUpdate"),
                                width: double.infinity,
                                loading: viewModel.isBusy,
                                disabled: viewModel.busy(viewModel.productDetails),
                                onPressed: () async {
                                  if (viewModel.priceAlertGlobalKey.currentState!.validate()) {
                                    if ((double.tryParse(viewModel.targetPriceFormFieldController.text) ?? 0) == 0) {
                                      Util.showSnackBar("Target Price cannot be less than or equal to zero");
                                      return;
                                    }

                                    bool result = await viewModel.savePriceAlert();
                                    locator<NavigationService>().pop(returnValue: result);
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
              )
            ],
          )
        ),
      ),
    );
  }

  @override
  viewModelBuilder(BuildContext context) {
    return EditPriceAlertViewModel();
  }
}
