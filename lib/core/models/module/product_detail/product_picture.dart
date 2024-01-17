class ProductPicture {
  int? id;
  String? imageUrl;
  String? fullSizeImageUrl;
  String? title;
  String? alternateText;
  int? sortOrder;

  ProductPicture(
      {this.id,
        this.imageUrl,
        this.fullSizeImageUrl,
        this.title,
        this.alternateText,
        this.sortOrder});

  ProductPicture.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image_url'];
    fullSizeImageUrl = json['full_size_image_url'];
    title = json['title'];
    alternateText = json['alternate_text'];
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image_url'] = this.imageUrl;
    data['full_size_image_url'] = this.fullSizeImageUrl;
    data['title'] = this.title;
    data['alternate_text'] = this.alternateText;
    data['sort_order'] = this.sortOrder;
    return data;
  }
}
