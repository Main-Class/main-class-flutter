part of main_class.dao;

abstract class QueryDAO<M extends Model, Q extends Query> {
  Future<Page<M>> query(Q query);
}
