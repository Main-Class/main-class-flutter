part of main_class.view;

TextEditingValue formatNumber(
    String format, TextEditingValue antigo, TextEditingValue novo) {
  String formatado = novo.text.getFormated(format);

  int offset = formatado.length;

  if (novo.selection.start != novo.text.length) {
    offset = math.min(formatado.length, novo.selection.start);
  }

  return TextEditingValue(
      text: formatado,
      selection: TextSelection.fromPosition(TextPosition(offset: offset)));
}

TextEditingValue formatTelefone(
    TextEditingValue antigo, TextEditingValue novo) {
  String formatado = novo.text.formatedAsTelefone;

  int offset = formatado.length;

  if (novo.selection.start != novo.text.length) {
    offset = math.min(formatado.length, novo.selection.start);
  }

  return TextEditingValue(
      text: formatado,
      selection: TextSelection.fromPosition(TextPosition(offset: offset)));
}

TextEditingValue formatCpfCnpj(TextEditingValue antigo, TextEditingValue novo) {
  String formatado = novo.text.formatedAsCpfCnpj;

  int offset = formatado.length;

  if (novo.selection.start != novo.text.length) {
    offset = math.min(formatado.length, novo.selection.start);
  }

  return TextEditingValue(
      text: formatado,
      selection: TextSelection.fromPosition(TextPosition(offset: offset)));
}

TextEditingValue formatCEP(TextEditingValue antigo, TextEditingValue novo) {
  String formatado = novo.text..formatedAsCEP;

  int offset = formatado.length;

  if (novo.selection.start != novo.text.length) {
    offset = math.min(formatado.length, novo.selection.start);
  }

  return TextEditingValue(
      text: formatado,
      selection: TextSelection.fromPosition(TextPosition(offset: offset)));
}
