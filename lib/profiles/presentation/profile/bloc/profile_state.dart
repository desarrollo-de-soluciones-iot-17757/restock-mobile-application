import 'package:image_picker/image_picker.dart';
import 'package:restock/profiles/domain/entities/profile.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class ProfileState {
  const ProfileState({
    this.status = Status.initial,
    this.profile,
    this.name = '',
    this.lastName = '',
    this.phoneNumber = '',
    this.gender = '',
    this.birthDate = '',
    this.image,
    this.submitted = false,
    this.errorMessage,
    this.saveSucceeded = false,
  });

  final Status status;
  final Profile? profile;
  final String name;
  final String lastName;
  final String phoneNumber;
  final String gender;
  final String birthDate;
  final XFile? image;
  final bool submitted;
  final String? errorMessage;
  final bool saveSucceeded;

  bool get isLoading => status == Status.loading && profile == null;
  bool get isSaving => status == Status.loading && profile != null;

  bool get hasChanges {
    final current = profile;
    if (current == null) return false;

    return name != current.name ||
        lastName != current.lastName ||
        phoneNumber != current.phoneNumber ||
        gender != current.gender ||
        birthDate != current.birthDate ||
        image != null;
  }

  String? get nameError => _requiredError(name, 'First name is required');

  String? get lastNameError =>
      _requiredError(lastName, 'Last name is required');

  String? get phoneError {
    if (!submitted || phoneNumber.trim().isEmpty) return null;
    final valid = RegExp(
      r'^\+?[0-9\s().-]{7,20}$',
    ).hasMatch(phoneNumber.trim());
    return valid ? null : 'Enter a valid phone number';
  }

  String? get birthDateError {
    if (!submitted || birthDate.trim().isEmpty) return null;
    final valid = RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(birthDate.trim());
    return valid ? null : 'Use YYYY-MM-DD';
  }

  bool get isValid =>
      nameError == null &&
      lastNameError == null &&
      phoneError == null &&
      birthDateError == null;

  String? _requiredError(String value, String message) {
    if (!submitted) return null;
    return value.trim().isEmpty ? message : null;
  }

  ProfileState copyWith({
    Status? status,
    Profile? profile,
    String? name,
    String? lastName,
    String? phoneNumber,
    String? gender,
    String? birthDate,
    XFile? image,
    bool clearImage = false,
    bool? submitted,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? saveSucceeded,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      image: clearImage ? null : image ?? this.image,
      submitted: submitted ?? this.submitted,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      saveSucceeded: saveSucceeded ?? false,
    );
  }

  ProfileState withProfile(Profile profile, {bool saveSucceeded = false}) {
    return copyWith(
      status: Status.success,
      profile: profile,
      name: profile.name,
      lastName: profile.lastName,
      phoneNumber: profile.phoneNumber,
      gender: profile.gender,
      birthDate: profile.birthDate,
      clearImage: true,
      submitted: false,
      clearErrorMessage: true,
      saveSucceeded: saveSucceeded,
    );
  }
}
