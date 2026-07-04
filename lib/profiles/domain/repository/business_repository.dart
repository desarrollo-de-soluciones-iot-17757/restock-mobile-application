import 'package:restock/profiles/domain/commands/update_business_command.dart';
import 'package:restock/profiles/domain/entities/business.dart';

abstract class BusinessRepository {
  Future<Business> getBusinessByAccountId(String accountId);

  Future<Business> updateBusiness(UpdateBusinessCommand command);
}
