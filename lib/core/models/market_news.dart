class MarketNews {
  String? title;
  String? featureImage;
  String? externalLink;
  String? updatedAgo;
  String? tags;
  String? source;
  bool? openInNewWindow;

  MarketNews(
      {this.title,
      this.featureImage,
      this.externalLink,
      this.updatedAgo,
      this.tags,
      this.source,
      this.openInNewWindow});

  MarketNews.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    featureImage = json['feature_image'];
    externalLink = json['external_link'];
    updatedAgo = json['updated_ago'];
    tags = json['tags'];
    source = json['source'];
    openInNewWindow = json['open_in_new_window'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['feature_image'] = this.featureImage;
    data['external_link'] = this.externalLink;
    data['updated_ago'] = this.updatedAgo;
    data['tags'] = this.tags;
    data['source'] = this.source;
    data['open_in_new_window'] = this.openInNewWindow;
    return data;
  }
}
