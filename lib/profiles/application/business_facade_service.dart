import 'package:image_picker/image_picker.dart';
import 'package:restock/profiles/domain/commands/update_business_command.dart';
import 'package:restock/profiles/domain/entities/business.dart';
import 'package:restock/profiles/domain/repository/business_repository.dart';
import 'package:restock/shared/infrastructure/storage/token_storage.dart';

class BusinessFacadeService {
  const BusinessFacadeService({
    required this.businessRepository,
    required this.tokenStorage,
  });

  final BusinessRepository businessRepository;
  final TokenStorage tokenStorage;

  Future<Business> getCurrentBusiness() async {
    final accountId = await tokenStorage.readAccountId();
    if (accountId == null || accountId.isEmpty) {
      throw Exception('Account ID not found in token storage');
    }

    return businessRepository.getBusinessByAccountId(accountId);
  }

  Future<Business> updateBusiness({
    required String businessId,
    required String ruc,
    required String companyName,
    required String mainLocation,
    XFile? image,
  }) {
    return businessRepository.updateBusiness(
      UpdateBusinessCommand(
        businessId: businessId,
        ruc: ruc,
        companyName: companyName,
        mainLocation: mainLocation,
        image: image,
      ),
    );
  }
}
