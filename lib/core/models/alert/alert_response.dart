class AlertResponse {
  final String? title;
  final bool? status;
  final dynamic data;

  AlertResponse({this.title, this.status, this.data});

  @override
  String toString() {
    return 'AlertResponse{title: $title, status: $status, data: $data}';
  }
}
