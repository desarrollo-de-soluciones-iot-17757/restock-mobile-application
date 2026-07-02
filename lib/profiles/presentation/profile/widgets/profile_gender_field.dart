import 'package:flutter/material.dart';

class ProfileGenderField extends StatelessWidget {
  const ProfileGenderField({
    required this.value,
    required this.onChanged,
    required this.enabled,
    super.key,
  });

  static const values = ['Male', 'Female'];

  final String value;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final selectedValue = values.contains(value) ? value : '';

    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'GENDER',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: _labelStyle,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        enabledBorder: _border(const Color(0xFFC8CCD4)),
        focusedBorder: _border(const Color(0xFF007A4D), width: 1.4),
        disabledBorder: _border(const Color(0xFFE2E5EA)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _GenderOption(
              label: 'Male',
              icon: Icons.male_rounded,
              selected: selectedValue == 'Male',
              enabled: enabled,
              onTap: () => onChanged('Male'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _GenderOption(
              label: 'Female',
              icon: Icons.female_rounded,
              selected: selectedValue == 'Female',
              enabled: enabled,
              onTap: () => onChanged('Female'),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle get _labelStyle {
    return const TextStyle(
      color: Color(0xFF5D616A),
      fontSize: 13,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = enabled
        ? selected
              ? const Color(0xFF007A4D)
              : const Color(0xFF5D616A)
        : const Color(0xFF9AA1AC);
    final borderColor = selected
        ? const Color(0xFF007A4D)
        : const Color(0xFFE2E5EA);
    final background = selected
        ? const Color(0xFFEAF8F2)
        : const Color(0xFFF8FAFB);

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: selected ? 1.2 : 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: foreground, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: foreground,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
