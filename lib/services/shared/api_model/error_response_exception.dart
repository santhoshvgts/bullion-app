import '../../../core/models/api/api_error_response.dart';

class ErrorResponseException {
  ErrorResponse? error;

  ErrorResponseException({this.error});

  @override
  String toString() {
    return 'ErrorResponseException{error: $error}';
  }
}
