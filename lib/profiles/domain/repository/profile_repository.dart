import 'package:restock/profiles/domain/commands/update_profile_command.dart';
import 'package:restock/profiles/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile> getProfileByAccountId(String accountId);

  Future<Profile> updateProfile(UpdateProfileCommand command);
}
