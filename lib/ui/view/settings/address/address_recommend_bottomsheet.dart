import 'package:bullion/core/models/alert/alert_response.dart';
import 'package:bullion/core/models/user_address.dart';
import 'package:bullion/core/res/colors.dart';
import 'package:bullion/core/res/spacing.dart';
import 'package:bullion/core/res/styles.dart';
import 'package:bullion/services/shared/dialog_service.dart';
import 'package:bullion/ui/view/settings/address/add_edit_address_view_model.dart';
import 'package:bullion/ui/view/vgts_builder_widget.dart';
import 'package:bullion/ui/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stacked/stacked.dart';

import '../../../../../../locator.dart';

enum SelectAddress { Suggested, Entered }

class AddressRecommendBottomSheet extends VGTSBuilderWidget<AddEditAddressViewModel> {

  final AddEditAddressViewModel viewModel;

  const AddressRecommendBottomSheet(this.viewModel, {super.key});

  @override
  AddEditAddressViewModel viewModelBuilder(BuildContext context) {
    return viewModel;
  }

  @override
  bool get disposeViewModel => false;

  @override
  Widget viewBuilder(BuildContext context, AppLocalizations locale, AddEditAddressViewModel viewModel, Widget? child) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 15.0,right: 15.0,bottom: 15.0),
        child: Wrap(
          children: [
            Container(padding: const EdgeInsets.only(top:10.0,bottom: 10.0),
                child: const Text("We compared the shipping address you provided with postal service records and found some inconsistencies. Please edit or select the original address you provided, or click to proceed with the recommended address.",
                  textScaleFactor:1, style: AppTextStyle.bodyMedium,)),

            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text("Suggested Address",style: AppTextStyle.titleMedium),
            ),

            _AddressItem(viewModel.shippingAddress!.recommendedAddress,isSelected: viewModel.selectedAddress==SelectAddress.Suggested ? true : false,
              onTap:() {
                viewModel.setAddress(SelectAddress.Suggested);
                viewModel.notifyListeners();
              },),

            const Padding(
              padding: EdgeInsets.only(bottom: 10, top: 15),
              child: Text("Entered Address", style: AppTextStyle.titleMedium),
            ),

            _AddressItem(viewModel.shippingAddress!.address,isEdit:true,isSelected: viewModel.selectedAddress==SelectAddress.Entered ? true : false,
              onTap: () {
                viewModel.setAddress(SelectAddress.Entered);
                viewModel.notifyListeners();
              },),


            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Button("Save Address",
                valueKey: const Key("saveAddressBtn"),
                width: double.infinity,
                loading: viewModel.isBusy,
                onPressed: () {
                  viewModel.saveRecommended();
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class _AddressItem extends  ViewModelWidget<AddEditAddressViewModel> {

  final UserAddress? _item;
  final Function? onTap;
  final bool isEdit;
  final bool? isSelected;

  const _AddressItem(this._item,{this.onTap,this.isEdit=false,this.isSelected});

  @override
  Widget build(BuildContext context,AddEditAddressViewModel viewModel) {
    return  InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected == true ? AppColor.primary : AppColor.border, width: 1)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

           isSelected! ?  const Icon( Icons.radio_button_checked,color: AppColor.primary,size: 20,):
             const Icon( Icons.radio_button_off,color: AppColor.secondaryHeader,size: 20,),

            HorizontalSpacing.d10px(),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    _item!.name,
                    
                    style: AppTextStyle.titleMedium,
                  ),

                  VerticalSpacing.d2px(),

                  Text(
                    _item!.add1!,
                    
                    style: AppTextStyle.bodyMedium,
                  ),
                  VerticalSpacing.d2px(),
                  Text(
                    _item!.formattedSubAddress,
                    
                    style: AppTextStyle.bodyMedium,
                  ),

                ],
              ),
            ),


          if(isEdit) TextButton(
                child: Text("Edit",  style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600,color: AppColor.primary),),
                onPressed: () async{
                  locator<DialogService>().dialogComplete(AlertResponse(status:false));
                }
            ),

          ],
        ),
      ),
    );
  }

}