import 'package:bullion/core/models/user_address.dart';
import 'package:bullion/services/api/endpoints.dart';

import '../../locator.dart';
import '../appconfig_service.dart';
import '../shared/api_model/request_settings.dart';
import '../shared/request_method.dart';

class AddressRequest {
  static RequestSettings getAddress() {
    return RequestSettings("/address/get", RequestMethod.GET,
        params: null, authenticated: true);
  }

  static RequestSettings getAddressById(int addressId) {
    return RequestSettings("/address/edit?addressId=$addressId", RequestMethod.GET,
        params: null, authenticated: true);
  }


  static RequestSettings deleteAddress(int addressId) {
    return RequestSettings(
        "/address/remove?addressId=$addressId", RequestMethod.POST,
        params: null, authenticated: true);
  }

  static RequestSettings saveAddress(Map<String, dynamic> json) {
    return RequestSettings(Endpoints.saveAddress, RequestMethod.POST,
        params: json, authenticated: true);
  }

  static RequestSettings saveRecommended(UserAddress address) {
    return RequestSettings("/address/save-recommended", RequestMethod.POST, params: address.toJson(), authenticated: true);
  }

  static RequestSettings addAddress() {
    return RequestSettings("/address/add", RequestMethod.GET, params: null, authenticated: true);
  }

  static RequestSettings getAvailableStates(String country) {
    return RequestSettings(
        "${Endpoints.getStates}?country=$country", RequestMethod.GET,
        params: null, authenticated: true);
  }

  static RequestSettings getPredictions(String text) {
    return RequestSettings(
        Endpoints.googleAutocomplete.replaceFirst(
            "<input>",
            Uri.encodeFull(text)).replaceFirst(
            "<key>", locator<AppConfigService>().config!.googleAPIKey!),
        RequestMethod.GET,
        params: null,
        authenticated: false);
  }

  static RequestSettings getPlaceInfoFromPlaceId(String placeId) {
    return RequestSettings(
        Endpoints.googlePlaceDetails
            .replaceFirst("<placeId>", placeId)
            .replaceFirst(
                "<key>", locator<AppConfigService>().config!.googleAPIKey!),
        RequestMethod.GET,
        params: null,
        authenticated: false);
  }
}
