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

FormFieldValidator<String> notEmpty() {
  return (String? valor) {
    if (valor == null || valor.isEmpty) {
      return "Campo obrigatório.";
    }

    return null;
  };
}

FormFieldValidator<T> notNull<T>() {
  return (T? valor) {
    if (valor == null) {
      return "Campo obrigatório.";
    }

    return null;
  };
}

FormFieldValidator<String> email() {
  return (String? valor) {
    if (valor != null &&
        valor.isNotEmpty &&
        !RegExp("^.+@.+\$").hasMatch(valor)) {
      return "E-mail inválido.";
    }

    return null;
  };
}

FormFieldValidator<String> length({int? max, int? min}) {
  return (String? valor) {
    if (valor != null && valor.isNotEmpty) {
      if (min != null && min > valor.length) {
        return "Deve possuir no mínimo $min caracteres.";
      }

      if (max != null && max < valor.length) {
        return "Deve possuir no máximo $max caracteres.";
      }
    }

    return null;
  };
}
