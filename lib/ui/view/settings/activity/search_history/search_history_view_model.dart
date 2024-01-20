
import 'package:bullion/locator.dart';
import 'package:bullion/services/api_request/activity_request.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';

import '../../../../../core/models/module/product_item.dart';


class SearchHistoryViewModel extends VGTSBaseViewModel {

  String description = "The benefits of Price Alerts includes maximizing your buy position for specific products. Set a Price Alert and we will notify you by email, SMS text message or both when the product has reached your indicated price point. Price Alerts notifies you of the price when buying from APMEX, not selling. To set a Price Alert visit a product page.";

  List<ProductOverview>? _list = [];

  List<ProductOverview>? get list => _list;

  set list(List<ProductOverview>? value) {
    _list = value;
    notifyListeners();
  }

  @override
  onInit() async {
    fetchSearchHistory();
    super.onInit();
  }

  fetchSearchHistory() async {
    setBusy(true);
    list = await requestList<ProductOverview>(ActivityRequest.getSearchHistory());
    setBusy(false);
  }

}