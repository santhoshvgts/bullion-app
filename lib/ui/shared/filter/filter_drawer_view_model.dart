import 'package:bullion/core/models/module/product_listing/filter_module.dart';
import 'package:bullion/core/models/module/product_listing/product_list_module.dart';
import 'package:bullion/ui/shared/filter/filter_drawer.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';

class FilterDrawerViewModel extends VGTSBaseViewModel {
  ProductModel productModel;
  FilterDrawerController? controller;

  int index = 0;

  String? selectedFacetName;

  @override
  onInit() {
    if (controller != null) {
      controller?.onDataChange = onDataChange;
    }
    return super.onInit();
  }

  Facets? get selectedFacet => filterData?.singleWhere((element) => element.facetName == selectedFacetName);

  List<Facets>? get filterData => productModel.facets;
  //int? get selectedvalue =>  selectedvalue.sin

  FilterDrawerViewModel(this.productModel, this.controller) {
    onFilterSectionChange(0);
  }

  void onFilterSectionChange(int index) {
    selectedFacetName = filterData?.isEmpty == true ? '' : filterData?[index].facetName;
    notifyListeners();
  }

  List<int>? get selectedFilterItemCount => calculateSelectedCounts();

  List<int> calculateSelectedCounts() {
    List<int> selectedCounts = [];
    for (var element in productModel.facets!) {
      int sum = 0;
      for (var item in element.items!) {
        if (item.isSelected == true) {
          sum++;
        }
      }
      selectedCounts.add(sum);
    }
    return selectedCounts;
  }

  onDataChange(ProductModel productModel) {
    this.productModel = productModel;
    notifyListeners();
  }
}
