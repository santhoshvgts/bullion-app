import 'package:bullion/ui/view/checkout/views/review_cart/review_cart_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ReviewCartView extends VGTSBuilderWidget<ReviewCartViewModel> {
  const ReviewCartView({Key? key}) : super(key: key);

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, ReviewCartViewModel viewModel, Widget? child) {
    return const Scaffold(
      body: Center(child: Text('Review CART PAGE')),
    );
  }

  @override
  ReviewCartViewModel viewModelBuilder(BuildContext context) {
    return ReviewCartViewModel();
  }
}