import 'package:bullion/core/constants/display_type.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/helper/utils.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/services/shared/sign_in_request.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter/material.dart';

import 'add_to_cart/add_to_cart.dart';

class BottomActionCard extends StatelessWidget {
  final ProductDetails? productDetails;

  BottomActionCard(this.productDetails, { Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (productDetails!.overview!.productAction == ProductInfoDisplayType.addToCart) {
      return AddToCartSection(productDetails, key: ValueKey("sectionAddToCart${productDetails?.overview?.orderMin}"));
    } else if (productDetails!.overview!.alertMe!) {
      return _AlertButton("Setup AlertMe!®", onTap: () async {
        if (!locator<AuthenticationService>().isAuthenticated){
          bool authenticated = await signInRequest(Images.iconAlertBottom, title: "AlertMe!®", content: "Add you Item to Price Alert. Get live update of item availability.");
          if (!authenticated) return;
        }
        await locator<NavigationService>().pushNamed(Routes.editAlertMe, arguments: { "productDetails": productDetails?.overview });
      });
    } else {
      return _Button(productDetails!.overview!.availabilityText);
    }
  }
}

class _AlertButton extends StatelessWidget {
  final String title;
  final Function? onTap;

  _AlertButton(this.title, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: AppColor.white, boxShadow: AppStyle.topShadow),
        child: Button.outline(title,
            valueKey: const Key('btnSaveAlert'),
            width: double.infinity,
            textStyle: AppTextStyle.titleSmall.copyWith(color: AppColor.primary),
            borderColor: AppColor.primary,
            onPressed: onTap as void Function()?),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final String? title;

  _Button(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Button(title,
          valueKey: const Key('btn'),
          width: double.infinity,
          textStyle: AppTextStyle.titleSmall.copyWith(color: AppColor.black20),
          color: Colors.black12,
          borderColor: Colors.transparent,
          onPressed: () {}
      ),
    );
  }
}
