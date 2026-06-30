import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.timeLabel,
    required this.icon,
    required this.themeColor,
    required this.backgroundColor,
    required this.leftButtonLabel,
    required this.rightButtonLabel,
    required this.onLeftPressed,
    required this.onRightPressed,
  });

  final String title;
  final String subtitle;
  final String timeLabel;
  final IconData icon;
  final Color themeColor;
  final Color backgroundColor;
  final String leftButtonLabel;
  final String rightButtonLabel;
  final VoidCallback onLeftPressed;
  final VoidCallback onRightPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: themeColor, width: 5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: themeColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Color(0xFF1E293B),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  timeLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: ElevatedButton(
                      onPressed: onLeftPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        leftButtonLabel,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: OutlinedButton(
                      onPressed: onRightPressed,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1E293B),
                        side: const BorderSide(color: Color(0xFFCBD5E1), width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        rightButtonLabel,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
