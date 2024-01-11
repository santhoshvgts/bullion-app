import 'package:bullion/services/api_request/favorites_request.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/models/module/product_detail/product_detail.dart';

class FavoritesViewModel extends VGTSBaseViewModel {
  List<ProductDetails>? _favoritesResponse;

  void init() async {
    setBusy(true);

    _favoritesResponse =
        await requestList<ProductDetails>(FavoritesRequest.getFavorites());

    debugPrint(_favoritesResponse.toString());
    setBusy(false);
  }

  List<ProductDetails>? get favoritesResponse => _favoritesResponse;

  Future<void> removeFavorite(int? productId) async {
    setBusy(true);

    await request<ProductDetails>(FavoritesRequest.removeFavorite(productId.toString()));

    setBusy(false);
  }
}
