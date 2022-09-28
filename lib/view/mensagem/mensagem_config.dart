part of main_class.view;

typedef TextBuilder = Widget Function(BuildContext context, String text);

class MensagemTextBuilder extends StatefulWidget {
  final TextBuilder textBuilder;
  final Widget child;

  const MensagemTextBuilder({
    Key? key,
    required this.textBuilder,
    required this.child,
  }) : super(key: key);

  static TextBuilder of(BuildContext context) {
    assert(context != null);

    MensagemTextBuilderState? state =
        context.findAncestorStateOfType<MensagemTextBuilderState>();

    return state?.widget.textBuilder ?? (context, text) => Text(text);
  }

  @override
  MensagemTextBuilderState createState() => MensagemTextBuilderState();
}

class MensagemTextBuilderState extends State<MensagemTextBuilder> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
