import 'package:bullion/ui/view/checkout/payment_method/payment_method_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:bullion/core/models/module/checkout/payment_method.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/helper/utils.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/widgets/apmex_html_widget.dart';
import 'package:bullion/ui/widgets/page_will_pop.dart';
import 'package:bullion/ui/widgets/shimmer_effect.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked/stacked.dart';

class PaymentMethodPage extends VGTSBuilderWidget<PaymentMethodViewModel> {

  DateTime? currentBackPressTime;

  PaymentMethodPage({super.key});

  @override
  PaymentMethodViewModel viewModelBuilder(BuildContext context) => PaymentMethodViewModel();

  @override
  void onViewModelReady(PaymentMethodViewModel viewModel) {
    viewModel.init();
  }

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, PaymentMethodViewModel viewModel, Widget? child) {
    return DefaultTabController(
      length: 2,
      child: PageWillPop(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Select Payment Method", textScaleFactor: 1,),
            ),
            backgroundColor: AppColor.secondaryBackground,
            body: PaymentMethodListSection()
        ),
      ),
    );
  }
}

class PaymentMethodListSection extends ViewModelWidget<PaymentMethodViewModel> {
  const PaymentMethodListSection({super.key});


  @override
  Widget build(BuildContext context, PaymentMethodViewModel viewModel) {

    if (viewModel.isBusy) {
      return Column(
        children: [1,2,3,4].map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ShimmerEffect(
            height: 100,
            width: double.infinity,
          ),
        )).toList(),
      );
    }

    return Stack(
      children: [

        ListView.separated(
            itemCount: viewModel.paymentMethodList!.length,
            separatorBuilder: (context, index){
              return Container(height: 10,);
            },
            itemBuilder: (context, index)  {
              PaymentMethod paymentMethod = viewModel.paymentMethodList![index];
              return PaymentMethodCardItem(paymentMethod, onPressed: viewModel.onPaymentClick);
            }
        ),

        if (viewModel.isLoading || viewModel.isUserPaymentLoading)
          Container(
            color: AppColor.white.withOpacity(0.7),
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColor.primary),
                ),
              ),
            ),
          )

      ],
    );
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
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              item.icon == null ? Container() : new Icon(FAIcon(item.icon), color: !item.isEnabled! ? AppColor.disabled : AppColor.primary, size: 25,),

              HorizontalSpacing.d15px(),

              // Radio(value: item.paymentMethodId, groupValue: item.isSelected ? item.paymentMethodId : null, activeColor: AppColor.primary, onChanged: (value) => onPressed(item)),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name ?? "",textScaleFactor: 1,style: AppTextStyle.titleMedium,),

                    VerticalSpacing.d2px(),

                    Text(item.shortDescription ?? '-',textScaleFactor: 1,style: AppTextStyle.bodyMedium,),

                    if(!item.isEnabled!)
                      Container(
                        margin: const EdgeInsets.only(top: 7),
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 1, bottom: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: AppColor.disabled)
                        ),
                        child: Text("Unavailable", textScaleFactor: 1, style: AppTextStyle.bodyMedium,),
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
