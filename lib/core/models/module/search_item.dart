class SearchItem {
  String? name;
  String? targetUrl;

  SearchItem({this.name, this.targetUrl});

  SearchItem.fromJson(Map<String, dynamic> json) {
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