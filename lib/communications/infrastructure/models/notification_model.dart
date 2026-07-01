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
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ??
          json['sourceType']?.toString() ??
          'UNKNOWN',
      status: json['status']?.toString() ?? 'ACTIVE',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ??
          json['message']?.toString() ??
          '',
      sourceId: json['sourceId']?.toString(),
      customSupplyId: json['customSupplyId']?.toString(),
      deviceId: json['deviceId']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : json['timestamp'] != null
              ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
              : DateTime.now(),
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.tryParse(json['resolvedAt'].toString())
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
      case 'STOCK_EXCESS':
        return NotificationType.stockExcess;
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
      case NotificationType.stockExcess:
        return 'STOCK_EXCESS';
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
