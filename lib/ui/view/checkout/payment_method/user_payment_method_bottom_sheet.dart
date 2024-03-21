import 'package:bullion/ui/view/checkout/payment_method/required_validation_view_model.dart';
import 'package:bullion/ui/view/checkout/payment_method/user_payment_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:flutter/material.dart';
import 'package:bullion/core/models/module/checkout/payment_method.dart';
import 'package:bullion/core/models/module/checkout/user_payment_method.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/images.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/helper/utils.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked/stacked.dart';

class UserPaymentMethodPage extends VGTSBuilderWidget<UserPaymentViewModel> {

  PaymentMethod paymentMethod;
  List<UserPaymentMethod>? userPaymentMethodList;

  UserPaymentMethodPage(this.paymentMethod, this.userPaymentMethodList, {super.key});

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, UserPaymentViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: Text(paymentMethod.name ?? '', style: AppTextStyle.titleMedium.copyWith(color: AppColor.text, fontFamily: AppTextStyle.fontFamily),),
      ),
      body: Column(
        children: [

          Flexible(child: Stack(
            children: [

              Positioned.fill(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  children: [

                    if (paymentMethod.requiresZda!)
                      _buildZDAVerificationInfo(),

                    ListView.separated(
                        primary: false,
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        itemBuilder: (context, index) {
                          return _UserPaymentMethodCardItem(viewModel.userPaymentMethodList![index], onPressed: viewModel.onUserPaymentMethodSelect);
                        },
                        separatorBuilder: (context, index) {
                          return VerticalSpacing.d15px();
                        },
                        itemCount: viewModel.userPaymentMethodList?.length ?? 0
                    )

                  ],
                ),
              ),

              if (viewModel.loading)
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
          )),

          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                boxShadow: AppStyle.topShadow,
                color: Colors.white
              ),
              child: Button.outline(paymentMethod.paymentMethodId != 19 ? "+ Add New Card" : "+ Add New Account",
                  valueKey: const Key("btnAddNew"),
                  width: double.infinity,
                  textStyle: AppTextStyle.bodyMedium.copyWith(color: AppColor.primary),
                  borderColor: AppColor.primary,
                  onPressed: () {
                    if(!viewModel.loading){
                      viewModel.onAddNewClick();
                    }
                  }
              ),
            ),
          ),

        ],
      ),
    );
  }

  @override
  UserPaymentViewModel viewModelBuilder(BuildContext context) => UserPaymentViewModel(paymentMethod, userPaymentMethodList);

  Widget _buildZDAVerificationInfo() {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text("Secure your Payment", style: AppTextStyle.titleMedium,),

          VerticalSpacing.d5px(),

          Text("Why do you need my credit card?", style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w700),),

          VerticalSpacing.d5px(),

          const Text("We need your credit card information in order to hold / guarantee your order. Your credit card will not be charged if you choose to pay by check, wire, or money order.\n\n" +
              "For all orders using the credit card payment option, the name, address, and phone # must match the name on your BULLION.com account.", style: AppTextStyle.bodyMedium,),

          VerticalSpacing.d5px(),

        ],
      ),
    );
  }

}

class _UserPaymentMethodCardItem extends ViewModelWidget<UserPaymentViewModel> {

  final UserPaymentMethod item;
  final Function(UserPaymentMethod)? onPressed;

  _UserPaymentMethodCardItem(this.item, {this.onPressed});

  @override
  Widget build(BuildContext context, UserPaymentViewModel viewModel) {

    return InkWell(
      onTap: () => onPressed!(item),
      child: Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            boxShadow: AppStyle.elevatedCardShadow,
            borderRadius: BorderRadius.circular(12)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              VerticalSpacing.d10px(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [

                    item.icon == null ? Container() : Icon(FAIcon(item.icon), color: AppColor.primary, size: 25,),

                    HorizontalSpacing.d10px(),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(item.name!, style: AppTextStyle.bodyMedium,),

                          VerticalSpacing.d5px(),

                          Row(
                            children: [

                              if (item.accountNumber != null)
                                Expanded(child: Text(item.accountNumber!, style: AppTextStyle.titleMedium,),),

                              if (item.subText != null)
                                Expanded(child: Text(item.subText!, textAlign: TextAlign.end, style: AppTextStyle.titleMedium,)),

                            ],
                          ),

                        ],
                      ),
                    )

                  ],
                ),
              ),

              VerticalSpacing.d5px(),

              AppStyle.customDivider,

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: InkWell(
                  onTap: () async {
                    await viewModel.onDeleteUserPaymentMethod(item);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Row(
                      children: [
                        const Padding(padding: EdgeInsets.only(right: 4.0),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: AppColor.red,
                          ),
                        ),
                        Text("Delete", style: AppTextStyle.titleSmall.copyWith(color: AppColor.red),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              VerticalSpacing.d10px(),

            ],
          ),
      ),
    );
  }

}

class RequiredECheckValidationBottomSheet extends VGTSBuilderWidget<RequiredValidationViewModel> {

  final UserPaymentMethod item;

  RequiredECheckValidationBottomSheet(this.item);

  @override
  RequiredValidationViewModel viewModelBuilder(BuildContext context) => RequiredValidationViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, RequiredValidationViewModel viewModel, Widget? child) {
    return Wrap(
      children: [

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              child: Text("Verify Account Number", style: AppTextStyle.bodyMedium,),
            ),

            EditTextField(
              item.accountNumber ?? '',
              viewModel.accountNoController,
              margin: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0, top: 5),
              autoFocus: true,
              textInputAction: TextInputAction.done,
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 15.0, top: 10),
                child: Button("Submit",
                    width: double.infinity,
                    color: viewModel.accountNoController.text.isEmpty ? Colors.black12 : AppColor.primary,
                    textStyle:viewModel.accountNoController.text.isEmpty ? AppTextStyle.titleMedium.copyWith(color:  Colors.black26) : AppTextStyle.titleMedium,
                    borderColor: Colors.transparent,
                    loading: viewModel.isBusy,
                    valueKey: const Key("btnSubmit"),
                    onPressed: () async {
                      viewModel.validateAccountNumber(item.userPaymentMethodId);
                    }
                ),
              ),
            ),

          ],
        ),

      ],
    );
  }

}

class RequiredCreditCardValidationBottomSheet extends VGTSBuilderWidget<RequiredValidationViewModel> {

  final UserPaymentMethod item;

  RequiredCreditCardValidationBottomSheet(this.item);

  @override
  RequiredValidationViewModel viewModelBuilder(BuildContext context) => RequiredValidationViewModel();

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, RequiredValidationViewModel viewModel, Widget? child) {
    return Wrap(
      children: [

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Text(item.accountNumber!, style: AppTextStyle.bodyMedium,),
            ),

            if(item.subText != null) VerticalSpacing.d2px(),

            if(item.subText != null) Padding(
              padding: const EdgeInsets.only(left: 15, right: 15,),
              child: Text(item.subText!, style: AppTextStyle.bodyMedium,),
            ),

            VerticalSpacing.d10px(),

            EditTextField(
              "Enter CVV",
              viewModel.accountNoController,
              margin: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0, top: 5),
              autoFocus: true,
              textInputAction: TextInputAction.done,
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, bottom: 15.0, top: 10),
                child: Button("Submit",
                    width: double.infinity,
                    color: viewModel.accountNoController.text.isEmpty ? Colors.black12 : AppColor.primary,
                    textStyle:viewModel.accountNoController.text.isEmpty ? AppTextStyle.titleMedium.copyWith(color:  Colors.black26) : AppTextStyle.titleMedium,
                    borderColor: Colors.transparent,
                    loading: viewModel.isBusy,
                    valueKey: const Key("btnSubmit"),
                    onPressed: () async {

                      viewModel.validateAccountNumber(item.userPaymentMethodId);

                    }
                ),
              ),
            ),

          ],
        ),

      ],
    );
  }

}