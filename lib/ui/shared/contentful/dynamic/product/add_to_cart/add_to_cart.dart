import 'package:bullion/core/models/module/product_detail/product_detail.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'add_to_cart_view_model.dart';

class AddToCartSection extends VGTSBuilderWidget<AddToCartViewModel> {
  ProductDetails? productDetails;

  AddToCartSection(this.productDetails, { Key? key }) : super(key: key);

  @override
  AddToCartViewModel viewModelBuilder(BuildContext context) =>
      AddToCartViewModel();

  @override
  void onViewModelReady(AddToCartViewModel viewModel) {
    viewModel.init(productDetails);
  }

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, AddToCartViewModel viewModel, Widget? child) {
    return Wrap(
      children: [
        if (viewModel.isBusy)
          const SizedBox(
            height: 2,
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColor.primary),
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: const BoxDecoration(
            color: AppColor.white,
          ),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: AppColor.border)
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 40,
                            child: IconButton(
                              icon: const Icon(
                                Icons.remove,
                                size: 20,
                                color: AppColor.text,
                              ),
                              onPressed: () => viewModel.decrease(),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 42,
                              child: EditTextField(
                                "",
                                viewModel.qtyController,
                                key: const ValueKey("txtQuantity"),
                                textAlign: TextAlign.center,
                                textInputAction: TextInputAction.done,
                                isInputDecorationNone: true,
                                textStyle: AppTextStyle.titleSmall,
                                padding: EdgeInsets.zero,
                                onChanged: (val) {
                                  if (viewModel.qtyValidate) viewModel.qtyValidate = false;
                                  viewModel.triggerProductUpdateEvent(int.tryParse(val) ?? 1);
                                },
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 40,
                            child: IconButton(
                              icon: const Icon(
                                Icons.add,
                                size: 20,
                                color: AppColor.text,
                              ),
                              onPressed:
                              viewModel.qtyValue >= 9999 ? null : () => viewModel.increase(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  HorizontalSpacing.d5px(),

                  Expanded(
                    flex: 5,
                    child: Button("Add to Cart",
                        width: double.infinity,
                        color: AppColor.secondary,
                        height: 45,
                        borderColor: AppColor.secondary,
                        valueKey: const Key("btnAddToCart"), onPressed: () {
                      viewModel.addProduct(viewModel);
                    }),
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
