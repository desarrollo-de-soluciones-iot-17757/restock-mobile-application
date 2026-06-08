import 'package:flutter/material.dart';
import 'package:restock/resources/domain/entities/batch.dart';

class BatchCard extends StatelessWidget {
  const BatchCard({super.key, required this.batch});

  final Batch batch;

  @override
  Widget build(BuildContext context) {
    final isNearExpiry = _isNearExpiry(batch.expirationDate);
    final stockColor = batch.currentStock <= 0
        ? const Color(0xFFC91414)
        : const Color(0xFF007A4D);

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD7DCE3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        batch.customSupplyName?.isNotEmpty == true
                            ? batch.customSupplyName!
                            : batch.code,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF171A22),
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (isNearExpiry) ...[
                      const SizedBox(width: 8),
                      const _ExpiringSoonPill(),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${batch.code} • ${batch.unitMeasurement}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Exp: ${_formatDate(batch.expirationDate)}',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatStock(batch),
                style: TextStyle(
                  color: stockColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 46,
                    decoration: BoxDecoration(
                      color: stockColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF7A808A),
                    size: 24,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isNearExpiry(DateTime? expirationDate) {
    if (expirationDate == null) return false;

    final now = DateTime.now();
    final limit = now.add(const Duration(days: 30));
    return !expirationDate.isBefore(now) && !expirationDate.isAfter(limit);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--';

    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$month/$day/${date.year}';
  }

  String _formatStock(Batch batch) {
    final abbreviation = batch.unitMeasurementAbbreviation;
    final stock = batch.currentStock.toStringAsFixed(2);

    return abbreviation.isEmpty ? stock : '$stock $abbreviation';
  }
}

class _ExpiringSoonPill extends StatelessWidget {
  const _ExpiringSoonPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDFDF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'EXPIRING SOON',
        style: TextStyle(
          color: Color(0xFFC91414),
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
