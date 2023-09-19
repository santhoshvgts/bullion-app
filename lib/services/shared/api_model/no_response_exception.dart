import 'dart:core';

class NoResponseException {
  String? message;
  StackTrace? stacktrace;

  NoResponseException({required String message}) {
    this.message = message;
    this.stacktrace = StackTrace.current;
  }

  @override
  String toString() {
    return "NoResponseException: message: ${message}\nstacktrace: ${stacktrace.toString()}";
  }
}
