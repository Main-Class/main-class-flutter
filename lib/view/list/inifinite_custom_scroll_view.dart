part of main_class.view;

class InfiniteCustomScrollView<M extends Model, Q extends Query>
    extends StatelessWidget {
  final InfiniteListBloc<M, Q> bloc;
  final ItemBuilder<M, Q> itemBuilder;
  final int? placeholderCount;
  final EdgeInsetsGeometry? padding;
  final List<Widget> preSlivers;
  final List<Widget> posSlivers;
  final SeparatorBuilder<M>? separatorBuilder;
  final EmptyStateBuilder<Q>? emptyStateBuilder;

  const InfiniteCustomScrollView({
    Key? key,
    required this.bloc,
    required this.itemBuilder,
    this.preSlivers = const [],
    this.posSlivers = const [],
    this.placeholderCount,
    this.padding,
    this.separatorBuilder,
    this.emptyStateBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: _buildContent(context),
      onRefresh: bloc.refresh,
    );
  }

  _buildContent(BuildContext context) {
    return StreamBuilder<SnapshotInfiniteList<M, Q>>(
        stream: bloc.listStream,
        initialData: bloc.list,
        builder: (context, snapshot) {
          SnapshotInfiniteList<M, Q> list = snapshot.data!;

          if ((list.data?.isEmpty ?? true) &&
              list.nextPageRef == null &&
              list.state == InfiniteListState.success) {
            return CustomScrollView(
              slivers: [
                ...preSlivers,
                new SliverList(
                  delegate: SliverChildListDelegate([
                    _buildEmptyState(context, list.query),
                  ]),
                ),
                ...posSlivers,
              ],
            );
          } else {
            return CustomScrollView(
              slivers: [
                ...preSlivers,
                new SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (list.data == null || index >= list.data!.length) {
                        if (list.state == InfiniteListState.error) {
                          return _buildError(context, list.error);
                        } else {
                          if (list.hasNext &&
                              list.state != InfiniteListState.quering) {
                            bloc.nextPage();
                          }

                          return _buildLoading(context, list);
                        }
                      }

                      return Column(
                        children: <Widget>[
                          if (index == 0 && separatorBuilder != null)
                            separatorBuilder!(context, null, list.data![index]),
                          itemBuilder(
                              context, list.data![index], list.query, index),
                          if (separatorBuilder != null)
                            separatorBuilder!(
                                context,
                                list.data![index],
                                index == list.data!.length - 1
                                    ? null
                                    : list.data![index + 1]),
                        ],
                      );
                    },
                    childCount: (list.data?.length ?? 0) +
                        (list.state != InfiniteListState.success || list.hasNext
                            ? 1
                            : 0),
                  ),
                ),
                ...posSlivers
              ],
            );
          }
        });
  }

  Widget _buildEmptyState(BuildContext context, Q query) {
    if (emptyStateBuilder != null) {
      return Container(
        padding: padding,
        width: double.infinity,
        child: emptyStateBuilder!(context, query),
      );
    }

    return Container(
      padding: EdgeInsets.all(50),
      width: double.infinity,
      child: Text(
        "Nenhum registro encontrado.",
        style: TextStyle(color: Colors.black54),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildError(BuildContext context, dynamic error) {
    return Container(
      padding: EdgeInsets.all(50),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error,
            color: Colors.black38,
            size: 66,
          ),
          const SizedBox(
            height: 10,
          ),
          DefaultTextStyle(
            child: Text(error is BusinessException
                ? error.message
                : "Oooops! Ocorreu um erro na consulta!."),
            style: TextStyle(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          RawMaterialButton(
            padding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              side: const BorderSide(
                color: Colors.black54,
                width: .5,
              ),
            ),
            onPressed: bloc.refresh,
            child: const Text(
              "Tentar Novamente",
              style: TextStyle(color: Colors.black54),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLoading(BuildContext context, SnapshotInfiniteList<M, Q> list) {
    if (placeholderCount != null) {
      List<Widget> ws = [];

      for (int i = 0; i < placeholderCount!; i++) {
        if (separatorBuilder != null && i > 0) {
          ws.add(separatorBuilder!(context, null, null));
        }

        ws.add(itemBuilder(context, null, list.query, i));
      }

      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: ws,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}
