
import 'package:bullion/core/models/module/checkout/payment_method.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/helper/utils.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/view/checkout/payment_method/payment_method_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/apmex_html_widget.dart';
import 'package:bullion/ui/widgets/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentMethodSection extends VGTSBuilderWidget<PaymentMethodViewModel> {

  const PaymentMethodSection({ Key? key }) : super(key: key);

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, PaymentMethodViewModel viewModel, Widget? child) {
    if (viewModel.isBusy) {
      return Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.divider, width: 0.5),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            children: [1,2,3,4].map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ShimmerEffect(
                height: 80,
                width: double.infinity,
              ),
            )).toList(),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.divider, width: 0.5),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
                padding: EdgeInsets.only(left: 15, top: 10),
                child: Text('Payment Method', style: AppTextStyle.titleMedium)
            ),
            Padding(
                padding: const EdgeInsets.only(left: 15, top: 2),
                child: Text('Please choose payment method', style: AppTextStyle.labelMedium.copyWith(fontWeight: FontWeight.w400,color: AppColor.secondaryText))
            ),


            Stack(
              children: [

                ListView.separated(
                    itemCount: viewModel.paymentMethodList?.length ?? 0,
                    primary: false,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    separatorBuilder: (context, index){
                      return AppStyle.customDivider;
                    },
                    itemBuilder: (context, index)  {
                      PaymentMethod paymentMethod = viewModel.paymentMethodList![index];
                      return PaymentMethodCardItem(
                          paymentMethod,
                          onPressed: (paymentMethod) {
                            viewModel.onPaymentClick(paymentMethod);
                          }
                      );
                    }
                ),

                if (viewModel.isLoading || viewModel.isUserPaymentLoading)
                  Positioned.fill(
                    child: Container(
                      color: AppColor.white.withOpacity(0.7),
                      child: const Center(
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(AppColor.primary),
                          ),
                        ),
                      ),
                    ),
                  )

              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  PaymentMethodViewModel viewModelBuilder(BuildContext context) {
    return PaymentMethodViewModel();
  }

}

class PaymentMethodCardItem extends StatelessWidget {

  final PaymentMethod item;
  final Function(PaymentMethod)? onPressed;

  const PaymentMethodCardItem(this.item, {super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key("cardPaymentItem${item.paymentMethodId}"),
      onTap: !item.isEnabled! ? null : () => onPressed!(item),
      child: Opacity(
        opacity: !item.isEnabled! ? 0.7 : 1,
        child: Container(
            color: AppColor.white,
            padding: const EdgeInsets.only(left: 15, right: 5, top: 5, bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                item.icon == null ? Container() : Icon(FAIcon(item.icon), color: !item.isEnabled! ? AppColor.disabled : AppColor.primary, size: 22,),

                HorizontalSpacing.d15px(),

                // Radio(value: item.paymentMethodId, groupValue: item.isSelected ? item.paymentMethodId : null, activeColor: AppColor.primary, onChanged: (value) => onPressed(item)),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name ?? "",style: AppTextStyle.titleMedium,),

                      VerticalSpacing.d2px(),

                      Text(item.shortDescription ?? '-',style: AppTextStyle.bodyMedium,),

                      if(!item.isEnabled!)
                        Container(
                          margin: const EdgeInsets.only(top: 7),
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 1, bottom: 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: AppColor.disabled)
                          ),
                          child: const Text("Unavailable",  style: AppTextStyle.bodyMedium,),
                        )

                    ],
                  ),
                ),

                if (item.description != null)
                  IconButton(
                      onPressed: () => locator<DialogService>().showBottomSheet(title: item.name, child: _PaymentSummaryHelpText(item.description)),
                      icon: const Icon(
                        Icons.info_outline,
                        size: 18,
                        color: AppColor.text,
                      )
                  ),

              ],
            )
        ),
      ),
    );
  }

}

class _PaymentSummaryHelpText extends StatelessWidget {

  final String? helpText;

  const _PaymentSummaryHelpText(this.helpText);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: ApmexHtmlWidget(
          helpText,
          textStyle: AppTextStyle.bodyMedium,
        ),
      ),
    );
  }
}
