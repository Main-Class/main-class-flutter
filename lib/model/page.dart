part of main_class.model;


class Page<M extends Model> {
  final List<M> result;
  final dynamic nextPageRef;
  final int? total;

  bool get hasNext => this.nextPageRef != null;

  const Page({
    required this.result,
    this.total,
    this.nextPageRef,
  });

}
