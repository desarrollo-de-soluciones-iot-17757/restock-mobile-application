import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restock/resources/domain/entities/batch.dart';
import 'package:restock/resources/presentation/batches/batch_detail/widgets/batch_detail_content.dart';

class BatchDetailScreen extends StatelessWidget {
  const BatchDetailScreen({super.key, required this.batch});

  final Batch batch;

  static const _ink = Color(0xFF0D1B2A);
  static const _muted = Color(0xFF5A6472);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _ink),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Batch Detail',
          style: TextStyle(
            color: _ink,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: batch.id.isEmpty
          ? const Center(
              child: Text('Batch unavailable', style: TextStyle(color: _muted)),
            )
          : BatchDetailContent(batch: batch),
    );
  }
}
