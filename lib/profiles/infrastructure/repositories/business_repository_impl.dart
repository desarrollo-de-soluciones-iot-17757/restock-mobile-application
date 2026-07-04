import 'package:restock/profiles/domain/commands/update_business_command.dart';
import 'package:restock/profiles/domain/entities/business.dart';
import 'package:restock/profiles/domain/repository/business_repository.dart';
import 'package:restock/profiles/infrastructure/data_sources/business_remote_data_provider.dart';
import 'package:restock/profiles/infrastructure/models/update_business_request.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  const BusinessRepositoryImpl({required this.businessRemoteDataProvider});

  final BusinessRemoteDataProvider businessRemoteDataProvider;

  @override
  Future<Business> getBusinessByAccountId(String accountId) {
    return businessRemoteDataProvider.getBusinessByAccountId(accountId);
  }

  @override
  Future<Business> updateBusiness(UpdateBusinessCommand command) {
    return businessRemoteDataProvider.updateBusiness(
      businessId: command.businessId,
      request: UpdateBusinessRequest.fromCommand(command),
    );
  }
}
