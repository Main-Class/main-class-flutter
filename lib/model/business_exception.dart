part of main_class.model;

class BusinessException implements Exception {
  final String message;
  final dynamic cause;

  const BusinessException([this.message = "", this.cause]);

  String toString() {
    return "BusinessException[message=$message, cause=$cause, ]";
  }
}
