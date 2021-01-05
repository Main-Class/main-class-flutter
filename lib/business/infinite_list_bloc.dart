part of main_class.business;

enum InfiniteListState {
  waiting,
  quering,
  success,
  error,
}

class SnapshotInfiniteList<M extends Model, Q extends Query> {
  final List<M> data;
  final InfiniteListState state;
  final Q query;
  final dynamic error;
  final dynamic nextPageRef;
  final int total;

  const SnapshotInfiniteList({
    this.data,
    this.state,
    this.query,
    this.error,
    this.nextPageRef,
    this.total,
  });

  bool get hasNext => nextPageRef != null;

  SnapshotInfiniteList<M, Q> copyWith({
    List<M> data,
    InfiniteListState state,
    Q query,
    dynamic error,
    dynamic nextPageRef,
    bool forceNextPageRef = false,
    int total,
  }) {
    return new SnapshotInfiniteList<M, Q>(
      data: data ?? this.data,
      state: state ?? this.state,
      query: query ?? this.query,
      error: (state ?? this.state) == InfiniteListState.error
          ? (error ?? this.error)
          : null,
      nextPageRef: nextPageRef ?? (forceNextPageRef ? null : this.nextPageRef),
      total: total ?? this.total,
    );
  }
}

abstract class InfiniteListBloc<M extends Model, Q extends Query>
    implements Bloc {
  BehaviorSubject<SnapshotInfiniteList<M, Q>> items;

  final QueryDAO<M, Q> queryDAO;

  final Q rootQuery;

  SnapshotInfiniteList<M, Q> get list => items.value;

  Stream<SnapshotInfiniteList<M, Q>> get listStream => items.stream;

  InfiniteListBloc({
    this.queryDAO,
    this.rootQuery,
  })  : assert(queryDAO != null),
        assert(rootQuery != null);

  Future<Page<M>> doQuery(Q query) async {
    return await queryDAO.query(query);
  }

  Future<Page<M>> query(Q query, {bool reset = false}) async {
    items.add(items.value.copyWith(
      data: reset ? [] : null,
      state: InfiniteListState.quering,
    ));

    try {
      Page<M> page = await doQuery(query);

      items.add(
        items.value.copyWith(
          state: InfiniteListState.success,
          nextPageRef: page.nextPageRef,
          forceNextPageRef: true,
          query: query,
          data: [
            ...items.value.data,
            ...page.result,
          ],
          total: page.total,
        ),
      );

      return page;
    } catch (e, stack) {
      items.add(items.value.copyWith(
        state: InfiniteListState.error,
        error: e,
      ));

      throw e;
    }
  }

  Future<Page<M>> nextPage() {
    Q q = items.value.query.copyWith();
    q.pageRef = items.value.nextPageRef;
    return query(q);
  }

  @override
  void dispose() {
    items.close();
  }

  @override
  Future<void> init() async {
    items = new BehaviorSubject<SnapshotInfiniteList<M, Q>>.seeded(
      SnapshotInfiniteList(
        data: const [],
        query: rootQuery,
        state: InfiniteListState.waiting,
      ),
    );

    query(rootQuery);
  }

  Future<Page<M>> refresh() async {
    return await query(rootQuery, reset: true);
  }
}
