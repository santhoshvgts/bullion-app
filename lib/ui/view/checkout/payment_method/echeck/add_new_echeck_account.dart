import 'package:bullion/ui/view/checkout/payment_method/echeck/add_new_echeck_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/edit_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:bullion/ui/widgets/tap_outside_unfocus.dart';
import 'package:stacked/stacked.dart';

enum SelectAccount { Checking , Savings }

class AddNewECheckPage extends VGTSBuilderWidget<AddNewECheckViewModel> {

  bool hasUserPaymentMethod;

  AddNewECheckPage(this.hasUserPaymentMethod);

  @override
  void onViewModelReady(AddNewECheckViewModel viewModel) {
    super.onViewModelReady(viewModel);
  }

  @override
  viewModelBuilder(BuildContext context)=> AddNewECheckViewModel(this.hasUserPaymentMethod);

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, AddNewECheckViewModel viewModel, Widget? child) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.2,
      child: Stack(
        children: [


          Column(
            children: [
              Flexible(
                flex: 1,
                child: TapOutsideUnFocus(
                  child: Container(
                    height: double.infinity,
                    padding: const EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0),
                    child: ListView(
                      controller: viewModel.scroll,
                      children: [


                        _AccountTypeSection(),


                        VerticalSpacing.d20px(),


                        EditTextField(
                          "Name on Account: (Required)",
                          viewModel.nameController,
                          margin: const EdgeInsets.only(bottom: 20.0),
                        ),


                        EditTextField(
                          "Bank Name: (Required)",
                          viewModel.bankNameController,
                          margin: const EdgeInsets.only(bottom: 20.0),
                        ),


                        EditTextField(
                          "Banking Routing Number: (Required)",
                          viewModel.bankNoController,
                          margin: const EdgeInsets.only(bottom: 20.0),
                        ),


                        EditTextField(
                          "Account Number: (Required)",
                          viewModel.accountNoController,
                          margin: const EdgeInsets.only(bottom : 20.0),
                        ),

                        EditTextField(
                          "Confirm Account Number: (Required)",
                          viewModel.confirmAccountController,
                          margin: const EdgeInsets.only(bottom: 20.0),
                        ),

                        _PermissionSection(),

                        VerticalSpacing.d20px(),


                      ],

                    ),
                  ),
                ),
              ),

              Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      boxShadow: AppStyle.topShadow,
                      color: AppColor.white),
                  child: _ButtonSection()),


            ],
          ),


          if (viewModel.isBusy)
            Container(
              color: AppColor.white.withOpacity(0.7),
              height: MediaQuery.of(context).size.height / 1.2,
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
    );
  }

}


class _AccountTypeSection extends ViewModelWidget<AddNewECheckViewModel>
{
  @override
  Widget build(BuildContext context, AddNewECheckViewModel viewModel) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      // spacing: 5,
      // runSpacing: 10,
      children: [

        Expanded(
          child: InkWell(
            onTap: () {
                viewModel.setAccount(SelectAccount.Checking);
                viewModel.notifyListeners();
              },
              child: _AccountTypeUI(isSelected: viewModel.selectAccount == SelectAccount.Checking ? true : false,title: "Checking",)),
        ),

        HorizontalSpacing.d10px(),

        Expanded(
          child: InkWell(
            onTap: () {
              viewModel.setAccount(SelectAccount.Savings);
              viewModel.notifyListeners();
            },
            child: _AccountTypeUI(isSelected: viewModel.selectAccount == SelectAccount.Savings ? true : false,title: "Savings",)),
        )

      ],
    );

  }

}

class _AccountTypeUI extends ViewModelWidget<AddNewECheckViewModel> {

 final  bool? isSelected;
 final String? title;

  _AccountTypeUI({this.isSelected,this.title});

  @override
  Widget build(BuildContext context, AddNewECheckViewModel viewModel) {
    return Wrap(
      spacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [

        isSelected! ?  const Padding(
          padding: EdgeInsets.only(top:2.0),
          child: Icon( Icons.radio_button_checked,color: AppColor.primary,size: 20,),
        ):
        const Padding(
          padding: EdgeInsets.only(top:2.0),
          child: Icon( Icons.radio_button_off,color: AppColor.secondaryHeader,size: 20,),
        ),

        Text(title!,style: AppTextStyle.bodyMedium.copyWith(fontSize: 18),)

      ],
    );

  }

}





class _PermissionSection extends ViewModelWidget<AddNewECheckViewModel>
{
  @override
  Widget build(BuildContext context, AddNewECheckViewModel viewModel) {

    return InkWell(
      onTap: () => viewModel.OnChange(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          viewModel.permission ? const Icon(Icons.check_box,size: 20,color: AppColor.primary,) :  const Icon(Icons.check_box_outline_blank,size: 20,color: AppColor.black20,) ,

          HorizontalSpacing.d10px(),

          Expanded(
              child: Text("I hereby authorize APMEX to debit my account. This Permission is for present .",style: AppTextStyle.bodyMedium,))


        ],
      ),
    );

  }

}


class _ButtonSection extends ViewModelWidget<AddNewECheckViewModel>
{
  @override
  Widget build(BuildContext context, AddNewECheckViewModel viewModel) {
   return Row(
     children: [

       Expanded(
         child: Button.outline("Cancel", valueKey: const Key("btnCancel"),
             width: double.infinity,
             onPressed: () {
               locator<DialogService>().dialogComplete(AlertResponse(status: false));
             }),
       ),


       HorizontalSpacing.d10px(),


       Expanded(
         child: Button("Save", valueKey: const Key("btnSave"),
             width: double.infinity,
             onPressed: () {

             viewModel.addBankAccount(context);

             }),
       ),
     ],
   );
  }

}