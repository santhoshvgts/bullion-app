
class UserAddress {
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

  String get name => "${firstName} ${lastName}";

  String get formattedSubAddress => "$city, $state, $country, $zip.";

  UserAddress(
      {this.id,
        this.firstName,
        this.lastName,
        this.company,
        this.add1,
        this.add2,
        this.city,
        this.country,
        this.zip,
        this.state,
        this.isDefault,
        this.primaryPhone,
        this.isValidated,
        this.overrideValidation});

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['company'] = this.company;
    data['add1'] = this.add1;
    data['add2'] = this.add2;
    data['city'] = this.city;
    data['country'] = this.country;
    data['zip'] = this.zip;
    data['state'] = this.state;
    data['is_default'] = this.isDefault;
    data['primary_phone'] = this.primaryPhone;
    data['is_validated'] = this.isValidated;
    data['override_validation'] = this.overrideValidation;
    return data;
  }
}