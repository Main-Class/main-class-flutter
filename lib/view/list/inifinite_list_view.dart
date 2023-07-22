part of main_class.view;

class InfiniteListView<T extends Model, Q extends Query>
    extends StatelessWidget {
  const InfiniteListView({
    required this.bloc,
    required this.itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.reverse = false,
    this.separatorBuilder,
    this.emptyStateBuilder,
    this.emptyStateMessage,
    this.loadingStateBuilder,
    this.defaultErrorMessage,
    this.tryAgainText,
  })  : assert(bloc != null),
        assert(scrollDirection != null),
        assert(itemBuilder != null);

  final bool reverse;
  final InfiniteListBloc<T, Q> bloc;
  final ItemBuilder<T, Q> itemBuilder;
  final Axis scrollDirection;
  final EdgeInsetsGeometry? padding;
  final SeparatorBuilder<T>? separatorBuilder;
  final EmptyStateBuilder<Q>? emptyStateBuilder;
  final LoadingStateBuilder<Q>? loadingStateBuilder;
  final String? emptyStateMessage;
  final String? defaultErrorMessage;
  final String? tryAgainText;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: _buildContent(context),
      onRefresh: bloc.refresh,
    );
  }

  _buildContent(BuildContext context) {
    return StreamBuilder<SnapshotInfiniteList<T, Q>>(
        stream: bloc.listStream,
        initialData: bloc.list,
        builder: (context, snapshot) {
          SnapshotInfiniteList<T, Q> list = snapshot.data!;

          if ((list.data?.isEmpty ?? true) &&
              list.nextPageRef == null &&
              list.state == InfiniteListState.success) {
            return _buildEmptyState(context, list.query);
          }

          return ListView.separated(
            separatorBuilder: (context, index) {
              if (separatorBuilder != null) {
                return separatorBuilder!(
                  context,
                  index < list.data!.length ? list.data![index] : null,
                  index < list.data!.length - 1 ? list.data![index + 1] : null,
                );
              }

              return Container();
            },
            padding: padding,
            reverse: reverse,
            scrollDirection: scrollDirection,
            itemCount: (list.data?.length ?? 0) +
                (list.state != InfiniteListState.success || list.hasNext
                    ? 1
                    : 0),
            itemBuilder: (context, index) {
              if (list.data == null || index >= list.data!.length) {
                if (list.state == InfiniteListState.error) {
                  return _buildError(context, list.error);
                } else {
                  if (list.hasNext && list.state != InfiniteListState.quering) {
                    bloc.nextPage();
                  }

                  return _buildLoading(context, list.query);
                }
              }
              return Column(
                verticalDirection:
                    reverse ? VerticalDirection.up : VerticalDirection.down,
                children: <Widget>[
                  if (index == 0 && separatorBuilder != null)
                    separatorBuilder!(context, null, list.data![index]),
                  itemBuilder(context, list.data![index], list.query, index),
                  if (index == list.data!.length - 1 &&
                      separatorBuilder != null)
                    separatorBuilder!(context, list.data![index], null),
                ],
              );
            },
          );
        });
  }

  Widget _buildEmptyState(BuildContext context, Q query) {
    if (emptyStateBuilder != null) {
      return SingleChildScrollView(
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: emptyStateBuilder!(context, query),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(50),
      width: double.infinity,
      child: Text(
        emptyStateMessage ?? "Nenhum registro encontrado.",
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
                : (defaultErrorMessage ??
                    "Oooops! Ocorreu um erro na consulta!.")),
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
            child: Text(tryAgainText ?? "Tentar Novamente"),
          )
        ],
      ),
    );
  }

  Widget _buildLoading(BuildContext context, Q query) {
    if (loadingStateBuilder != null) {
      return loadingStateBuilder!(context, query);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}
