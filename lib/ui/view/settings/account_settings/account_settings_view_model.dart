import 'package:bullion/core/models/auth/profile.dart';
import 'package:bullion/locator.dart';
import 'package:bullion/services/api_request/account_request.dart';
import 'package:bullion/services/authentication_service.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';

class AccountSettingsViewModel extends VGTSBaseViewModel {

  Profile? profile;

  @override
  Future onInit() async {
    fetchProfile();
    return super.onInit();
  }

  fetchProfile() async {
    setBusy(true);
    profile = await request<Profile>(AccountRequest.getProfile());
    setBusy(false);
  }

}