import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:restock/resources/application/batch_facade_service.dart';
import 'package:restock/resources/presentation/batches/batch_list/bloc/batch_list_event.dart';
import 'package:restock/resources/presentation/batches/batch_list/bloc/batch_list_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class BatchListBloc extends Bloc<BatchListEvent, BatchListState> {
  BatchListBloc({required this.batchFacadeService})
    : super(const BatchListState()) {
    on<BatchListStarted>(_onStarted);
    on<BatchSearchChanged>(_onSearchChanged);
    on<BatchStockFilterChanged>(_onStockFilterChanged);
  }

  final BatchFacadeService batchFacadeService;

  Future<void> _onStarted(
    BatchListStarted event,
    Emitter<BatchListState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    try {
      final batches = await batchFacadeService.getBatchesForActiveBranch();
      emit(state.copyWith(status: Status.success, batches: batches));
    } catch (e) {
      debugPrint('[BatchListBloc] Failed to load batches: $e');
      emit(state.copyWith(status: Status.failure, message: e.toString()));
    }
  }

  void _onSearchChanged(
    BatchSearchChanged event,
    Emitter<BatchListState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onStockFilterChanged(
    BatchStockFilterChanged event,
    Emitter<BatchListState> emit,
  ) {
    emit(state.copyWith(stockFilter: event.filter));
  }
}
