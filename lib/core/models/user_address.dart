import 'package:bullion/core/models/base_model.dart';

class UserAddress extends BaseModel{
  int? id;
  String? firstName;
  String? lastName;
  String? company;
  String? add1;
  String? add2;
  String? city;
  String? country;
  String? zip;
  String? state;
  bool? isDefault;
  String? primaryPhone;
  bool? isValidated;
  bool? overrideValidation;

  String get name => "$firstName $lastName";

  String get formattedFullAddress => "$add1 $add2 $city, $state, $country, $zip.";

  String get formattedSubAddress => "$city, $state, $country, $zip.";

  UserAddress({this.id, this.firstName, this.lastName, this.company, this.add1, this.add2, this.city, this.country, this.zip, this.state, this.isDefault, this.primaryPhone, this.isValidated, this.overrideValidation});

  @override
  UserAddress fromJson(json) => UserAddress.fromJson(json);

  UserAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    company = json['company'];
    add1 = json['add1'];
    add2 = json['add2'];
    city = json['city'];
    country = json['country'];
    zip = json['zip'];
    state = json['state'];
    isDefault = json['is_default'];
    primaryPhone = json['primary_phone'];
    isValidated = json['is_validated'];
    overrideValidation = json['override_validation'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['company'] = company;
    data['add1'] = add1;
    data['add2'] = add2;
    data['city'] = city;
    data['country'] = country;
    data['zip'] = zip;
    data['state'] = state;
    data['is_default'] = isDefault;
    data['primary_phone'] = primaryPhone;
    data['is_validated'] = isValidated;
    data['override_validation'] = overrideValidation;
    return data;
  }

  @override
  String toString() {
    return 'UserAddress{id: $id, firstName: $firstName, lastName: $lastName, company: $company, add1: $add1, add2: $add2, city: $city, country: $country, zip: $zip, state: $state, isDefault: $isDefault, primaryPhone: $primaryPhone, isValidated: $isValidated, overrideValidation: $overrideValidation}';
  }
}
