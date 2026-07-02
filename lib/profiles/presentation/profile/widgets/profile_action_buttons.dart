import 'package:flutter/material.dart';

class ProfileActionButtons extends StatelessWidget {
  const ProfileActionButtons({
    required this.hasChanges,
    required this.isSaving,
    required this.onSave,
    required this.onDiscard,
    super.key,
  });

  final bool hasChanges;
  final bool isSaving;
  final VoidCallback onSave;
  final VoidCallback onDiscard;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 58,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: hasChanges && !isSaving ? onSave : null,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFF007A4D),
              disabledBackgroundColor: const Color(0xFF007A4D),
              disabledForegroundColor: Colors.white.withValues(alpha: 0.55),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isSaving ? 'Saving...' : 'Save Preferences',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 58,
          width: double.infinity,
          child: OutlinedButton(
            onPressed: hasChanges && !isSaving ? onDiscard : null,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF1F2026),
              disabledForegroundColor: const Color(0xFF8B95A1),
              side: const BorderSide(color: Color(0xFF74777F), width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Discard Changes',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ],
    );
  }
}
