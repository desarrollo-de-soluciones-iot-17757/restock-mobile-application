import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:restock/communications/domain/repositories/notification_repository.dart';
import 'package:restock/communications/infrastructure/data_sources/push_subscription_remote_data_provider.dart';
import 'package:restock/communications/infrastructure/models/push_subscription_request.dart';
import 'package:restock/communications/infrastructure/notifications/push_notifications_service.dart';
import 'package:restock/shared/infrastructure/storage/token_storage.dart';

class CommunicationsFacadeService {
  CommunicationsFacadeService({
    required this.pushNotificationsService,
    required this.pushSubscriptionRemoteDataProvider,
    required this.tokenStorage,
    required this.notificationRepository,
  });

  static const _provider = 'FCM';

  final PushNotificationService pushNotificationsService;
  final PushSubscriptionRemoteDataProvider pushSubscriptionRemoteDataProvider;
  final TokenStorage tokenStorage;
  final NotificationRepository notificationRepository;

  StreamSubscription<String>? _tokenRefreshSubscription;

  Future<void> registerCurrentDeviceForUser(String userId) async {
    await pushNotificationsService.initialize(
      onStockNormalized: _handleStockNormalized,
    );
    final providerToken =
        pushNotificationsService.currentToken ??
        await pushNotificationsService.getToken();

    if (providerToken == null || providerToken.isEmpty) {
      debugPrint('[CommunicationsFacadeService] FCM token is not available');
      return;
    }

    await _registerPushSubscription(
      userId: userId,
      providerToken: providerToken,
    );
    _listenTokenRefresh();
  }

  void _listenTokenRefresh() {
    _tokenRefreshSubscription ??= pushNotificationsService.tokenStream.listen((
      providerToken,
    ) async {
      final userId = await tokenStorage.readAccountId();
      if (userId == null || userId.isEmpty) return;

      try {
        await _registerPushSubscription(
          userId: userId,
          providerToken: providerToken,
        );
      } catch (e) {
        debugPrint(
          '[CommunicationsFacadeService] Failed to register refreshed token: $e',
        );
      }
    });
  }

  Future<void> _registerPushSubscription({
    required String userId,
    required String providerToken,
  }) async {
    await pushSubscriptionRemoteDataProvider.register(
      PushSubscriptionRequest(
        userId: userId,
        providerToken: providerToken,
        clientPlatform: pushNotificationsService.clientPlatform,
        provider: _provider,
      ),
    );
  }

  Future<void> _handleStockNormalized({
    required String customSupplyId,
    String? sourceId,
    String? deviceId,
  }) async {
    try {
      final activeAlerts =
          await notificationRepository.getActiveLowStockNotifications();

      for (final alert in activeAlerts) {
        if (alert.customSupplyId == customSupplyId) {
          await notificationRepository.markAsResolved(alert.id);
          debugPrint(
            '[CommunicationsFacadeService] Resolved low stock alert: ${alert.id}',
          );
        }
      }
    } catch (e) {
      debugPrint(
        '[CommunicationsFacadeService] Failed to resolve low stock alerts: $e',
      );
    }
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    pushNotificationsService.dispose();
  }
}
