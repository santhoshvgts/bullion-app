class Reviews {
  double? avgRatings;
  String? name;
  int? rating;
  String? heading;
  String? comment;
  bool? hasPurchased;
  String? state;
  String? formattedPostedDate;

  Reviews(
      {this.avgRatings,
        this.name,
        this.rating,
        this.heading,
        this.comment,
        this.hasPurchased,
        this.state,
        this.formattedPostedDate});

  Reviews.fromJson(Map<String, dynamic> json) {
    avgRatings = json['avg_ratings'];
    name = json['name'];
    rating = json['rating'];
    heading = json['heading'];
    comment = json['comment'];
    hasPurchased = json['has_purchased'];
    state = json['state'];
    formattedPostedDate = json['formatted_posted_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avg_ratings'] = this.avgRatings;
    data['name'] = this.name;
    data['rating'] = this.rating;
    data['heading'] = this.heading;
    data['comment'] = this.comment;
    data['has_purchased'] = this.hasPurchased;
    data['state'] = this.state;
    data['formatted_posted_date'] = this.formattedPostedDate;
    return data;
  }
}