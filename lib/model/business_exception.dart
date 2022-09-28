part of main_class.model;

class BusinessException implements Exception {
  final String message;
  final Map<String, String>? args;
  final dynamic cause;

  const BusinessException([
    this.message = "",
    this.cause,
    this.args,
  ]);

  String toString() {
    return "BusinessException[message=$message, cause=$cause, args=$args ]";
  }
}
