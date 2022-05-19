part of main_class.view;

typedef ItemBuilder<T extends Model, Q extends Query> = Widget Function(
    BuildContext context, T? item, Q query, int index);
typedef EmptyStateBuilder<Q extends Query> = Widget Function(
    BuildContext context, Q query);
typedef SeparatorBuilder<M extends Model> = Widget Function(
    BuildContext context, M? before, M? after);
