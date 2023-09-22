import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'add_to_cart_view_model.dart';

class AddToCartSection extends VGTSBuilderWidget<AddToCartViewModel> {

  ProductDetails? productDetails;

  AddToCartSection(this.productDetails);

  @override
  AddToCartViewModel viewModelBuilder(BuildContext context) => AddToCartViewModel();


  @override
  void onViewModelReady(AddToCartViewModel viewModel) {
    viewModel.init(productDetails);
  }

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, AddToCartViewModel viewModel, Widget? child) {
    return Column(
      children: [

        if (viewModel.isBusy)
          const SizedBox(
            height: 2,
            child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColor.primary),),
          ),

        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: AppColor.white,
              boxShadow: AppStyle.topShadow
          ),
          child: Stack(
            children: [

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Expanded(
                    flex: 5,
                    child: EditTextField(
                      "",
                      viewModel.qtyController,
                      prefixIcon: IconButton(icon: const Icon(Icons.remove, size: 20, color: AppColor.text,),
                        onPressed: () => viewModel.decrease(),
                      ),
                      suffixIcon: IconButton(icon: const Icon(Icons.add,size: 20, color: AppColor.text,),
                        onPressed: viewModel.qtyValue >= 9999 ? null : ()=> viewModel.increase(),
                      ),
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.done,
                      onChanged:(val) {
                        if (viewModel.qtyValidate) viewModel.qtyValidate = false;
                      },
                    ),
                  ),

                  Expanded(
                    flex: 7,
                    child: Button("Add to Cart",
                        width: double.infinity,
                        color: AppColor.orange,
                        height: 48,
                        borderColor:AppColor.orange ,
                        valueKey: const Key("btnAddToCart"),
                        onPressed: () {
                          viewModel.addProduct(viewModel);
                        }
                    ),
                  )

                ],
              ),

              if (viewModel.isBusy)
                Container(
                  color: AppColor.white.withOpacity(0.7),
                  height: 50,
                )

            ],
          ),
        ),

      ],
    );
  }

}
