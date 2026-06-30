import 'package:flutter/material.dart';
import 'package:restock/communications/domain/entities/notification.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    this.onResolve,
  });

  final AppNotification notification;
  final VoidCallback? onResolve;

  IconData get _icon {
    switch (notification.type) {
      case NotificationType.lowStock:
      case NotificationType.stockNormalized:
      case NotificationType.stockExcess:
        return Icons.inventory_2_outlined;
      case NotificationType.deviceRegistered:
        return Icons.devices_outlined;
      case NotificationType.deviceConfigured:
        return Icons.settings_outlined;
      case NotificationType.deviceCalibrated:
        return Icons.tune_outlined;
      case NotificationType.unknown:
        return Icons.notifications_outlined;
    }
  }

  Color get _iconBackground {
    switch (notification.type) {
      case NotificationType.lowStock:
      case NotificationType.stockExcess:
        return const Color(0xFFFFF3E0);
      case NotificationType.stockNormalized:
        return const Color(0xFFE8F5E9);
      case NotificationType.deviceRegistered:
      case NotificationType.deviceConfigured:
      case NotificationType.deviceCalibrated:
        return const Color(0xFFE3F2FD);
      case NotificationType.unknown:
        return const Color(0xFFF5F5F5);
    }
  }

  Color get _iconColor {
    switch (notification.type) {
      case NotificationType.lowStock:
      case NotificationType.stockExcess:
        return const Color(0xFFE65100);
      case NotificationType.stockNormalized:
        return const Color(0xFF2E7D32);
      case NotificationType.deviceRegistered:
      case NotificationType.deviceConfigured:
      case NotificationType.deviceCalibrated:
        return const Color(0xFF1565C0);
      case NotificationType.unknown:
        return const Color(0xFF757575);
    }
  }

  Color get _statusColor {
    switch (notification.status) {
      case NotificationStatus.active:
        return const Color(0xFFE65100);
      case NotificationStatus.resolved:
        return const Color(0xFF2E7D32);
    }
  }

  String get _relativeTime {
    final diff = DateTime.now().difference(notification.createdAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
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
                    color: _iconBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(_icon, color: _iconColor, size: 22),
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
                              notification.title,
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
                              color: _statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              notification.status == NotificationStatus.active
                                  ? 'Active'
                                  : 'Resolved',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: _statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF7B7F88),
                          height: 1.4,
                        ),
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
            if (notification.status == NotificationStatus.active &&
                onResolve != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 38,
                child: ElevatedButton(
                  onPressed: onResolve,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF151C2A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Mark as Resolved',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
