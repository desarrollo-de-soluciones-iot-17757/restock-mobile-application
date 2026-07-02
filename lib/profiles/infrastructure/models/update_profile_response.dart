import 'package:restock/profiles/infrastructure/models/profile_model.dart';

class UpdateProfileResponse extends ProfileModel {
  const UpdateProfileResponse({
    required super.id,
    required super.accountId,
    required super.userId,
    required super.name,
    required super.lastName,
    required super.phoneNumber,
    required super.avatarUrl,
    required super.avatarPublicId,
    required super.gender,
    required super.birthDate,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      id: json['id'] as String? ?? '',
      accountId: json['accountId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      avatarPublicId: json['avatarPublicId'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      birthDate: json['birthDate'] as String? ?? '',
    );
  }
}
