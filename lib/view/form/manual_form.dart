part of main_class.view;

typedef Submitter<O> = Future<O> Function();
typedef Resetter<I> = Future<void> Function(I input);
typedef SetModelCallback = Function(VoidCallback);
typedef FormBuilder<I, O> = Widget Function(BuildContext context, I model,
    SetModelCallback setModel, Submitter<O> submit, Resetter<I> resetter);

class ManualForm<I, O> extends StatelessWidget {
  const ManualForm({
    required this.bloc,
    required this.initialModel,
    required this.formBuilder,
  })  : assert(formBuilder != null),
        assert(initialModel != null),
        assert(bloc != null);

  final FormBloc<I, O> bloc;
  final I initialModel;
  final FormBuilder<I, O> formBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: _InnerManualForm(
        initialModel: initialModel,
        formBuilder: formBuilder,
      ),
    );
  }
}

class _InnerManualForm<I, O, B extends FormBloc<I, O>> extends StatefulWidget {
  const _InnerManualForm({
    required this.initialModel,
    this.disableSubmitOnInvalid = false,
    required this.formBuilder,
  })  : assert(formBuilder != null),
        assert(initialModel != null),
        assert(disableSubmitOnInvalid != null);

  final I initialModel;
  final bool disableSubmitOnInvalid;
  final FormBuilder<I, O> formBuilder;

  @override
  State<StatefulWidget> createState() => _InnerManualFormState<I, O, B>();
}

class _InnerManualFormState<I, O, B extends FormBloc<I, O>>
    extends State<_InnerManualForm<I, O, B>> {
  final GlobalKey<FormState> _form = new GlobalKey();

  @override
  void initState() {
    super.initState();

    BlocProvider.of<B>(context)!.set(widget.initialModel);
  }

  @override
  Widget build(BuildContext context) {
    B bloc = BlocProvider.of<B>(context)!;

    return Form(
      key: _form,
      child: StreamBuilder<I>(
        initialData: bloc.model,
        stream: bloc.stream,
        builder: (context, snapshot) {
          return widget.formBuilder(
            context,
            snapshot.data!,
            _setModel(bloc, snapshot.data!),
            () async => await _submit(bloc),
            (input) async => await _reset(bloc, input),
          );
        },
      ),
    );
  }

  Future<O> _submit(B bloc) async {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();

      return await bloc.submit();
    }

    throw new AbortException();
  }

  Future<void> _reset(B bloc, I input) async {
    _form.currentState!.reset();
    bloc.set(input);
  }

  _setModel(B bloc, I model) {
    return (VoidCallback function) {
      function();
      bloc.set(model);
    };
  }
}
