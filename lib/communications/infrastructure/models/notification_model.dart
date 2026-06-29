import 'package:restock/communications/domain/entities/notification.dart';

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.type,
    required this.status,
    required this.title,
    required this.body,
    required this.createdAt,
    this.sourceId,
    this.customSupplyId,
    this.deviceId,
    this.resolvedAt,
  });

  final String id;
  final String type;
  final String status;
  final String title;
  final String body;
  final String? sourceId;
  final String? customSupplyId;
  final String? deviceId;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      sourceId: json['sourceId'] as String?,
      customSupplyId: json['customSupplyId'] as String?,
      deviceId: json['deviceId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'status': status,
      'title': title,
      'body': body,
      'sourceId': sourceId,
      'customSupplyId': customSupplyId,
      'deviceId': deviceId,
      'createdAt': createdAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
    };
  }

  AppNotification toDomain() {
    return AppNotification(
      id: id,
      type: _parseType(type),
      status: _parseStatus(status),
      title: title,
      body: body,
      sourceId: sourceId,
      customSupplyId: customSupplyId,
      deviceId: deviceId,
      createdAt: createdAt,
      resolvedAt: resolvedAt,
    );
  }

  static NotificationType _parseType(String type) {
    switch (type) {
      case 'LOW_STOCK':
        return NotificationType.lowStock;
      case 'DEVICE_REGISTERED':
        return NotificationType.deviceRegistered;
      case 'DEVICE_CONFIGURED':
        return NotificationType.deviceConfigured;
      case 'DEVICE_CALIBRATED':
        return NotificationType.deviceCalibrated;
      case 'STOCK_NORMALIZED':
        return NotificationType.stockNormalized;
      default:
        return NotificationType.unknown;
    }
  }

  static NotificationStatus _parseStatus(String status) {
    switch (status) {
      case 'ACTIVE':
        return NotificationStatus.active;
      case 'RESOLVED':
        return NotificationStatus.resolved;
      default:
        return NotificationStatus.active;
    }
  }

  static String _typeToJson(NotificationType type) {
    switch (type) {
      case NotificationType.lowStock:
        return 'LOW_STOCK';
      case NotificationType.deviceRegistered:
        return 'DEVICE_REGISTERED';
      case NotificationType.deviceConfigured:
        return 'DEVICE_CONFIGURED';
      case NotificationType.deviceCalibrated:
        return 'DEVICE_CALIBRATED';
      case NotificationType.stockNormalized:
        return 'STOCK_NORMALIZED';
      case NotificationType.unknown:
        return 'UNKNOWN';
    }
  }

  static String _statusToJson(NotificationStatus status) {
    switch (status) {
      case NotificationStatus.active:
        return 'ACTIVE';
      case NotificationStatus.resolved:
        return 'RESOLVED';
    }
  }

  factory NotificationModel.fromDomain(AppNotification notification) {
    return NotificationModel(
      id: notification.id,
      type: _typeToJson(notification.type),
      status: _statusToJson(notification.status),
      title: notification.title,
      body: notification.body,
      sourceId: notification.sourceId,
      customSupplyId: notification.customSupplyId,
      deviceId: notification.deviceId,
      createdAt: notification.createdAt,
      resolvedAt: notification.resolvedAt,
    );
  }
}
