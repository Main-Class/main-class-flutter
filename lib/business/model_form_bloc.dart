part of main_class.business;

class ModelFormBloc<M extends Model> extends FormBloc<M, M> {
  DAO<M> dao;

  ModelFormBloc({this.dao});

  Future<M> load(String id) async {
    M model = await dao.get(id);
    set(model);
    return model;
  }

  @override
  Future<M> submit() async {
    return await dao.save(model);
  }
}
