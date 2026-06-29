import 'dart:convert';
import 'dart:io';

import 'package:restock/communications/infrastructure/models/notification_model.dart';
import 'package:restock/communications/infrastructure/repositories/constants/communications_api_constants.dart';
import 'package:restock/iam/infrastructure/interceptor/auth_http_client.dart';
import 'package:restock/shared/infrastructure/repositories/constants/api_constants.dart';

class NotificationRemoteDataProvider {
  const NotificationRemoteDataProvider({required this.http});

  final AuthHttpClient http;

  Future<List<NotificationModel>> getActiveNotifications() async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${CommunicationsApiConstants.notifications}',
    ).replace(queryParameters: {'status': 'ACTIVE'});

    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((j) => NotificationModel.fromJson(j as Map<String, dynamic>))
          .toList();
    }

    throw Exception(
      'Failed to load notifications: ${response.statusCode}',
    );
  }

  Future<List<NotificationModel>> getActiveLowStockNotifications() async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${CommunicationsApiConstants.notifications}',
    ).replace(queryParameters: {
      'status': 'ACTIVE',
      'type': 'LOW_STOCK',
    });

    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((j) => NotificationModel.fromJson(j as Map<String, dynamic>))
          .toList();
    }

    throw Exception(
      'Failed to load low stock notifications: ${response.statusCode}',
    );
  }

  Future<List<NotificationModel>> getNotificationsBySourceId(
    String sourceId,
  ) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${CommunicationsApiConstants.notifications}',
    ).replace(queryParameters: {'sourceId': sourceId});

    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((j) => NotificationModel.fromJson(j as Map<String, dynamic>))
          .toList();
    }

    throw Exception(
      'Failed to load notifications by source: ${response.statusCode}',
    );
  }

  Future<NotificationModel> saveNotification(
    NotificationModel notification,
  ) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${CommunicationsApiConstants.notifications}',
    );

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(notification.toJson()),
    );

    if (response.statusCode == HttpStatus.created ||
        response.statusCode == HttpStatus.ok) {
      return NotificationModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw Exception(
      'Failed to save notification: ${response.statusCode}',
    );
  }

  Future<void> markAsResolved(String notificationId) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${CommunicationsApiConstants.notificationById.replaceAll('{notificationId}', notificationId)}/resolve',
    );

    final response = await http.patch(uri);

    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.noContent) {
      throw Exception(
        'Failed to resolve notification: ${response.statusCode}',
      );
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${CommunicationsApiConstants.notificationById.replaceAll('{notificationId}', notificationId)}',
    );

    final response = await http.delete(uri);

    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.noContent) {
      throw Exception(
        'Failed to delete notification: ${response.statusCode}',
      );
    }
  }
}
