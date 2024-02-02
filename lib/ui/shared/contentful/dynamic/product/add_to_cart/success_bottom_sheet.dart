import 'package:bullion/core/models/module/cart/cart_item.dart';
import 'package:bullion/services/shared/navigator_service.dart';
import 'package:bullion/services/shared/sign_in_request.dart';
import 'package:bullion/ui/shared/contentful/dynamic/product/add_to_cart/add_to_cart_view_model.dart';
import 'package:bullion/ui/shared/contentful/product/product_text_style.dart';
import 'package:flutter/material.dart';
import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/router.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/network_image_loader.dart';

class AddToCartSuccessBottomSheet extends StatelessWidget {

  final AddToCartViewModel viewModel;
  final CartItem? item;

  const AddToCartSuccessBottomSheet(this.viewModel, this.item);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [

        Container(
          padding: const EdgeInsets.all(15),
          child: SafeArea(
            child: Column(
              children: [

                Row(
                  children: [

                    NetworkImageLoader(image: viewModel.productDetails!.overview!.primaryImageUrl, height: 60, width: 60,),

                    HorizontalSpacing.d15px(),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(viewModel.productDetails!.overview!.name!,  style: AppTextStyle.titleMedium,),

                          VerticalSpacing.d5px(),

                          Row(
                            children: [
                              Expanded(child: Text("${item!.formattedUnitPrice} x ${item!.quantity}", style: AppTextStyle.labelLarge, overflow: TextOverflow.ellipsis,)),

                              Text("${item!.formattedSubTotal}", style: AppTextStyle.labelLarge, overflow: TextOverflow.ellipsis,)
                            ],
                          )

                        ],
                      ),
                    ),


                  ],
                ),

                VerticalSpacing.d15px(),

                Row(
                  children: [

                    Expanded(
                      child: Button.outline(
                          "View Cart",
                          valueKey: const Key('btnViewCart'),
                          textStyle: AppTextStyle.titleSmall.copyWith(color: AppColor.text),
                          borderColor: AppColor.title,
                          onPressed: (){
                            Navigator.pop(context);
                            locator<NavigationService>().pushNamed(Routes.viewCart);
                          }
                      ),
                    ),

                    HorizontalSpacing.custom(value: 10.0),

                    Expanded(
                      child: Button(
                          "Checkout",
                          valueKey: const Key('btnCheckout'),
                          color: AppColor.secondary,
                          borderColor: AppColor.secondary,
                          onPressed: () async {
                            locator<DialogService>().dialogComplete(AlertResponse());
                            if (!locator<AuthenticationService>().isAuthenticated) {

                              bool authenticated = await signInRequest(
                                  Images.iconCartBottom,
                                  title: "Checkout",
                                  content: "Login or Create a free BULLION.com account for fast checkout and easy access to order history.",
                                  showGuestLogin: true
                              );
                              if (!authenticated) return;
                            }
                            locator<NavigationService>().pushNamed(Routes.checkout);
                          }
                      ),
                    ),

                ],)

              ],
            ),
          ),
        ),

      ],
    );
  }

}