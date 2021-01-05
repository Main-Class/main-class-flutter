part of main_class.dao.api;

class ApiQueryDAO<M extends Model, Q extends Query> implements QueryDAO<M, Q> {
  final ApiClient client;
  final String basePath;
  final JsonEncoder<Q> queryEncoder;
  final JsonDecoder<M> modelDecoder;

  ApiQueryDAO({
    this.client,
    this.basePath,
    this.modelDecoder,
    this.queryEncoder,
  });

  @override
  Future<Page<M>> query(Q query) async {
    return await client.get(
      basePath,
      queryParams: queryEncoder(query),
      fromJson: pageDecoder(modelDecoder),
    );
  }
}
