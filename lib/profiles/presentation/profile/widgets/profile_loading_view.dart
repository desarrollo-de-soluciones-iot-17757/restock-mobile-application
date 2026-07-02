import 'package:flutter/material.dart';

class ProfileLoadingView extends StatelessWidget {
  const ProfileLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFF007A4D)),
    );
  }
}
