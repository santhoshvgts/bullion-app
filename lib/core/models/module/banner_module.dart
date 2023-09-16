class BannerItem {
  String? title;
  String? imageUrl;
  String? targetUrl;

  BannerItem({this.title, this.imageUrl, this.targetUrl});

  BannerItem.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    imageUrl = json['image_url'];
    targetUrl = json['target_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['image_url'] = this.imageUrl;
    data['target_url'] = this.targetUrl;
    return data;
  }
}

