import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:restock/profiles/domain/commands/update_profile_command.dart';

class UpdateProfileRequest {
  const UpdateProfileRequest({
    required this.name,
    required this.lastName,
    required this.phoneNumber,
    required this.gender,
    required this.birthDate,
    this.image,
  });

  final String name;
  final String lastName;
  final String phoneNumber;
  final String gender;
  final String birthDate;
  final XFile? image;

  factory UpdateProfileRequest.fromCommand(UpdateProfileCommand command) {
    return UpdateProfileRequest(
      name: command.name,
      lastName: command.lastName,
      phoneNumber: command.phoneNumber,
      gender: command.gender,
      birthDate: command.birthDate,
      image: command.image,
    );
  }

  Future<http.MultipartRequest> toMultipartRequest(Uri uri) async {
    final request = http.MultipartRequest('PATCH', uri);

    request.fields['name'] = name;
    request.fields['lastName'] = lastName;
    request.fields['phoneNumber'] = phoneNumber;
    request.fields['gender'] = gender;
    request.fields['birthDate'] = birthDate;

    if (image != null) {
      final bytes = await image!.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes('image', bytes, filename: image!.name),
      );
    }

    return request;
  }
}
