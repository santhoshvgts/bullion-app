import 'package:bullion/core/models/base_model.dart';

class SearchResult extends BaseModel {
  String? name;
  String? targetUrl;

  SearchResult({this.name, this.targetUrl});

  SearchResult fromJson(json) => SearchResult.fromJson(json);

  SearchResult.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    targetUrl = json['target_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['target_url'] = this.targetUrl;
    return data;
  }
}
