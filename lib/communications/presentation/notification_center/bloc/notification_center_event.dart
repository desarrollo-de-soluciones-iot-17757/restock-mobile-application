abstract class NotificationCenterEvent {
  const NotificationCenterEvent();
}

class LoadNotifications extends NotificationCenterEvent {
  const LoadNotifications();
}

class EvaluateStockThresholds extends NotificationCenterEvent {
  const EvaluateStockThresholds();
}

class SelectTab extends NotificationCenterEvent {
  const SelectTab(this.tabIndex);

  final int tabIndex;
}

class MarkNotificationAsResolved extends NotificationCenterEvent {
  const MarkNotificationAsResolved(this.notificationId);

  final String notificationId;
}

class DismissStockAlert extends NotificationCenterEvent {
  const DismissStockAlert(this.alertId);

  final String alertId;
}
