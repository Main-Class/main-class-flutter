part of main_class.utils;


extension IntExtension on int {

  String get formatedAsBytes {
    if (this > 1024) {
      var kilo = this ~/ 1024;
      if (kilo > 1024) {
        var mega = kilo ~/ 1024;
        if (mega > 1024) {
          var giga = mega ~/ 1024;

          return "${giga}GB";
        }

        return "${mega}MB";
      }

      return "${kilo}KB";
    }

    return "${this}B";
  }

}
