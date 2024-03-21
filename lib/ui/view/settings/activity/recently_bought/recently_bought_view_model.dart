
import 'package:bullion/core/models/module/product_item.dart';
import 'package:bullion/services/api_request/activity_request.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';
import 'package:flutter/cupertino.dart';

class RecentlyBoughtViewModel extends VGTSBaseViewModel {

  int pageNo = 1;
  bool hasNextPage = true;

  ScrollController scrollController = ScrollController();
  List<ProductOverview>? productList = [];

  bool _isPaginationLoading = false;

  bool get isPaginationLoading => _isPaginationLoading;

  set isPaginationLoading(bool value) {
    _isPaginationLoading = value;
    notifyListeners();
  }

  @override
  Future onInit() async {
    scrollController.addListener(_onScroll);
    getRecentlyBought();
    return super.onInit();
  }

  getRecentlyBought() async {
    setBusy(true);
    productList = await requestList<ProductOverview>(ActivityRequest.getRecentlyBought());
    pageNo = 1;
    hasNextPage = true;
    setBusy(false);
  }

  _onScroll() async {
    if (scrollController.position.pixels > (scrollController.position.maxScrollExtent - 200) && !_isPaginationLoading && hasNextPage) {
      isPaginationLoading = true;
      List<ProductOverview>? productList = await requestList<ProductOverview>(ActivityRequest.getRecentlyBought(pageNo: pageNo + 1));

      if (productList!.length > 0) {
        this.productList!.addAll(productList);
      } else {
        hasNextPage = false;
      }
      pageNo++;

      isPaginationLoading = false;
    }
  }

}