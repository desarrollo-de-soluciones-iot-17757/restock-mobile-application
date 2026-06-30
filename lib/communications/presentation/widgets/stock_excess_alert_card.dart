import 'package:flutter/material.dart';
import 'package:restock/communications/domain/entities/stock_threshold_alert.dart';

class StockExcessAlertCard extends StatelessWidget {
  const StockExcessAlertCard({
    super.key,
    required this.alert,
    this.onInvestigate,
    this.onMarkResolved,
  });

  final StockThresholdAlert alert;
  final VoidCallback? onInvestigate;
  final VoidCallback? onMarkResolved;

  String get _relativeTime {
    final diff = DateTime.now().difference(alert.detectedAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final isActive = alert.status == StockAlertStatus.active;
    final accentColor =
        isActive ? const Color(0xFFE65100) : const Color(0xFF2E7D32);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFFFFF3E0)
                        : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    color: accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              alert.productName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Color(0xFF151C2A),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isActive ? 'Active' : 'Optimal',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        alert.branchName,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF7B7F88),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildLevelIndicator(
                            label: 'Current',
                            value: alert.currentLevel,
                            color: isActive
                                ? const Color(0xFFE65100)
                                : const Color(0xFF2E7D32),
                          ),
                          const SizedBox(width: 24),
                          _buildLevelIndicator(
                            label: 'Max Threshold',
                            value: alert.maxThreshold,
                            color: const Color(0xFF7B7F88),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _relativeTime,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9EA2AA),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isActive) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: OutlinedButton(
                        onPressed: onInvestigate,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF151C2A),
                          side: const BorderSide(color: Color(0xFFD1D5DB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Investigate',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: ElevatedButton(
                        onPressed: onMarkResolved,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF151C2A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Mark Resolved',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLevelIndicator({
    required String label,
    required double value,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label: $value',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
