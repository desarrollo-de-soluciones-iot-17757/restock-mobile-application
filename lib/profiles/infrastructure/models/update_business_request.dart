import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:restock/profiles/domain/commands/update_business_command.dart';

class UpdateBusinessRequest {
  const UpdateBusinessRequest({
    required this.ruc,
    required this.companyName,
    required this.mainLocation,
    this.image,
  });

  final String ruc;
  final String companyName;
  final String mainLocation;
  final XFile? image;

  factory UpdateBusinessRequest.fromCommand(UpdateBusinessCommand command) {
    return UpdateBusinessRequest(
      ruc: command.ruc,
      companyName: command.companyName,
      mainLocation: command.mainLocation,
      image: command.image,
    );
  }

  Future<http.MultipartRequest> toMultipartRequest(Uri uri) async {
    final request = http.MultipartRequest('PATCH', uri);

    request.fields['ruc'] = ruc;
    request.fields['companyName'] = companyName;
    request.fields['mainLocation'] = mainLocation;

    if (image != null) {
      final bytes = await image!.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes('image', bytes, filename: image!.name),
      );
    }

    return request;
  }
}
