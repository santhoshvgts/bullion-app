import 'package:bullion/core/models/auth/profile.dart';
import 'package:bullion/core/models/module/selected_item_list.dart';
import 'package:bullion/helper/utils.dart';
import 'package:bullion/services/api_request/account_request.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:bullion/core/enums/viewstate.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:vgts_plugin/form/utils/form_field_controller.dart';

class ProfileViewModel extends VGTSBaseViewModel {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Profile? profile;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  DropdownFieldController<SelectedItemList> salutationController = DropdownFieldController<SelectedItemList>(const ValueKey("dbSalutation"), keyId: "value", valueId: "text");
  NameFormFieldController nameController = NameFormFieldController(const ValueKey("txtName"));
  NameFormFieldController lnameController = NameFormFieldController(const ValueKey("txtLName"));
  EmailFormFieldController emailController = EmailFormFieldController(const ValueKey("txtEmail"));
  PhoneFormFieldController phoneNoController = PhoneFormFieldController(const ValueKey("txtPhone"), maxLength: 15);
  PhoneFormFieldController alternativePhoneNoController = PhoneFormFieldController(const ValueKey("txtAlterPhoneNo"), maxLength: 15);
  TextFormFieldController companyNameController = TextFormFieldController(const ValueKey("txtCompany"), required: false);

  @override
  Future onInit() async {
    setBusy(true);
    profile = await request<Profile>(AccountRequest.getProfile());

    print(profile?.salutation);

    salutationController.list = profile?.salutation ?? [];
    salutationController.setValue(profile!.salutation!.singleWhereOrNull((element) => element.selected!));

    nameController.text = profile!.firstName!;
    lnameController.text = profile!.lastName!;
    emailController.text = profile!.user!.email!;
    phoneNoController.text = profile!.phoneNumber?.trim() ?? '';
    alternativePhoneNoController.text = profile!.alternatePhoneNumber ?? '';
    companyNameController.text = profile!.companyName ?? '';

    setBusy(false);
    return super.onInit();
  }

  onSaveProfile() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    isLoading = true;
    var response = await request<Profile>(AccountRequest.saveProfile(salutationController.value!.value, nameController.text, lnameController.text, phoneNoController.text, alternativePhoneNoController.text, companyNameController.text));
    isLoading = false;

    if (response != null) {
      locator<AuthenticationService>().updateUserProfile(response.user);
      navigationService.pop(returnValue: true);
      Util.showSnackBar("Profile Updated Successfully !");
    }

  }

}