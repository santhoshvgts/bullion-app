import 'package:bullion/core/models/user_address.dart';

class CheckoutAddress {
  List<UserAddress>? addressList;
  int? selectedAddressId;
  bool? isCitadel;
  bool? showCitadel;
  String? selectedCitadelAccount;
  List<String>? citadelAccountNumbers;
  double? citadelPromotionDiscount;
  String? formattedCitadelPromotionDiscount;
  String? citadelContent;

  CheckoutAddress(
      {this.addressList,
        this.selectedAddressId,
        this.isCitadel,
        this.showCitadel,
        this.selectedCitadelAccount,
        this.citadelAccountNumbers,
        this.citadelPromotionDiscount,
        this.citadelContent,
        this.formattedCitadelPromotionDiscount});

  CheckoutAddress.fromJson(Map<String, dynamic> json) {
    if (json['addresses'] != null) {
      addressList = <UserAddress>[];
      json['addresses'].forEach((v) {
        addressList!.add(new UserAddress.fromJson(v));
      });
    }
    selectedAddressId = json['selected_address_id'];
    isCitadel = json['is_citadel'];
    showCitadel = json['show_citadel'];
    selectedCitadelAccount = json['selected_citadel_account'];
    citadelContent = json['citadel_content'];
    citadelAccountNumbers = json['citadel_account_numbers'] != null ? json['citadel_account_numbers'].cast<String>() : [];
    citadelPromotionDiscount = double.parse(json['citadel_promotion_discount'] == null ? "0" : json['citadel_promotion_discount'].toString());
    formattedCitadelPromotionDiscount =
    json['formatted_citadel_promotion_discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addressList != null) {
      data['addresses'] = this.addressList!.map((v) => v.toJson()).toList();
    }
    data['selected_address_id'] = this.selectedAddressId;
    data['is_citadel'] = this.isCitadel;
    data['show_citadel'] = this.showCitadel;
    data['selected_citadel_account'] = this.selectedCitadelAccount;
    data['citadel_account_numbers'] = this.citadelAccountNumbers;
    data['citadel_promotion_discount'] = this.citadelPromotionDiscount;
    data['citadel_content'] = this.citadelContent;
    data['formatted_citadel_promotion_discount'] = this.formattedCitadelPromotionDiscount;
    return data;
  }
}