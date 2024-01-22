import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked/stacked.dart';
import '../../../../../core/res/colors.dart';
import '../../../../../core/res/spacing.dart';
import 'credit_card_bottomsheet_view_model.dart';

class CreditCardPageBottomSheet extends VGTSBuilderWidget<CreditCardViewModel>{

  const CreditCardPageBottomSheet({super.key});

  @override
  void onViewModelReady(CreditCardViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  CreditCardViewModel viewModelBuilder(BuildContext context) => CreditCardViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, CreditCardViewModel viewModel, Widget? child) {
    return SafeArea(
      child:  Wrap(
        children: [

          _CardInfo(),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Button(
                'Save',
                valueKey: const Key("btnPlaceOrder"),
                width: double.infinity,
                borderRadius: BorderRadius.circular(5),
                color: AppColor.primary,
                borderColor: AppColor.primary,
                onPressed: (){
                  viewModel.save(context);
                }),
          ),
        ],
      ),
    );
  }

}

class _CardInfo extends ViewModelWidget<CreditCardViewModel>{
  @override
  Widget build(BuildContext context, CreditCardViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.only(top: 10,bottom: 10,left: 15,right: 15),
      child: Column(
        children: [

          Row(
            children: [

              Expanded(
                child: EditTextField(
                  "Card Number",
                  viewModel.cardNumController,
                  autoFocus: true,
                  placeholder: 'XXXX XXXX XXXX XXXX',
                  margin: const EdgeInsets.only(bottom: 15.0),
                ),
              ),

              // HorizontalSpacing.d10px(),
              //
              // Container(child: CardUtils.getCardIcon(viewModel.paymentCard!),),

              HorizontalSpacing.d10px(),

              InkWell(
                child: const Padding(
                  padding: EdgeInsets.only(top:10.0),
                  child: Icon(Icons.qr_code_scanner,color: AppColor.secondaryText),
                ),
                onTap: (){
                  viewModel.scanCard();
                },
              ),
            ],
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(
                flex: 3,
                child: EditTextField(
                  "Expiration Date",
                  viewModel.expDateController,
                  placeholder: 'MM/YYYY',
                ),
              ),

              HorizontalSpacing.custom(value: 30),

              Expanded(
                flex: 3,
                child: EditTextField(
                  "CVV",
                  viewModel.cvvController,
                  placeholder: viewModel.placeholderCvv,
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }
}




