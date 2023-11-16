import 'package:bullion/ui/view/vgts_base_view_model.dart';

import '../../core/models/google/place.dart';
import '../../core/models/google/place_autocomplete.dart';
import '../../core/models/module/selected_item_list.dart';
import '../api_request/address_request.dart';

class GooglePlaceApi extends VGTSBaseViewModel {
  PlaceAutocomplete? _placeAutocomplete;
  Place? _place;

  Future<List<Predictions>?> getPredictions(
      String text, List<SelectedItemList>? countries) async {
    _placeAutocomplete =
        await request<PlaceAutocomplete>(AddressRequest.getPredictions(text));

    if (_placeAutocomplete != null) {
      return _placeAutocomplete!.predictions!
          .where((element) => countries!
              .where((e) =>
                  element.terms!.last.value!.toLowerCase() ==
                      e.value!.toLowerCase() ||
                  element.terms!.last.value!.toLowerCase() ==
                      e.text!.toLowerCase())
              .isNotEmpty)
          .toList();
    }

    return null;
  }

  Future<Place?> getPlaceInfoFromPlaceId(String? placeId) async {
    _place =
        await request<Place>(AddressRequest.getPlaceInfoFromPlaceId(placeId!));

    if (_place != null) {
      return _place;
    }

    return null;
  }
}
