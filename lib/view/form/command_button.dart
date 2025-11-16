part of main_class.view;

typedef LodingWrapper = Future<T?> Function<T>(Future<T?> future);
typedef CommandCallback = Function(LodingWrapper loading);

class CommandButton extends StatefulWidget {
  final Widget? child;
  final CommandCallback? onPressed;
  final ButtonStyle style;

  CommandButton({this.child, this.onPressed, ButtonStyle? style})
    : style = style ??= ElevatedButton.styleFrom();

  @override
  _CommandButtonState createState() => _CommandButtonState();
}

class _CommandButtonState extends State<CommandButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: widget.style,
      child: _buildChild(),
      onPressed: !_loading && widget.onPressed != null ? _act : null,
    );
  }

  _buildChild() {
    return AnimatedCrossFade(
      firstChild: widget.child ?? Container(),
      secondChild: _buildLoader(context),
      crossFadeState:
          _loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildLoader(BuildContext context) {
    final theme = Theme.of(context);

    // 1) Pega o estilo base do ElevatedButton no tema
    final ButtonStyle? themeStyle = theme.elevatedButtonTheme.style;

    // 2) Estilo final = tema.merge(style do widget)
    final ButtonStyle effectiveStyle = (themeStyle ?? const ButtonStyle())
        .merge(widget.style);

    // 3) Resolve estados (botão "normal")
    const Set<WidgetState> states = {};

    final TextStyle? textStyle =
        effectiveStyle.textStyle?.resolve(states) ?? theme.textTheme.labelLarge;

    final Color foregroundColor =
        effectiveStyle.foregroundColor?.resolve(states) ??
        theme.colorScheme.onPrimary;

    final double fontSize = textStyle?.fontSize ?? 14.0;

    return Padding(
      padding: const EdgeInsets.all(1),
      child: SizedBox(
        height: fontSize - 2,
        width: fontSize - 2,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        ),
      ),
    );
  }

  _act() {
    widget.onPressed!(_interceptor);
  }

  Future<T?> _interceptor<T>(Future<T?> future) async {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      FocusScope.of(context).requestFocus(FocusNode());

      setState(() {
        _loading = true;
      });

      return await future;
    } on BusinessException catch (ex) {
      scaffoldMessenger.showSnackBar(Mensagem.error(ex.message));
      rethrow;
    } on AbortException catch (ex) {
      // Ignorado
    } catch (ex, stack) {
      print(
        "[MAIN CLASS] ERRO NÃO TRATADO: " +
            ex.toString() +
            "\n" +
            stack.toString(),
      );
      rethrow;
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
