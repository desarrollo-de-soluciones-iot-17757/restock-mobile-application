class Profile {
  const Profile({
    required this.id,
    required this.accountId,
    required this.userId,
    required this.name,
    required this.lastName,
    required this.phoneNumber,
    required this.avatarUrl,
    required this.avatarPublicId,
    required this.gender,
    required this.birthDate,
  });

  final String id;
  final String accountId;
  final String userId;
  final String name;
  final String lastName;
  final String phoneNumber;
  final String avatarUrl;
  final String avatarPublicId;
  final String gender;
  final String birthDate;
}
