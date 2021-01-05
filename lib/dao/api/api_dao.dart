part of main_class.dao.api;

class ApiDAO<M extends Model> implements DAO<M> {
  final ApiClient client;
  final String basePath;
  final JsonDecoder<M> decoder;
  final JsonEncoder<M> encoder;

  ApiDAO({
    this.client,
    this.basePath,
    this.encoder,
    this.decoder,
  });

  @override
  Future<M> save(M model) async {
    return await client.put(
      basePath,
      body: model,
      toJson: encoder,
      fromJson: decoder,
    );
  }

  @override
  Future<void> delete(String id) async {
    await client.delete("$basePath/$id");
  }

  @override
  Future<M> get(String id) async {
    return await client.get("$basePath/$id", fromJson: decoder);
  }

}
