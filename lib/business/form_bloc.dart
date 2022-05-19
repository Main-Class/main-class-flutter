part of main_class.business;

abstract class FormBloc<I, O> implements Bloc {
  late BehaviorSubject<I> _model;

  I get model => _model.value;

  Stream<I> get stream => _model.stream;

  set(I model) {
    _model.add(model);
  }

  Future<O> submit();

  @override
  Future<void> init() async {
    _model = new BehaviorSubject();
  }

  @override
  void dispose() {
    _model.close();
  }
}
