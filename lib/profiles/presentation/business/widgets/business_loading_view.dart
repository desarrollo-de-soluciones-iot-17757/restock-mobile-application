import 'package:flutter/material.dart';

class BusinessLoadingView extends StatelessWidget {
  const BusinessLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFF3F6F5),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
