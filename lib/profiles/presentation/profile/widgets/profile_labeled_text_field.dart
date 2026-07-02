import 'package:flutter/material.dart';

class ProfileLabeledTextField extends StatelessWidget {
  const ProfileLabeledTextField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.errorText,
    this.keyboardType,
    this.enabled = true,
    super.key,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey('$label-$value'),
      initialValue: value,
      onChanged: onChanged,
      enabled: enabled,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Color(0xFF1F2026),
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        alignLabelWithHint: true,
        labelStyle: const TextStyle(
          color: Color(0xFF5D616A),
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        floatingLabelStyle: const TextStyle(
          color: Color(0xFF5D616A),
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
        enabledBorder: _border(const Color(0xFFC8CCD4)),
        focusedBorder: _border(const Color(0xFF007A4D), width: 1.4),
        disabledBorder: _border(const Color(0xFFE2E5EA)),
        errorBorder: _border(const Color(0xFFE24B4A)),
        focusedErrorBorder: _border(const Color(0xFFE24B4A), width: 1.4),
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
