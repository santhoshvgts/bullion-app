import 'package:bullion/ui/view/checkout/payment_method/required_validation_view_model.dart';
import 'package:bullion/ui/view/checkout/payment_method/user_payment_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:flutter/material.dart';
import 'package:bullion/core/enums/viewstate.dart';
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

class UserPaymentMethodBottomSheet extends VGTSBuilderWidget<UserPaymentViewModel> {

  PaymentMethod paymentMethod;
  List<UserPaymentMethod>? userPaymentMethodList;

  UserPaymentMethodBottomSheet(this.paymentMethod, this.userPaymentMethodList, {super.key});

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, UserPaymentViewModel viewModel, Widget? child) {
    return SafeArea(
        child: Column(
          children: [

            Container(
              height: MediaQuery.of(context).size.height - ((25 / 100) * MediaQuery.of(context).size.height),
              child: Stack(
                children: [

                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height - ((11 / 100) * MediaQuery.of(context).size.height),
                      child: ListView(
                        padding: const EdgeInsets.all(0),
                        children: [

                          if (paymentMethod.requiresZda!)
                            _buildZDAVerificationInfo(),

                          ...viewModel.userPaymentMethodList!.map((item) => Column(
                            children: [
                              _UserPaymentMethodCardItem(item, onPressed: viewModel.onUserPaymentMethodSelect),
                              AppStyle.customDivider
                            ],
                          )).toList()

                        ],
                      ),
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
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Button.outline(paymentMethod.paymentMethodId != 19 ? "+ Add New Card" : "+ Add New Account",
                  valueKey: const Key("btnAddNew"),
                  width: double.infinity,
                  onPressed: () {
                    if(!viewModel.loading){
                      viewModel.onAddNewClick();
                    }
                  }
              ),
            ),

          ],
        )
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

          Text("Secure your Payment", textScaleFactor: 1, style: AppTextStyle.titleMedium,),

          VerticalSpacing.d5px(),

          Text("Why do you need my credit card?", textScaleFactor: 1, style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w700),),

          VerticalSpacing.d5px(),

          Text("We need your credit card information in order to hold / guarantee your order. Your credit card will not be charged if you choose to pay by check, wire, or money order.\n\n" +
              "For all orders using the credit card payment option, the name, address, and phone # must match the name on your APMEX account.", textScaleFactor: 1, style: AppTextStyle.bodyMedium,),

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
          color: AppColor.white,
          padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [


              item.icon == null ? Container() : new Icon(FAIcon(item.icon), color: AppColor.primary, size: 25,),

              HorizontalSpacing.d15px(),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name!,textScaleFactor: 1,style: AppTextStyle.titleMedium,),

                    VerticalSpacing.d5px(),

                    if (item.accountNumber != null)
                      Text(item.accountNumber!,textScaleFactor: 1,style: AppTextStyle.bodyMedium,),

                    if (item.subText != null)
                      Text(item.subText!,textScaleFactor: 1,style: AppTextStyle.bodyMedium,),

                    if (item.isBullionCard == true)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Image.asset(Images.bullionCard, ),
                      )
                  ],
                ),
              ),

              IconButton(
                onPressed: () async {
                  await viewModel.onDeleteUserPaymentMethod(item);
                },
                icon: const Icon(Icons.delete_outline, size: 20,)
              )

            ],
          )
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