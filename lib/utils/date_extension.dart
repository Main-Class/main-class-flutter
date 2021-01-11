part of main_class.utils;

extension DateTimeExtension on DateTime {
  get formatedAsIso {
    return formated("yyyy-MM-dd'T'HH:mm:ss.SSS") + "Z";
  }

  String formated([String pattern = "dd/MM/yyyy"]) {
    return DateFormat(pattern).format(this);
  }
}
