import 'package:restock/resources/domain/commands/register_batch_command.dart';
import 'package:restock/resources/domain/entities/batch.dart';
import 'package:restock/resources/domain/repositories/batch_repository.dart';
import 'package:restock/resources/infrastructure/data_sources/batch_remote_data_provider.dart';
import 'package:restock/resources/infrastructure/models/register_batch_request.dart';

class BatchRepositoryImpl implements BatchRepository {
  const BatchRepositoryImpl({required this.remoteDataProvider});

  final BatchRemoteDataProvider remoteDataProvider;

  @override
  Future<List<Batch>> getBatchesByBranchId({
    required String accountId,
    required String branchId,
    String? customSupplyId,
  }) async {
    try {
      final response = await remoteDataProvider.getBatchesByBranchId(
        accountId: accountId,
        branchId: branchId,
        customSupplyId: customSupplyId,
      );
      return response.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to get batches by branch: $e');
    }
  }

  @override
  Future<Batch> registerBatch(RegisterBatchCommand command) async {
    try {
      final request = RegisterBatchRequest.fromCommand(command);
      final response = await remoteDataProvider.registerBatch(
        request,
        command.accountId,
      );
      return response.toDomain();
    } catch (e) {
      throw Exception('Failed to register batch: $e');
    }
  }
}
