import 'package:flutter/material.dart';
import 'package:restock/profiles/presentation/profile/bloc/profile_event.dart';
import 'package:restock/profiles/presentation/profile/bloc/profile_state.dart';
import 'package:restock/profiles/presentation/profile/widgets/profile_birth_date_field.dart';
import 'package:restock/profiles/presentation/profile/widgets/profile_gender_field.dart';
import 'package:restock/profiles/presentation/profile/widgets/profile_labeled_text_field.dart';

class ProfilePersonalInformationCard extends StatelessWidget {
  const ProfilePersonalInformationCard({
    required this.state,
    required this.enabled,
    required this.onEvent,
    super.key,
  });

  final ProfileState state;
  final bool enabled;
  final ValueChanged<ProfileEvent> onEvent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(
              color: Color(0xFF1F2026),
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 22),
          ProfileLabeledTextField(
            label: 'FIRST NAME',
            value: state.name,
            errorText: state.nameError,
            enabled: enabled,
            onChanged: (value) => onEvent(ProfileNameChanged(value)),
          ),
          const SizedBox(height: 14),
          ProfileLabeledTextField(
            label: 'LAST NAME',
            value: state.lastName,
            errorText: state.lastNameError,
            enabled: enabled,
            onChanged: (value) => onEvent(ProfileLastNameChanged(value)),
          ),
          const SizedBox(height: 14),
          ProfileLabeledTextField(
            label: 'PHONE NUMBER',
            value: state.phoneNumber,
            errorText: state.phoneError,
            keyboardType: TextInputType.phone,
            enabled: enabled,
            onChanged: (value) => onEvent(ProfilePhoneChanged(value)),
          ),
          const SizedBox(height: 14),
          ProfileGenderField(
            value: state.gender,
            enabled: enabled,
            onChanged: (value) => onEvent(ProfileGenderChanged(value)),
          ),
          const SizedBox(height: 14),
          ProfileBirthDateField(
            value: state.birthDate,
            errorText: state.birthDateError,
            enabled: enabled,
            onChanged: (value) => onEvent(ProfileBirthDateChanged(value)),
          ),
        ],
      ),
    );
  }
}
