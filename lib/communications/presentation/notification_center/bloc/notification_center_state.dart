import 'package:restock/communications/domain/entities/notification.dart';
import 'package:restock/communications/domain/entities/stock_threshold_alert.dart';

abstract class NotificationCenterState {
  const NotificationCenterState();
}

class NotificationCenterInitial extends NotificationCenterState {
  const NotificationCenterInitial();
}

class NotificationCenterLoading extends NotificationCenterState {
  const NotificationCenterLoading();
}

class NotificationCenterLoaded extends NotificationCenterState {
  const NotificationCenterLoaded({
    required this.notifications,
    required this.stockAlerts,
    required this.activeTab,
  });

  final List<AppNotification> notifications;
  final List<StockThresholdAlert> stockAlerts;
  final int activeTab;
}

class NotificationCenterError extends NotificationCenterState {
  const NotificationCenterError(this.message);

  final String message;
}
