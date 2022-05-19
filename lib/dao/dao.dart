part of main_class.dao;

abstract class DAO<M extends Model> {
  Future<M> save(M model);

  Future<void> delete(String id);

  Future<M?> get(String id);
}
