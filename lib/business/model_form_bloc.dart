part of main_class.business;

class ModelFormBloc<M extends Model> extends FormBloc<M, M> {
  DAO<M> dao;

  ModelFormBloc({required this.dao});

  Future<M?> load(String id) async {
    M? model = await dao.get(id);

    if (model != null) {
      set(model);
    }

    return model;
  }

  @override
  Future<M> submit() async {
    return await dao.save(model);
  }
}
