import 'package:restock/communications/domain/entities/notification.dart';
import 'package:restock/communications/domain/repositories/notification_repository.dart';
import 'package:restock/communications/infrastructure/data_sources/notification_remote_data_provider.dart';
import 'package:restock/communications/infrastructure/models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl({required this.remoteDataProvider});

  final NotificationRemoteDataProvider remoteDataProvider;

  @override
  Future<List<AppNotification>> getActiveNotifications() async {
    try {
      final response = await remoteDataProvider.getActiveNotifications();
      return response.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to get active notifications: $e');
    }
  }

  @override
  Future<List<AppNotification>> getActiveLowStockNotifications() async {
    try {
      final response =
          await remoteDataProvider.getActiveLowStockNotifications();
      return response.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to get low stock notifications: $e');
    }
  }

  @override
  Future<List<AppNotification>> getNotificationsBySourceId(
    String sourceId,
  ) async {
    try {
      final response =
          await remoteDataProvider.getNotificationsBySourceId(sourceId);
      return response.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw Exception('Failed to get notifications by source: $e');
    }
  }

  @override
  Future<AppNotification> saveNotification(
    AppNotification notification,
  ) async {
    try {
      final model = NotificationModel.fromDomain(notification);
      final response = await remoteDataProvider.saveNotification(model);
      return response.toDomain();
    } catch (e) {
      throw Exception('Failed to save notification: $e');
    }
  }

  @override
  Future<void> markAsResolved(String notificationId) async {
    try {
      await remoteDataProvider.markAsResolved(notificationId);
    } catch (e) {
      throw Exception('Failed to mark notification as resolved: $e');
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    try {
      await remoteDataProvider.deleteNotification(notificationId);
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }
}
