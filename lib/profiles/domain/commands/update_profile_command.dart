import 'package:image_picker/image_picker.dart';

class UpdateProfileCommand {
  const UpdateProfileCommand({
    required this.profileId,
    required this.name,
    required this.lastName,
    required this.phoneNumber,
    required this.gender,
    required this.birthDate,
    this.image,
  });

  final String profileId;
  final String name;
  final String lastName;
  final String phoneNumber;
  final String gender;
  final String birthDate;
  final XFile? image;
}
