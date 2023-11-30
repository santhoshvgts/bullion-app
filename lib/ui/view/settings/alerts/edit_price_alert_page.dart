import 'package:bullion/core/models/alert/product_alert_response_model.dart';
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

  const EditPriceAlertPage({super.key, this.productAlert});

  @override
  void onViewModelReady(EditPriceAlertViewModel viewModel) {
    viewModel.init(productAlert);
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
                  const AnimatedFlexibleSpace(title: "Price Alert"),
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
                                Form(
                                  key: viewModel.priceAlertGlobalKey,
                                  child: EditTextField(
                                    "Target Price",
                                    viewModel.targetPriceFormFieldController,
                                    textStyle: AppTextStyle.titleLarge,
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
                "Update",
                valueKey: const Key("btnUpdate"),
                borderRadius: BorderRadius.circular(24),
                onPressed: () async {
                  if (viewModel.priceAlertGlobalKey.currentState!
                      .validate()) {
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
