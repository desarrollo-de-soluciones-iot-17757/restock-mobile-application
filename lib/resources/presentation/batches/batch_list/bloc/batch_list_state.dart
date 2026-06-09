import 'package:restock/resources/domain/entities/batch.dart';
import 'package:restock/resources/presentation/batches/batch_list/bloc/batch_list_event.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class BatchListState {
  const BatchListState({
    this.status = Status.initial,
    this.batches = const [],
    this.searchQuery = '',
    this.stockFilter = BatchStockFilter.any,
    this.message,
  });

  final Status status;
  final List<Batch> batches;
  final String searchQuery;
  final BatchStockFilter stockFilter;
  final String? message;

  List<Batch> get filteredBatches {
    final normalizedQuery = searchQuery.trim().toLowerCase();

    return batches.where((batch) {
      final matchesSearch =
          normalizedQuery.isEmpty ||
          batch.code.toLowerCase().contains(normalizedQuery) ||
          batch.customSupplyId.toLowerCase().contains(normalizedQuery) ||
          (batch.customSupplyName?.toLowerCase().contains(normalizedQuery) ??
              false);

      if (!matchesSearch) return false;

      return switch (stockFilter) {
        BatchStockFilter.any => true,
        BatchStockFilter.low =>
          batch.minimumStock != null
              ? batch.currentStock <= batch.minimumStock!
              : batch.currentStock <= 0,
        BatchStockFilter.available => batch.currentStock > 0,
      };
    }).toList();
  }

  bool get isSearching => searchQuery.trim().isNotEmpty;

  int get nearExpiryCount {
    final now = DateTime.now();
    final limit = now.add(const Duration(days: 30));

    return batches.where((batch) {
      final expirationDate = batch.expirationDate;
      if (expirationDate == null) return false;

      return !expirationDate.isBefore(now) && !expirationDate.isAfter(limit);
    }).length;
  }

  BatchListState copyWith({
    Status? status,
    List<Batch>? batches,
    String? searchQuery,
    BatchStockFilter? stockFilter,
    String? message,
  }) {
    return BatchListState(
      status: status ?? this.status,
      batches: batches ?? this.batches,
      searchQuery: searchQuery ?? this.searchQuery,
      stockFilter: stockFilter ?? this.stockFilter,
      message: message ?? this.message,
    );
  }
}
