import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/application/batch_facade_service.dart';
import 'package:restock/resources/application/custom_supply_facade_service.dart';
import 'package:restock/resources/presentation/batches/register_batch/bloc/register_batch_event.dart';
import 'package:restock/resources/presentation/batches/register_batch/bloc/register_batch_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class RegisterBatchBloc extends Bloc<RegisterBatchEvent, RegisterBatchState> {
  RegisterBatchBloc({
    required this.batchFacadeService,
    required this.customSupplyFacadeService,
  }) : super(const RegisterBatchState()) {
    on<RegisterBatchStarted>(_onStarted);
    on<RegisterBatchSupplyChanged>(_onSupplyChanged);
    on<RegisterBatchCurrentStockChanged>(_onCurrentStockChanged);
    on<RegisterBatchExpirationDateChanged>(_onExpirationDateChanged);
    on<RegisterBatchSubmitted>(_onSubmitted);
  }

  final BatchFacadeService batchFacadeService;
  final CustomSupplyFacadeService customSupplyFacadeService;

  Future<void> _onStarted(
    RegisterBatchStarted event,
    Emitter<RegisterBatchState> emit,
  ) async {
    emit(state.copyWith(suppliesStatus: Status.loading));

    try {
      final customSupplies = await customSupplyFacadeService
          .getCustomSuppliesByBranchId();

      emit(
        state.copyWith(
          suppliesStatus: Status.success,
          customSupplies: customSupplies,
          selectedCustomSupply: customSupplies.isEmpty
              ? null
              : customSupplies.first,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          suppliesStatus: Status.failure,
          errorMessage: 'Failed to load supplies',
        ),
      );
    }
  }

  void _onSupplyChanged(
    RegisterBatchSupplyChanged event,
    Emitter<RegisterBatchState> emit,
  ) {
    emit(state.copyWith(selectedCustomSupply: event.customSupply));
  }

  void _onCurrentStockChanged(
    RegisterBatchCurrentStockChanged event,
    Emitter<RegisterBatchState> emit,
  ) {
    emit(state.copyWith(currentStock: event.currentStock));
  }

  void _onExpirationDateChanged(
    RegisterBatchExpirationDateChanged event,
    Emitter<RegisterBatchState> emit,
  ) {
    emit(state.copyWith(expirationDate: event.expirationDate));
  }

  Future<void> _onSubmitted(
    RegisterBatchSubmitted event,
    Emitter<RegisterBatchState> emit,
  ) async {
    final submittedState = state.copyWith(submitted: true);
    emit(submittedState);

    if (!submittedState.isValid) return;

    emit(submittedState.copyWith(status: Status.loading));

    try {
      await batchFacadeService.registerBatch(
        code: _buildCode(),
        currentStock: double.parse(submittedState.currentStock.trim()),
        customSupplyId: submittedState.selectedCustomSupply!.customSupplyId,
        expirationDate: submittedState.parsedExpirationDate!
            .toIso8601String()
            .substring(0, 10),
      );

      emit(submittedState.copyWith(status: Status.success));
    } catch (e) {
      emit(
        submittedState.copyWith(
          status: Status.failure,
          errorMessage: 'Failed to register batch',
        ),
      );
    }
  }

  String _buildCode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'BATCH-$timestamp';
  }
}
