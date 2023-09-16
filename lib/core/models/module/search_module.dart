
class SearchList{
  List<searchProduct>? product;

  SearchList({this.product});

  factory SearchList.fromJson(List<dynamic> parsedJson) {
    return new SearchList(
      product : parsedJson.map((i) => searchProduct.fromJson(i)).toList(),
    );
  }

}

class searchProduct {
  String? name;
  String? targetUrl;

  searchProduct({this.name, this.targetUrl});

  searchProduct.fromJson(Map<String, dynamic> json) {
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
