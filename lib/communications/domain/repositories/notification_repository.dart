import 'package:restock/communications/domain/entities/notification.dart';
import 'package:restock/communications/domain/entities/stock_threshold_alert.dart';

abstract class NotificationRepository {
  Future<List<AppNotification>> getActiveNotifications();
  Future<List<AppNotification>> getActiveLowStockNotifications();
  Future<List<AppNotification>> getNotificationsBySourceId(String sourceId);
  Future<AppNotification> saveNotification(AppNotification notification);
  Future<void> markAsResolved(String notificationId);
  Future<void> deleteNotification(String notificationId);
  Future<List<StockThresholdAlert>> evaluateStockThresholds();
}
