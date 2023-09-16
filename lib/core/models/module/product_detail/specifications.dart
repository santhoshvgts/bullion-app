
class Specifications {
  String? key;
  String? keyHelpText;
  String? value;

  Specifications({this.key, this.keyHelpText, this.value});

  Specifications.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    keyHelpText = json['key_help_text'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['key_help_text'] = this.keyHelpText;
    data['value'] = this.value;
    return data;
  }
}