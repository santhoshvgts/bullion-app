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


class CreditCardPageBottomSheet extends StatefulWidget {
  const CreditCardPageBottomSheet({super.key});

  @override
  State<CreditCardPageBottomSheet> createState() => _CreditCardPageBottomSheetState();
}

class _CreditCardPageBottomSheetState extends State<CreditCardPageBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreditCardViewModel>.reactive(
        viewModelBuilder: ()=> CreditCardViewModel(),
        onViewModelReady: (viewModel) {
          viewModel.init();
        },
        builder: (context, viewModel, child) {
          return GestureDetector(
            onTap: (){
            },
            child: SafeArea(
              child:  Form(
                key: viewModel.formKey,
                child: Wrap(
                  children: [

                    Container(
                      padding: const EdgeInsets.only(top: 10,bottom: 10 ,left: 15,right: 15),
                      child: Column(
                        children: [

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Expanded(
                                child: EditTextField(
                                  "Card Number",
                                  viewModel.cardNumController,
                                  autoFocus: true,
                                  placeholder: 'xxxx xxxx xxxx xxxx',
                                  margin: const EdgeInsets.only(bottom: 15.0),
                                ),
                              ),

                              IconButton(
                                icon: const Icon(Icons.qr_code_scanner,color: AppColor.secondaryText),
                                onPressed: () {
                                  viewModel.scanCard();
                                },
                              ),

                              viewModel.isAndroid ? IconButton(
                                icon: const Icon(Icons.nfc_rounded,color: AppColor.secondaryText),
                                onPressed: viewModel.nfcScanning ? null : () {
                                  viewModel.checkNFC();
                                },
                              ) : Container(),
                            ],
                          ),

                          VerticalSpacing.d10px(),

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

                              HorizontalSpacing.custom(value: 15),

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
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Button(
                          'Save',
                          valueKey: const Key("btnCreate"),
                          width: double.infinity,
                          color: AppColor.primary,
                          borderColor: AppColor.primary,
                          onPressed: () async {
                            var result = await viewModel.save(context);
                            if (result == false) {
                              setState(() {});
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}
