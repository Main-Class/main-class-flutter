part of main_class.view;

enum TipoMensagem { success, error, warning }

class Mensagem extends SnackBar {
  Mensagem({
    required String mensagem,
    TipoMensagem tipo = TipoMensagem.success,
  }) : super(
          backgroundColor: _color(tipo),
          duration: Duration(seconds: 4),
          content: Row(
            children: <Widget>[
              Expanded(
                child: DefaultTextStyle(
                  child: Builder(
                    builder: (context) {
                      TextBuilder textBuilder = MensagemTextBuilder.of(context);
                      return textBuilder(context, mensagem);
                    },
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _icon(tipo),
            ],
          ),
        );

  factory Mensagem.error(String mensagem) {
    return Mensagem(
      tipo: TipoMensagem.error,
      mensagem: mensagem,
    );
  }

  factory Mensagem.warning(String mensagem) {
    return Mensagem(
      tipo: TipoMensagem.warning,
      mensagem: mensagem,
    );
  }

  factory Mensagem.success(String mensagem) {
    return Mensagem(
      tipo: TipoMensagem.success,
      mensagem: mensagem,
    );
  }

  static Color _color(TipoMensagem tipo) {
    if (tipo == TipoMensagem.error) {
      return Colors.red[900]!;
    } else if (tipo == TipoMensagem.warning) {
      return Colors.yellow[900]!;
    } else {
      return Colors.green[900]!;
    }
  }

  static Widget _icon(TipoMensagem tipo) {
    if (tipo == TipoMensagem.error) {
      return Icon(
        Icons.error,
        color: Colors.white,
      );
    } else if (tipo == TipoMensagem.warning) {
      return Icon(
        Icons.warning,
        color: Colors.white,
      );
    } else {
      return Icon(
        Icons.check_circle,
        color: Colors.white,
      );
    }
  }

  show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(this);
  }
}
