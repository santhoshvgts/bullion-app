import 'package:bullion/core/models/base_model.dart';
import 'package:bullion/core/models/module/selected_item_list.dart';

import '../../user_address.dart';

class ShippingAddress extends BaseModel {
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

  @override
  ShippingAddress fromJson(json) => ShippingAddress.fromJson(json);

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    address =
        json['address'] != null ? UserAddress.fromJson(json['address']) : null;
    if (json['available_countries'] != null) {
      availableCountries = <SelectedItemList>[];
      json['available_countries'].forEach((v) {
        availableCountries!.add(SelectedItemList.fromJson(v));
      });
    }
    if (json['available_states'] != null) {
      availableStates = <SelectedItemList>[];
      json['available_states'].forEach((v) {
        availableStates!.add(SelectedItemList.fromJson(v));
      });
    }
    isCitadel = json['is_citadel'];
    citadelAccountNumber = json['citadel_account_number'];
    _displayText = json['display_text'];
    enableAutoComplete = json['enable_auto_complete'];
    citadelPromotionDiscount = json['citadel_promotion_discount'] != null
        ? double.parse(json['citadel_promotion_discount'].toString())
        : 0.0;
    formattedCitadelPromotionDiscount =
        json['formatted_citadel_promotion_discount'];

    recommendedAddress = json['recommended_address'] != null
        ? UserAddress.fromJson(json['recommended_address'])
        : null;
    ;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (availableCountries != null) {
      data['available_countries'] =
          availableCountries!.map((v) => v.toJson()).toList();
    }
    if (availableStates != null) {
      data['available_states'] =
          availableStates!.map((v) => v.toJson()).toList();
    }
    if (recommendedAddress != null) {
      data['recommended_address'] = recommendedAddress!.toJson();
    }

    data['display_text'] = _displayText;
    data['is_citadel'] = isCitadel;
    data['citadel_account_number'] = citadelAccountNumber;
    data['enable_auto_complete'] = enableAutoComplete;
    data['citadel_promotion_discount'] = citadelPromotionDiscount;
    data['formatted_citadel_promotion_discount'] =
        formattedCitadelPromotionDiscount;
    return data;
  }
}
