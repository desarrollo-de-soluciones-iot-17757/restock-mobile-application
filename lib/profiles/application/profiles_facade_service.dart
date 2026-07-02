import 'package:image_picker/image_picker.dart';
import 'package:restock/profiles/domain/commands/update_profile_command.dart';
import 'package:restock/profiles/domain/entities/profile.dart';
import 'package:restock/profiles/domain/repository/profile_repository.dart';
import 'package:restock/shared/infrastructure/storage/token_storage.dart';

class ProfilesFacadeService {
  const ProfilesFacadeService({
    required this.profileRepository,
    required this.tokenStorage,
  });

  final ProfileRepository profileRepository;
  final TokenStorage tokenStorage;

  Future<Profile> getProfileByAccountId() async {
    final accountId = await tokenStorage.readAccountId();
    if (accountId == null) {
      throw Exception('Account ID not found in token storage');
    }

    return profileRepository.getProfileByAccountId(accountId);
  }

  Future<Profile> updateProfile({
    required String profileId,
    required String name,
    required String lastName,
    required String phoneNumber,
    required String gender,
    required String birthDate,
    XFile? image,
  }) {
    final command = UpdateProfileCommand(
      profileId: profileId,
      name: name,
      lastName: lastName,
      phoneNumber: phoneNumber,
      gender: gender,
      birthDate: birthDate,
      image: image,
    );

    return profileRepository.updateProfile(command);
  }
}
