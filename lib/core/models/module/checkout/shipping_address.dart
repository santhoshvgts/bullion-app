import 'package:bullion/core/models/module/selected_item_list.dart';

import '../../user_address.dart';

class ShippingAddress {
  UserAddress? address;
  List<SelectedItemList>? availableCountries;
  List<SelectedItemList>? availableStates;
  UserAddress? recommendedAddress;

  bool? isCitadel;
  bool? enableAutoComplete;
  String? citadelAccountNumber;
  double? citadelPromotionDiscount;
  String? formattedCitadelPromotionDiscount;
  String? _displayText;

  String get displayText => _displayText!.replaceAll("\\n", "\n");

  ShippingAddress(
      {this.address,
        this.availableCountries,
        this.availableStates,
        this.recommendedAddress});

  ShippingAddress.fromJson(Map<String, dynamic> json) {

    address = json['address'] != null ? new UserAddress.fromJson(json['address']) : null;
    if (json['available_countries'] != null) {
      availableCountries = <SelectedItemList>[];
      json['available_countries'].forEach((v) {
        availableCountries!.add(new SelectedItemList.fromJson(v));
      });
    }
    if (json['available_states'] != null) {
      availableStates = <SelectedItemList>[];
      json['available_states'].forEach((v) {
        availableStates!.add(new SelectedItemList.fromJson(v));
      });
    }
    isCitadel = json['is_citadel'];
    citadelAccountNumber = json['citadel_account_number'];
    _displayText = json['display_text'];
    enableAutoComplete = json['enable_auto_complete'];
    citadelPromotionDiscount = json['citadel_promotion_discount'] != null ? double.parse(json['citadel_promotion_discount'].toString()) : 0.0;
    formattedCitadelPromotionDiscount =
    json['formatted_citadel_promotion_discount'];

    recommendedAddress = json['recommended_address'] != null ? new UserAddress.fromJson(json['recommended_address']) : null;;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.availableCountries != null) {
      data['available_countries'] =
          this.availableCountries!.map((v) => v.toJson()).toList();
    }
    if (this.availableStates != null) {
      data['available_states'] =
          this.availableStates!.map((v) => v.toJson()).toList();
    }
    if (this.recommendedAddress != null) {
      data['recommended_address'] = this.recommendedAddress!.toJson();
    }

    data['display_text'] = this._displayText;
    data['is_citadel'] = this.isCitadel;
    data['citadel_account_number'] = this.citadelAccountNumber;
    data['enable_auto_complete'] = this.enableAutoComplete;
    data['citadel_promotion_discount'] = this.citadelPromotionDiscount;
    data['formatted_citadel_promotion_discount'] = this.formattedCitadelPromotionDiscount;
    return data;
  }
}