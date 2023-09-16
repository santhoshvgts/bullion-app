
class SimpleImageCTA {
  String? imageUrl;
  String? targetUrl;

  SimpleImageCTA({
        this.targetUrl,
        this.imageUrl
      });

  SimpleImageCTA.fromJson(Map<String, dynamic> json) {
    targetUrl = json['target_url'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['target_url'] = this.targetUrl;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

