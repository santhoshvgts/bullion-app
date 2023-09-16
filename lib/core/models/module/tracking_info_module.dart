class TrackingInfo {
  String? message;
  String? trackingUrl;
  String? trackingNumber;
  String? carrier;

  TrackingInfo(
      {this.message, this.trackingUrl, this.trackingNumber, this.carrier});

  TrackingInfo.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    trackingUrl = json['tracking_url'];
    trackingNumber = json['tracking_number'];
    carrier = json['carrier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['tracking_url'] = this.trackingUrl;
    data['tracking_number'] = this.trackingNumber;
    data['carrier'] = this.carrier;
    return data;
  }
}