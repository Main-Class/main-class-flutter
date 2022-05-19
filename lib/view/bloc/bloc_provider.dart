part of main_class.view;

class BlocProvider<T extends Bloc> extends StatefulWidget {
  final T bloc;
  final Widget child;

  const BlocProvider({
    Key? key,
    required this.bloc,
    required this.child,
  })  : assert(bloc != null),
        assert(child != null),
        super(key: key);

  static T? of<T extends Bloc>(BuildContext context) {
    assert(context != null);

    BlocProviderState<T>? state =
        context.findAncestorStateOfType<BlocProviderState<T>>();

    return state?.bloc;
  }

  @override
  BlocProviderState<T> createState() => BlocProviderState<T>();
}

class BlocProviderState<T extends Bloc> extends State<BlocProvider<T>> {
  late T bloc;

  @override
  void initState() {
    super.initState();

    bloc = widget.bloc;

    widget.bloc.init();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    super.dispose();

    bloc.dispose();
  }
}
