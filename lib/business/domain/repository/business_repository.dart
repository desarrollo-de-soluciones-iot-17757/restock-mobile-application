import 'package:restock/business/domain/commands/update_business_command.dart';
import 'package:restock/business/domain/entities/business.dart';

abstract class BusinessRepository {
  Future<Business> getBusinessByAccountId(String accountId);

  Future<Business> updateBusiness(UpdateBusinessCommand command);
}
