import 'package:flutter/material.dart';

class ProfileBirthDateField extends StatefulWidget {
  const ProfileBirthDateField({
    required this.value,
    required this.onChanged,
    required this.enabled,
    this.errorText,
    super.key,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final String? errorText;

  @override
  State<ProfileBirthDateField> createState() => _ProfileBirthDateFieldState();
}

class _ProfileBirthDateFieldState extends State<ProfileBirthDateField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant ProfileBirthDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      enabled: widget.enabled,
      readOnly: true,
      onTap: widget.enabled ? () => _pickDate(context) : null,
      style: const TextStyle(
        color: Color(0xFF1F2026),
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      decoration: InputDecoration(
        labelText: 'BIRTH DATE',
        hintText: 'YYYY-MM-DD',
        errorText: widget.errorText,
        suffixIcon: const Icon(
          Icons.calendar_month_rounded,
          color: Color(0xFF5D616A),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: const TextStyle(
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

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final currentValue = _parseDate(widget.value);
    final initialDate = currentValue != null && !currentValue.isAfter(today)
        ? currentValue
        : DateTime(now.year - 18, now.month, now.day);

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: today,
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

    final value = _formatDate(selectedDate);
    _controller.text = value;
    widget.onChanged(value);
  }

  DateTime? _parseDate(String value) {
    final parts = value.trim().split('-');
    if (parts.length != 3) return null;

    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);

    if (year == null || month == null || day == null) return null;

    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }

    return date;
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
