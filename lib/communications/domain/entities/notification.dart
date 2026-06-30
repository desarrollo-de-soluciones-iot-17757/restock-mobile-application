enum NotificationType {
  lowStock,
  deviceRegistered,
  deviceConfigured,
  deviceCalibrated,
  stockNormalized,
  stockExcess,
  unknown,
}

enum NotificationStatus {
  active,
  resolved,
}

class AppNotification {
  const AppNotification({
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
  final NotificationType type;
  final NotificationStatus status;
  final String title;
  final String body;
  final String? sourceId;
  final String? customSupplyId;
  final String? deviceId;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  AppNotification copyWith({
    String? id,
    NotificationType? type,
    NotificationStatus? status,
    String? title,
    String? body,
    String? sourceId,
    String? customSupplyId,
    String? deviceId,
    DateTime? createdAt,
    DateTime? resolvedAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      title: title ?? this.title,
      body: body ?? this.body,
      sourceId: sourceId ?? this.sourceId,
      customSupplyId: customSupplyId ?? this.customSupplyId,
      deviceId: deviceId ?? this.deviceId,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }
}
