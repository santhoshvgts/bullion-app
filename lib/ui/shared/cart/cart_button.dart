import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/ui/shared/cart/cart_button_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartButton extends VGTSBuilderWidget<CartButtonViewModel> {
  final Widget icon;

  const CartButton({super.key})
      : icon = const Icon(
          CupertinoIcons.cart,
          color: Colors.white,
          size: 18,
        );

  const CartButton.light({super.key})
      : icon = const Icon(
          CupertinoIcons.cart,
          size: 18,
        );

  @override
  void onViewModelReady(CartButtonViewModel viewModel) {
    viewModel.init();
  }

  @override
  CartButtonViewModel viewModelBuilder(BuildContext context) =>
      CartButtonViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, CartButtonViewModel viewModel, Widget? child) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: SizedBox(
        width: 40,
        height: 40,
        child: IconButton(
          onPressed: () {
            locator<NavigationService>().pushNamed(Routes.viewCart);
          },
          padding: EdgeInsets.zero,
          icon: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: CircleAvatar(
                  backgroundColor: AppColor.secondaryBackground,
                  child: icon,
                )
              ),
              if (viewModel.totalCartItem != 0)
                Positioned(
                  right: 0,
                  top: -5,
                  child: Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColor.primary),
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      viewModel.totalCartItem.toString(),

                      style: AppTextStyle.bodyMedium
                          .copyWith(fontSize: 12, color: AppColor.white),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
