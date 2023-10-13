import 'package:bullion/ui/view/vgts_base_view_model.dart';

class OrderDetailsViewModel extends VGTSBaseViewModel {
  bool _isExpanded = false;

  bool get isExpanded => _isExpanded;

  set isExpanded(bool value) {
    _isExpanded = value;
    notifyListeners();
  }
}
