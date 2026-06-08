import 'package:flutter/material.dart';
import 'package:restock/resources/domain/entities/custom_supply.dart';

class RegisterBatchSupplyField extends StatelessWidget {
  const RegisterBatchSupplyField({
    super.key,
    required this.supplies,
    required this.value,
    required this.enabled,
    required this.errorText,
    required this.onChanged,
  });

  final List<CustomSupply> supplies;
  final CustomSupply? value;
  final bool enabled;
  final String? errorText;
  final ValueChanged<CustomSupply> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: DropdownButtonFormField<CustomSupply>(
        initialValue: value,
        items: supplies
            .map(
              (supply) => DropdownMenuItem(
                value: supply,
                child: Text(
                  supply.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        onChanged: enabled
            ? (supply) {
                if (supply == null) return;
                onChanged(supply);
              }
            : null,
        decoration: _decoration(label: 'SELECT SUPPLY', errorText: errorText),
        icon: const Icon(Icons.keyboard_arrow_down),
      ),
    );
  }

  InputDecoration _decoration({required String label, String? errorText}) {
    return InputDecoration(
      labelText: label,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}
