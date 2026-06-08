sealed class BatchListEvent {
  const BatchListEvent();
}

class BatchListStarted extends BatchListEvent {
  const BatchListStarted();
}

class BatchSearchChanged extends BatchListEvent {
  const BatchSearchChanged(this.query);

  final String query;
}

class BatchStockFilterChanged extends BatchListEvent {
  const BatchStockFilterChanged(this.filter);

  final BatchStockFilter filter;
}

enum BatchStockFilter { any, low, available }
