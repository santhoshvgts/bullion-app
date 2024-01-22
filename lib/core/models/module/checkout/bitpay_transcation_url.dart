// ignore_for_file: must_be_immutable

import 'package:bullion/core/models/base_model.dart';

class BitPayTranscationUrl extends BaseModel {
  String? transcationUrl;

  BitPayTranscationUrl({this.transcationUrl});

  BitPayTranscationUrl.fromJson(Map<String, dynamic> json) {
    transcationUrl = json['transaction_url'];
  }

  @override
  BitPayTranscationUrl fromJson(json) => BitPayTranscationUrl.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['transaction_url'] = transcationUrl;
    return data;
  }
}
