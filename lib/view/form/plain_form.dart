part of main_class.view;

typedef ErrorCallback = Function(dynamic ex, dynamic stack);
typedef SubmitCallback<O> = Function(O output);
typedef PlainFormBuilder<T> = Widget Function(
    BuildContext context, T model, SetModelCallback setModel);

class PlainForm<I, O> extends ManualForm<I, O> {
  PlainForm({
    @required FormBloc<I, O> bloc,
    SubmitCallback<O> onSubmitSuccess,
    String buttonText = "Submeter",
    @required I initialModel,
    @required PlainFormBuilder<I> formBuilder,
    ErrorCallback onSubmitError,
  })  : assert(formBuilder != null),
        assert(buttonText != null),
        assert(initialModel != null),
        assert(bloc != null),
        super(
          initialModel: initialModel,
          bloc: bloc,
          formBuilder: _buildForm(
            onSubmitError: onSubmitError,
            formBuilder: formBuilder,
            buttonText: buttonText,
            onSubmit: onSubmitSuccess,
          ),
        );

  static FormBuilder<I, O> _buildForm<I, O>({
    SubmitCallback<O> onSubmit,
    String buttonText = "Submeter",
    @required PlainFormBuilder<I> formBuilder,
    ErrorCallback onSubmitError,
  }) {
    return (BuildContext context, I model, SetModelCallback setModel,
        Submitter<O> submit, Resetter<I> resetter) {
      return Column(children: <Widget>[
        formBuilder(
          context,
          model,
          setModel,
        ),
        _buildSubmitButton(
          context: context,
          onSubmit: onSubmit,
          buttonText: buttonText,
          onSubmitError: onSubmitError,
          submit: submit,
        ),
      ]);
    };
  }

  static Widget _buildSubmitButton<O>({
    BuildContext context,
    SubmitCallback<O> onSubmit,
    String buttonText = "Submeter",
    ErrorCallback onSubmitError,
    Submitter<O> submit,
  }) {
    var _submit = () async {
      var output = await submit();

      if (onSubmit != null) {
        onSubmit(output);
      }
    };

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: CommandButton(
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        onPressed: (loading) async {
          try {
            await loading(_submit());
          } on BusinessException catch (ex, stack) {
            if (onSubmitError != null) {
              onSubmitError(ex, stack);
            }
            rethrow;
          } catch (ex, stack) {
            if (onSubmitError != null) {
              onSubmitError(ex, stack);
            }
            rethrow;
          }
        },
      ),
    );
  }
}
