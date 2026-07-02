import 'package:restock/profiles/domain/commands/update_profile_command.dart';
import 'package:restock/profiles/domain/entities/profile.dart';
import 'package:restock/profiles/domain/repository/profile_repository.dart';
import 'package:restock/profiles/infrastructure/data_sources/profile_remote_data_provider.dart';
import 'package:restock/profiles/infrastructure/models/update_profile_request.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({required this.profileRemoteDataProvider});

  final ProfileRemoteDataProvider profileRemoteDataProvider;

  @override
  Future<Profile> getProfileByAccountId(String accountId) {
    return profileRemoteDataProvider.getProfileByAccountId(accountId);
  }

  @override
  Future<Profile> updateProfile(UpdateProfileCommand command) {
    return profileRemoteDataProvider.updateProfile(
      profileId: command.profileId,
      request: UpdateProfileRequest.fromCommand(command),
    );
  }
}
