
class RequestSettings {
  String endPoint;
  bool authenticated;
  String method;
  dynamic params;

  RequestSettings(this.endPoint, this.method, { this.params, this.authenticated = true });
}