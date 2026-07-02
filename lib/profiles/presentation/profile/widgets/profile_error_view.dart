import 'package:flutter/material.dart';

class ProfileErrorView extends StatelessWidget {
  const ProfileErrorView({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Color(0xFFE24B4A),
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF5D616A),
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007A4D),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
