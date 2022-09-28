part of main_class.view;

FormFieldValidator<T> validate<T>(List<FormFieldValidator<T>> validators) {
  return (T? valor) {
    for (FormFieldValidator<T> val in validators) {
      var msg = val(valor);
      if (msg != null) {
        return msg;
      }
    }

    return null;
  };
}

FormFieldValidator<String> notEmpty({String? mensagem}) {
  return (String? valor) {
    if (valor == null || valor.isEmpty) {
      return mensagem ?? "Campo obrigatório.";
    }

    return null;
  };
}

FormFieldValidator<T> notNull<T>({String? mensagem}) {
  return (T? valor) {
    if (valor == null) {
      return mensagem ?? "Campo obrigatório.";
    }

    return null;
  };
}

FormFieldValidator<String> email({String? mensagem}) {
  return (String? valor) {
    if (valor != null &&
        valor.isNotEmpty &&
        !RegExp("^.+@.+\$").hasMatch(valor)) {
      return mensagem ?? "E-mail inválido.";
    }

    return null;
  };
}

FormFieldValidator<String> length(
    {int? max, int? min, String? mensagemMax, String? mensagemMin}) {
  return (String? valor) {
    if (valor != null && valor.isNotEmpty) {
      if (min != null && min > valor.length) {
        return mensagemMin ?? "Deve possuir no mínimo $min caracteres.";
      }

      if (max != null && max < valor.length) {
        return mensagemMax ?? "Deve possuir no máximo $max caracteres.";
      }
    }

    return null;
  };
}
