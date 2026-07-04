import 'package:flutter/material.dart';
import 'package:restock/profiles/presentation/profile/widgets/profile_labeled_text_field.dart';

import '../bloc/business_event.dart';
import '../bloc/business_state.dart';
import 'business_picture_field.dart';

class BusinessInformationCard extends StatelessWidget {
  const BusinessInformationCard({
    required this.state,
    required this.enabled,
    required this.onEvent,
    super.key,
  });

  final BusinessState state;
  final bool enabled;
  final ValueChanged<BusinessEvent> onEvent;

  @override
  Widget build(BuildContext context) {
    final business = state.business;

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
            'Business Information',
            style: TextStyle(
              color: Color(0xFF1F2026),
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 22),
          BusinessPictureField(
            pictureUrl: business?.pictureUrl ?? '',
            image: state.image,
            enabled: enabled,
            onImageChanged: (image) => onEvent(BusinessImageChanged(image)),
          ),
          const SizedBox(height: 16),
          ProfileLabeledTextField(
            label: 'RUC',
            value: state.ruc,
            errorText: state.rucError,
            keyboardType: TextInputType.number,
            enabled: enabled,
            onChanged: (value) => onEvent(BusinessRucChanged(value)),
          ),
          const SizedBox(height: 14),
          ProfileLabeledTextField(
            label: 'COMPANY NAME',
            value: state.companyName,
            errorText: state.companyNameError,
            enabled: enabled,
            onChanged: (value) => onEvent(BusinessCompanyNameChanged(value)),
          ),
          const SizedBox(height: 14),
          ProfileLabeledTextField(
            label: 'MAIN LOCATION',
            value: state.mainLocation,
            errorText: state.mainLocationError,
            enabled: enabled,
            onChanged: (value) => onEvent(BusinessMainLocationChanged(value)),
          ),
        ],
      ),
    );
  }
}
