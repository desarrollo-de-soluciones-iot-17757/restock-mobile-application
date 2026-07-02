import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/communications/domain/entities/notification.dart';
import 'package:restock/communications/domain/entities/stock_threshold_alert.dart';
import 'package:restock/communications/presentation/notification_center/bloc/notification_center_bloc.dart';
import 'package:restock/communications/presentation/notification_center/bloc/notification_center_event.dart';
import 'package:restock/communications/presentation/notification_center/bloc/notification_center_state.dart';
import 'package:restock/communications/presentation/notification_center/widgets/alert_card.dart';
import 'package:restock/communications/presentation/notification_center/widgets/confirm_stock_transfer_sheet.dart';
import 'package:restock/communications/presentation/notification_center/widgets/discrepancy_alert_sheet.dart';
import 'package:restock/communications/presentation/notification_center/widgets/hardware_offline_sheet.dart';
import 'package:restock/communications/presentation/widgets/stock_excess_alert_card.dart';

class AlertsBody extends StatelessWidget {
  const AlertsBody({super.key, required this.state});

  final NotificationCenterLoaded state;

  static const _tabs = ['All', 'Stock Warnings', 'Devices', 'Discrepancy'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            'Alerts & Notifications',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF151C2A),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: List.generate(_tabs.length, (index) {
              final isSelected = state.activeTab == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    context.read<NotificationCenterBloc>().add(
                          SelectTab(index),
                        );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF151C2A)
                          : const Color(0xFF64748B),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _tabs[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(child: _buildList(context)),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    final tabIndex = state.activeTab;
    final List<Widget> items = [];

    if (tabIndex == 0) {
      for (final alert in state.stockAlerts) {
        items.add(_buildStockAlertCard(context, alert));
      }
      for (final notification in state.notifications) {
        items.add(_buildNotificationCard(context, notification));
      }
    } else if (tabIndex == 1) {
      for (final alert in state.stockAlerts) {
        items.add(_buildStockAlertCard(context, alert));
      }
      final filtered = state.notifications
          .where((n) =>
              n.type == NotificationType.lowStock ||
              n.type == NotificationType.stockExcess)
          .toList();
      for (final notification in filtered) {
        items.add(_buildNotificationCard(context, notification));
      }
    } else if (tabIndex == 2) {
      final filtered = state.notifications
          .where((n) =>
              n.type == NotificationType.deviceRegistered ||
              n.type == NotificationType.deviceConfigured ||
              n.type == NotificationType.deviceCalibrated)
          .toList();
      for (final notification in filtered) {
        items.add(_buildNotificationCard(context, notification));
      }
    } else if (tabIndex == 3) {
      final filtered = state.notifications
          .where((n) =>
              n.type != NotificationType.lowStock &&
              n.type != NotificationType.stockExcess &&
              n.type != NotificationType.deviceRegistered &&
              n.type != NotificationType.deviceConfigured &&
              n.type != NotificationType.deviceCalibrated)
          .toList();
      for (final notification in filtered) {
        items.add(_buildNotificationCard(context, notification));
      }
    }

    if (items.isEmpty) {
      return _buildEmptyState();
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        ...items,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {
                context
                    .read<NotificationCenterBloc>()
                    .add(const LoadNotifications());
              },
              icon: const Icon(Icons.history, color: Color(0xFF475569)),
              label: const Text(
                'Load previous alerts',
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFCBD5E1)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'LATENCY: 42MS \u2022 UPTIME: 99.9%\nALL SYSTEMS OPERATIONAL',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildStockAlertCard(BuildContext context, StockThresholdAlert alert) {
    return StockExcessAlertCard(
      alert: alert,
      onInvestigate: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => DiscrepancyAlertSheet(
            productName: alert.productName,
            onResolve: () {
              context
                  .read<NotificationCenterBloc>()
                  .add(DismissStockAlert(alert.id));
            },
          ),
        );
      },
      onMarkResolved: () {
        context
            .read<NotificationCenterBloc>()
            .add(DismissStockAlert(alert.id));
      },
    );
  }

  Widget _buildNotificationCard(
      BuildContext context, AppNotification notification) {
    final diff = DateTime.now().difference(notification.createdAt);
    final String timeLabel;
    if (diff.inMinutes < 1) {
      timeLabel = 'Just now';
    } else if (diff.inMinutes < 60) {
      timeLabel = '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      timeLabel = '${diff.inHours}h ago';
    } else {
      timeLabel = '${diff.inDays}d ago';
    }

    final isDevice = notification.type == NotificationType.deviceRegistered ||
        notification.type == NotificationType.deviceConfigured ||
        notification.type == NotificationType.deviceCalibrated;

    final isDiscrepancy = notification.type == NotificationType.lowStock ||
        notification.type == NotificationType.stockExcess;

    if (isDiscrepancy) {
      return AlertCard(
        title: notification.title,
        subtitle: notification.body,
        timeLabel: timeLabel,
        icon: Icons.assignment_late_outlined,
        themeColor: const Color(0xFFB42318),
        backgroundColor: const Color(0xFFFEE2E2),
        leftButtonLabel: 'Investigate',
        rightButtonLabel: 'Mark Resolved',
        onLeftPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => DiscrepancyAlertSheet(
              productName: notification.title
                  .replaceAll(RegExp(
                      r'(Alert|Warning|Discrepancy|Mismatch)',
                      caseSensitive: false),
                      '')
                  .trim(),
              onResolve: () {
                context.read<NotificationCenterBloc>().add(
                      MarkNotificationAsResolved(notification.id),
                    );
              },
            ),
          );
        },
        onRightPressed: () {
          context.read<NotificationCenterBloc>().add(
                MarkNotificationAsResolved(notification.id),
              );
        },
      );
    } else if (isDevice) {
      return AlertCard(
        title: notification.title,
        subtitle: notification.body,
        timeLabel: timeLabel,
        icon: Icons.settings_outlined,
        themeColor: const Color(0xFF64748B),
        backgroundColor: const Color(0xFFF1F5F9),
        leftButtonLabel: 'Run Diagnostics',
        rightButtonLabel: 'Acknowledge',
        onLeftPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => HardwareOfflineSheet(
              title: notification.title,
              assignedDevice: 'Scale Hub #09',
              onAcknowledge: () {
                context.read<NotificationCenterBloc>().add(
                      MarkNotificationAsResolved(notification.id),
                    );
              },
            ),
          );
        },
        onRightPressed: () {
          context.read<NotificationCenterBloc>().add(
                MarkNotificationAsResolved(notification.id),
              );
        },
      );
    } else {
      return AlertCard(
        title: notification.title,
        subtitle: notification.body,
        timeLabel: timeLabel,
        icon: Icons.info_outline,
        themeColor: const Color(0xFF2563EB),
        backgroundColor: const Color(0xFFDBEAFE),
        leftButtonLabel: 'Review & Confirm',
        rightButtonLabel: 'Dismiss',
        onLeftPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => ConfirmStockTransferSheet(
              productName: 'Olive Oil',
              subtitle: 'Batch #4492 \u2022 Branch A',
              onConfirm: () {
                context.read<NotificationCenterBloc>().add(
                      MarkNotificationAsResolved(notification.id),
                    );
              },
            ),
          );
        },
        onRightPressed: () {
          context.read<NotificationCenterBloc>().add(
                MarkNotificationAsResolved(notification.id),
              );
        },
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 48,
            color: Color(0xFF4ECCA3),
          ),
          const SizedBox(height: 12),
          const Text(
            'All clear',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF151C2A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'No alerts at this time',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF7B7F88),
            ),
          ),
        ],
      ),
    );
  }
}
