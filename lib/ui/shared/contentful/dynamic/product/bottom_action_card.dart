import 'package:bullion/core/constants/display_type.dart';
import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'add_to_cart/add_to_cart.dart';

class BottomActionCard extends StatelessWidget {

  final ProductDetails? productDetails;

  BottomActionCard(this.productDetails);

  @override
  Widget build(BuildContext context) {

    if(productDetails!.overview!.productAction == ProductInfoDisplayType.addToCart) {
      return AddToCartSection(productDetails);
    } else if (productDetails!.overview!.alertMe!)
      return _AlertButton("Setup AlertMe!®", onTap:() async {

        // TODO - ALERT ME AUTHENTICATION VALIDATION
          // if (!locator<AuthenticationService>().isAuthenticated){
          //   bool authenticated = await signInRequest(Images.iconAlertBottom, title: "AlertMe!®", content: "Add you Item to Price Alert. Get live update of item availability.");
          //   if (!authenticated) return;
          // }

          // await locator<DialogService>().showBottomSheet(title: "AlertMe!®", child: AlertMeBottomSheet(productDetails, showViewButton: true,));
        }
      );
    else
      return _Button(productDetails!.overview!.availabilityText);

  }
}


class _AlertButton extends StatelessWidget {

  final String title;
  final Function? onTap;

  _AlertButton(this.title,{this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: AppColor.white,
              boxShadow: AppStyle.topShadow
          ),
          child: Button.outline(
          title,
          valueKey: const Key('btnSaveAlert'),
          width: double.infinity,
          borderRadius: BorderRadius.circular(7.0),
          textStyle: AppTextStyle.buttonOutline.copyWith(color: AppColor.primaryDark),
          borderColor: AppColor.primaryDark,
          onPressed:onTap as void Function()?),
    );
  }
}


class _Button extends StatelessWidget {

  final String? title;

  _Button(this.title);

  @override
  Widget build(BuildContext context) {
    return Button(
        title,
        valueKey: const Key('btn'),
        width: double.infinity,
        borderRadius: BorderRadius.circular(7.0),
        textStyle: AppTextStyle.buttonOutline.copyWith(color: AppColor.black20),
        color: Colors.black12,
        borderColor: Colors.transparent,
        onPressed: ()=>null);
  }
}