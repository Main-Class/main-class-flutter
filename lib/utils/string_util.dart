part of main_class.utils;

extension StringExtension on String {
  String get formatedAsTelefone {
    String formatado = "";
    String tel = unformated;

    if (tel.length > 11) {
      formatado =
          "${tel.substring(0, 2)} ${tel.substring(2, 7)} ${tel.substring(7, 11)}";
    } else if (tel.length > 10) {
      formatado =
          "${tel.substring(0, 2)} ${tel.substring(2, 7)} ${tel.substring(7)}";
    } else if (tel.length > 6) {
      formatado =
          "${tel.substring(0, 2)} ${tel.substring(2, 6)} ${tel.substring(6)}";
    } else if (tel.length > 2) {
      formatado = "${tel.substring(0, 2)} ${tel.substring(2)}";
    } else if (tel.length > 0) {
      formatado = "$tel";
    }

    return formatado;
  }

  String get formatedAsCpfCnpj {
    String formatado = "";
    String cc = unformated;

    if (cc.length > 12) {
      formatado =
          "${cc.substring(0, 2)}.${cc.substring(2, 5)}.${cc.substring(5, 8)}/${cc.substring(8, 12)}-${cc.substring(12)}";
    } else if (cc.length > 11) {
      formatado =
          "${cc.substring(0, 2)}.${cc.substring(2, 5)}.${cc.substring(5, 8)}/${cc.substring(8)}";
    } else if (cc.length > 9) {
      formatado =
          "${cc.substring(0, 3)}.${cc.substring(3, 6)}.${cc.substring(6, 9)}-${cc.substring(9)}";
    } else if (cc.length > 6) {
      formatado =
          "${cc.substring(0, 3)}.${cc.substring(3, 6)}.${cc.substring(6)}";
    } else if (cc.length > 3) {
      formatado = "${cc.substring(0, 3)}.${cc.substring(3)}";
    } else if (cc.length > 0) {
      formatado = "$cc";
    }

    return formatado;
  }

  String get formatedAsCEP {
    String formatado = "";
    String cepUnformatted = unformated;

    if (cepUnformatted.length > 5) {
      formatado =
          "${cepUnformatted.substring(0, 2)}.${cepUnformatted.substring(2, 5)}-${cepUnformatted.substring(5)}";
    } else if (cepUnformatted.length > 2) {
      formatado =
          "${cepUnformatted.substring(0, 2)}.${cepUnformatted.substring(2)}";
    } else if (cepUnformatted.length > 0) {
      formatado = "$cepUnformatted";
    }

    return formatado;
  }

  String get unformated {
    return replaceAll(RegExp("[^0-9]"), "");
  }

  String get firstWord {
    if (contains(" ")) {
      return split(" ")[0];
    }

    return this;
  }
}
