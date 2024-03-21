import 'package:bullion/core/models/auth/user.dart';
import 'package:bullion/core/models/base_model.dart';
import 'package:bullion/core/models/module/selected_item_list.dart';

class Profile extends BaseModel {
  List<SelectedItemList>? salutation;

  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? alternatePhoneNumber;
  String? companyName;
  User? user;

  Profile(
      {this.salutation,
        this.firstName,
        this.lastName,
        this.phoneNumber,
        this.alternatePhoneNumber,
        this.companyName});

  Profile fromJson(Map<String, dynamic> json) => Profile.fromJson(json);

  Profile.fromJson(Map<String, dynamic> json) {
    if (json['salutation'] != null) {
      salutation = <SelectedItemList>[];
      json['salutation'].forEach((v) {
        salutation!.add(SelectedItemList.fromJson(v));
      });
    }
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    firstName = json['first_name'];
    lastName = json['last_name'];
    phoneNumber = json['phone_number'];
    alternatePhoneNumber = json['alternate_phone_number'];
    companyName = json['company_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (salutation != null) {
      data['salutation'] = salutation!.map((v) => v.toJson()).toList();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone_number'] = phoneNumber;
    data['alternate_phone_number'] = alternatePhoneNumber;
    data['company_name'] = companyName;
    return data;
  }
}
