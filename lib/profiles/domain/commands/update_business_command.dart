import 'package:image_picker/image_picker.dart';

class UpdateBusinessCommand {
  const UpdateBusinessCommand({
    required this.businessId,
    required this.ruc,
    required this.companyName,
    required this.mainLocation,
    this.image,
  });

  final String businessId;
  final String ruc;
  final String companyName;
  final String mainLocation;
  final XFile? image;
}
