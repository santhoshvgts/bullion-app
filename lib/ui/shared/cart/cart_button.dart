import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/shared/cart/cart_button_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked/stacked.dart';

class CartButton extends VGTSBuilderWidget<CartButtonViewModel> {
  final String image;

  const CartButton({super.key}) : image = Images.cart_dark;

  const CartButton.light({super.key}) : image = Images.cart;

  @override
  void onViewModelReady(CartButtonViewModel viewModel) {
    viewModel.init();
  }

  @override
  CartButtonViewModel viewModelBuilder(BuildContext context) => CartButtonViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, CartButtonViewModel viewModel, Widget? child) {
    return IconButton(
      onPressed: () {
        locator<NavigationService>().pushNamed(Routes.viewCart);
      },
      padding: EdgeInsets.zero,
      icon: Stack(
        children: [
          Padding(
              padding: EdgeInsets.all(12),
              child: Image.asset(
                image,
                width: 21,
              )),
          if (viewModel.totalCartItem != 0)
            Positioned(
              right: 5,
              child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColor.primary),
                padding: EdgeInsets.all(5),
                child: Text(
                  viewModel.totalCartItem.toString(),
                  textScaleFactor: 1,
                  style: AppTextStyle.body.copyWith(fontSize: 12, color: AppColor.white),
                ),
              ),
            )
        ],
      ),
    );
  }
}
