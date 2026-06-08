import 'package:flutter/material.dart';

class RegisterBatchDateField extends StatelessWidget {
  const RegisterBatchDateField({
    super.key,
    required this.controller,
    required this.enabled,
    required this.errorText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool enabled;
  final String? errorText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        controller: controller,
        enabled: enabled,
        readOnly: true,
        onTap: enabled ? () => _pickDate(context) : null,
        style: const TextStyle(
          color: Color(0xFF171A22),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: 'EXPIRATION DATE',
          hintText: 'mm/dd/yyyy',
          helperText: 'Use standard international format',
          errorText: errorText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: const TextStyle(
            color: Color(0xFF7A808A),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFC9CED8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFC9CED8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF007A4D), width: 1.4),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: DateTime(now.year + 10),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF007A4D),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF171A22),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            datePickerTheme: const DatePickerThemeData(
              backgroundColor: Colors.white,
              headerBackgroundColor: Color(0xFF151C2A),
              headerForegroundColor: Colors.white,
              todayForegroundColor: WidgetStatePropertyAll(Color(0xFF007A4D)),
              todayBorder: BorderSide(color: Color(0xFF007A4D)),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF007A4D),
                textStyle: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null) return;

    final month = selectedDate.month.toString().padLeft(2, '0');
    final day = selectedDate.day.toString().padLeft(2, '0');
    final value = '$month/$day/${selectedDate.year}';

    controller.text = value;
    onChanged(value);
  }
}
