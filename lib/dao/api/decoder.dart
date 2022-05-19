part of main_class.dao.api;

typedef PageDecoder<M extends Model> = Page<M> Function(
    Map<String, dynamic> json);

typedef ListDecoder<M extends Model> = List<M> Function(
    Map<String, dynamic> json);

PageDecoder<M> pageDecoder<M extends Model>(JsonDecoder<M> modelDecoder) {
  return (json) {
    return Page(
      nextPageRef: (json['hasProxima'] ?? false)
          ? int.parse(json['paginaAtual'].toString()) + 1
          : null,
      result: (json['itens'] as List?)
              ?.map((e) => e as Map<String, dynamic>)
              .map(modelDecoder)
              .toList() ??
          [],
      total: int.parse(json['totalItens'].toString()),
    );
  };
}
