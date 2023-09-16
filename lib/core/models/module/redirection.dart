import 'package:bullion/core/models/base_model.dart';

class Redirection extends BaseModel {
  String? targetUrl;
  bool? hasNativeRoute;
  bool? openInNewWindow;
  bool? requiredLogin;

  Redirection({this.targetUrl, this.hasNativeRoute, this.openInNewWindow});

  Redirection.fromJson(Map<String, dynamic> json) {
    targetUrl = json['target_url'];
    hasNativeRoute = json['has_native_route'];
    openInNewWindow = json['open_in_new_window'];
    requiredLogin = json['requires_login'] ?? false;
  }

  Redirection fromJson(json) => Redirection.fromJson(json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['target_url'] = this.targetUrl;
    data['has_native_route'] = this.hasNativeRoute;
    data['open_in_new_window'] = this.openInNewWindow;
    data['requires_login'] = this.requiredLogin;
    return data;
  }
}