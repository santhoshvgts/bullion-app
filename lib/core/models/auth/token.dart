import 'package:bullion/core/models/base_model.dart';

class Token extends BaseModel {
  String? authToken;
  String? expiration;
  String? refreshToken;
  int? userId;

  Token({this.authToken, this.expiration, this.refreshToken, this.userId});

  Token.fromJson(Map<String, dynamic> json) {
    authToken = json['auth_token'];
    expiration = json['expiration'];
    refreshToken = json['refresh_token'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['auth_token'] = this.authToken;
    data['expiration'] = this.expiration;
    data['refresh_token'] = this.refreshToken;
    data['user_id'] = this.userId;
    return data;
  }
}
