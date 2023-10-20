import 'package:bullion/core/models/module/product_listing/filter_module.dart';
import 'package:bullion/core/models/module/product_listing/product_list_module.dart';
import 'package:bullion/ui/shared/filter/filter_drawer.dart';
import 'package:bullion/ui/view/vgts_base_view_model.dart';

class FilterDrawerViewModel extends VGTSBaseViewModel {
  ProductModel productModel;
  FilterDrawerController? controller;

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

  FilterDrawerViewModel(this.productModel, this.controller) {
    onFilterSectionChange(0);
  }

  void onFilterSectionChange(int index) {
    selectedFacetName = filterData?.isEmpty == true ? '' : filterData?[index].facetName;
    notifyListeners();
  }

  onDataChange(ProductModel productModel) {
    this.productModel = productModel;
    notifyListeners();
  }
}
