import 'package:flutter/material.dart';

class ProfileSecurityStatusCard extends StatelessWidget {
  const ProfileSecurityStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
      child: Row(
        children: [
          const Icon(
            Icons.verified_user_outlined,
            color: Color(0xFF007A4D),
            size: 30,
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Text(
              'Security Status',
              style: TextStyle(
                color: Color(0xFF1F2026),
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF61E6AE),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'VERIFIED',
              style: TextStyle(
                color: Color(0xFF007A4D),
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
