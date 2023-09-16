class Items {
  String? displayName;
  int? count;
  bool? isSelected;
  String? targetUrl;

  Items({this.displayName, this.count, this.isSelected, this.targetUrl});

  Items.fromJson(Map<String, dynamic> json) {
    displayName = json['display_name'];
    count = json['count'];
    isSelected = json['is_selected'];
    targetUrl = json['target_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['display_name'] = this.displayName;
    data['count'] = this.count;
    data['is_selected'] = this.isSelected;
    data['target_url'] = this.targetUrl;
    return data;
  }
}