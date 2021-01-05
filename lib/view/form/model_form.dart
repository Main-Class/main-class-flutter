part of main_class.view;

class ModelForm<M extends Model> extends PlainForm<M, M> {
  ModelForm({
    ModelFormBloc<M> bloc,
    M initialModel,
    String buttonText = "Salvar",
    SubmitCallback<M> onSubmit,
    PlainFormBuilder<M> formBuilder,
    ErrorCallback onSubmitError,
  }) : super(
          bloc: bloc,
          initialModel: initialModel,
          onSubmitSuccess: onSubmit,
          buttonText: buttonText,
          formBuilder: formBuilder,
          onSubmitError: onSubmitError,
        );
}
