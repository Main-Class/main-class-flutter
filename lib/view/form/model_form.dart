part of main_class.view;

class ModelForm<M extends Model> extends PlainForm<M, M> {
  ModelForm({
    required ModelFormBloc<M> bloc,
    required M initialModel,
    String buttonText = "Salvar",
    SubmitCallback<M>? onSubmit,
    required PlainFormBuilder<M> formBuilder,
    ErrorCallback? onSubmitError,
  }) : super(
          bloc: bloc,
          initialModel: initialModel,
          onSubmitSuccess: onSubmit,
          buttonText: buttonText,
          formBuilder: formBuilder,
          onSubmitError: onSubmitError,
        );
}
