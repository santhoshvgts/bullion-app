import 'package:bullion/core/models/api/api_error_response.dart';

class ApiException implements Exception {
  ApiException(this.error);
  final ErrorResponse error;
  @override
  String toString() {
    return error as String? ?? error.toString();
  }
}
