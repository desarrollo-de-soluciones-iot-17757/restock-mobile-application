import 'package:restock/resources/domain/commands/register_batch_command.dart';
import 'package:restock/resources/domain/entities/batch.dart';
import 'package:restock/resources/domain/repositories/batch_repository.dart';
import 'package:restock/resources/application/branch_facade_service.dart';
import 'package:restock/shared/infrastructure/storage/token_storage.dart';

class BatchFacadeService {
  const BatchFacadeService({
    required this.batchRepository,
    required this.branchFacadeService,
    required this.tokenStorage,
  });

  final BatchRepository batchRepository;
  final BranchFacadeService branchFacadeService;

  final TokenStorage tokenStorage;

  Future<List<Batch>> getBatchesByBranchId({
    required String branchId,
    String? customSupplyId,
  }) async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) {
        throw Exception('Account ID not found in token storage');
      }
      return await batchRepository.getBatchesByBranchId(
        accountId: accountId,
        branchId: branchId,
        customSupplyId: customSupplyId,
      );
    } catch (e) {
      throw Exception('Failed to fetch batches by branch: $e');
    }
  }

  Future<List<Batch>> getBatchesForActiveBranch({
    String? customSupplyId,
  }) async {
    try {
      final branchId = await _resolveActiveBranchId();

      return await getBatchesByBranchId(
        branchId: branchId,
        customSupplyId: customSupplyId,
      );
    } catch (e) {
      throw Exception('Failed to fetch batches for active branch: $e');
    }
  }

  Future<Batch> registerBatch({
    required String code,
    required double currentStock,
    required String customSupplyId,
    String? branchId,
    required String expirationDate,
  }) async {
    try {
      final accountId = await tokenStorage.readAccountId();
      if (accountId == null) {
        throw Exception('Account ID not found in token storage');
      }
      final selectedBranchId = branchId ?? await _resolveActiveBranchId();

      final command = RegisterBatchCommand(
        accountId: accountId,
        code: code,
        currentStock: currentStock,
        customSupplyId: customSupplyId,
        branchId: selectedBranchId,
        expirationDate: expirationDate,
      );

      return await batchRepository.registerBatch(command);
    } catch (e) {
      throw Exception('Failed to register batch: $e');
    }
  }

  Future<String> _resolveActiveBranchId() async {
    final cachedBranchId = await tokenStorage.readBranchId();
    if (cachedBranchId != null && cachedBranchId.isNotEmpty) {
      return cachedBranchId;
    }

    final branches = await branchFacadeService.getBranchesByAccountId();
    final resolvedBranchId = await branchFacadeService.resolveActiveBranchId(
      branches,
    );

    if (resolvedBranchId == null || resolvedBranchId.isEmpty) {
      throw Exception('Active branch ID not found');
    }

    return resolvedBranchId;
  }
}
