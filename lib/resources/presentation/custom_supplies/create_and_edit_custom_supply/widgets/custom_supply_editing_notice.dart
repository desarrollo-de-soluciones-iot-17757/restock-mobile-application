import 'package:flutter/material.dart';

class CustomSupplyEditingNotice extends StatelessWidget {
  const CustomSupplyEditingNotice({
    super.key,
    required this.name,
    required this.supplyName,
  });

  final String name;
  final String supplyName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7F1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFB7E2D1)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFD8F1E7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.edit_outlined,
              color: Color(0xFF1B5E45),
              size: 19,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EDITING CUSTOM SUPPLY',
                  style: TextStyle(
                    color: Color(0xFF1B5E45),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  name.isEmpty ? supplyName : '$name • $supplyName',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF0D1B2A),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
