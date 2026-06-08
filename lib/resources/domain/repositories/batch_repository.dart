import '../entities/batch.dart';
import '../commands/register_batch_command.dart';

/// Abstract repository for managing batches, defining the contract for fetching and registering batches.
abstract class BatchRepository {

  /// Fetches batches for a branch. [customSupplyId] can narrow the result.
  Future<List<Batch>> getBatchesByBranchId({
    required String accountId,
    required String branchId,
    String? customSupplyId,
  });

  /// Registers a new batch using the provided command and returns the registered batch.
  Future<Batch> registerBatch(RegisterBatchCommand command);
}
