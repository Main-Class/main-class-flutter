part of main_class.view;

typedef LodingWrapper = Future<T> Function<T>(Future<T> future);
typedef CommandCallback = Function(LodingWrapper loading);

class CommandButton extends StatefulWidget {
  final Widget child;
  final CommandCallback onPressed;
  final EdgeInsets padding;
  final ShapeBorder shape;
  final Color fillColor;
  final double elevation;

  CommandButton({
    this.child,
    this.onPressed,
    this.padding,
    this.shape,
    this.fillColor,
    this.elevation,
  });

  @override
  _CommandButtonState createState() => _CommandButtonState();
}

class _CommandButtonState extends State<CommandButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    ButtonThemeData buttonTheme = ButtonTheme.of(context);

    return RawMaterialButton(
      constraints: BoxConstraints(
        minWidth: buttonTheme?.minWidth ?? 54,
      ),
      padding: widget.padding ?? buttonTheme?.padding,
      shape: widget.shape ?? buttonTheme?.shape,
      fillColor: (widget.fillColor ?? buttonTheme?.colorScheme?.primary)
          .withOpacity(_loading || widget.onPressed == null ? .45 : 1),
      elevation: widget.elevation ?? 2,
      child: _buildChild(),
      onPressed: !_loading && widget.onPressed != null ? _act : null,
    );
  }

  _buildChild() {
    ThemeData theme = Theme.of(context);

    return AnimatedCrossFade(
      firstChild: DefaultTextStyle(
        style: (theme?.textTheme?.button ?? TextStyle()).copyWith(
          color: theme?.textTheme?.button?.color ?? Colors.black,
          fontSize: theme?.textTheme?.button?.fontSize ?? 14,
        ),
        child: widget.child,
      ),
      secondChild: _buildLoader(
        color: theme?.textTheme?.button?.color ?? Colors.black,
        fontSize: theme?.textTheme?.button?.fontSize ?? 14,
      ),
      crossFadeState:
          _loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildLoader({Color color, double fontSize}) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: SizedBox(
        height: fontSize - 2,
        width: fontSize - 2,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      ),
    );
  }

  _act() {
    widget.onPressed(_interceptor);
  }

  Future<T> _interceptor<T>(Future<T> future) async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());

      setState(() {
        _loading = true;
      });

      return await future;
    } on BusinessException catch (ex) {
      Mensagem.error(ex.message).show(context);
      rethrow;
    } on AbortException catch (ex) {
      // Ignorado
    } catch (ex, stack) {
      print("[MAIN CLASS] ERRO NÃO TRATADO: " + ex + "\n" + stack.toString());
      rethrow;
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
