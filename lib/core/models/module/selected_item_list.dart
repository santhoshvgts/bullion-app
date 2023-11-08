import 'package:bullion/core/models/base_model.dart';

class SelectedItemList extends BaseModel {
  String? value;
  String? text;
  bool? selected;

  SelectedItemList({this.value, this.text, this.selected});

  @override
  SelectedItemList fromJson(json) => SelectedItemList.fromJson(json);

  SelectedItemList.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    text = json['text'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['text'] = text;
    data['selected'] = selected;
    return data;
  }
}
