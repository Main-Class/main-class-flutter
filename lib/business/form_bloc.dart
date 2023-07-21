part of main_class.business;

abstract class FormBloc<I, O> implements Bloc {
  late ReplaySubject<I> _model;

  I get model => _model.values.first;

  I? get modelOrNull => _model.values.isEmpty ? null : _model.values.first;

  Stream<I> get stream => _model.stream;

  set(I model) {
    _model.add(model);
  }

  Future<O> submit();

  @override
  Future<void> init() async {
    _model = new ReplaySubject(maxSize: 1);
  }

  @override
  void dispose() {
    _model.close();
  }
}
