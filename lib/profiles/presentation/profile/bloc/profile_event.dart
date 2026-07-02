import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}

class ProfileStarted extends ProfileEvent {
  const ProfileStarted();
}

class ProfileNameChanged extends ProfileEvent {
  const ProfileNameChanged(this.name);

  final String name;
}

class ProfileLastNameChanged extends ProfileEvent {
  const ProfileLastNameChanged(this.lastName);

  final String lastName;
}

class ProfilePhoneChanged extends ProfileEvent {
  const ProfilePhoneChanged(this.phoneNumber);

  final String phoneNumber;
}

class ProfileGenderChanged extends ProfileEvent {
  const ProfileGenderChanged(this.gender);

  final String gender;
}

class ProfileBirthDateChanged extends ProfileEvent {
  const ProfileBirthDateChanged(this.birthDate);

  final String birthDate;
}

class ProfileImageChanged extends ProfileEvent {
  const ProfileImageChanged(this.image);

  final XFile? image;
}

class ProfileChangesDiscarded extends ProfileEvent {
  const ProfileChangesDiscarded();
}

class ProfileSubmitted extends ProfileEvent {
  const ProfileSubmitted();
}
