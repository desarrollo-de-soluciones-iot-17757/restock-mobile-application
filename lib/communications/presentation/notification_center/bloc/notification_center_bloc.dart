import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/communications/domain/repositories/notification_repository.dart';
import 'package:restock/communications/presentation/notification_center/bloc/notification_center_event.dart';
import 'package:restock/communications/presentation/notification_center/bloc/notification_center_state.dart';

class NotificationCenterBloc
    extends Bloc<NotificationCenterEvent, NotificationCenterState> {
  NotificationCenterBloc({required this.notificationRepository})
      : super(const NotificationCenterInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<EvaluateStockThresholds>(_onEvaluateStockThresholds);
    on<SelectTab>(_onSelectTab);
    on<MarkNotificationAsResolved>(_onMarkAsResolved);
    on<DismissStockAlert>(_onDismissStockAlert);
  }

  final NotificationRepository notificationRepository;
  Timer? _pollingTimer;

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationCenterState> emit,
  ) async {
    emit(const NotificationCenterLoading());
    try {
      final results = await Future.wait([
        notificationRepository.getActiveNotifications(),
        notificationRepository.evaluateStockThresholds(),
      ]);

      final notifications = results[0] as List;
      final stockAlerts = results[1] as List;

      emit(NotificationCenterLoaded(
        notifications: notifications.cast(),
        stockAlerts: stockAlerts.cast(),
        activeTab: state is NotificationCenterLoaded
            ? (state as NotificationCenterLoaded).activeTab
            : 0,
      ));

      _pollingTimer?.cancel();
      _pollingTimer = Timer.periodic(
        const Duration(seconds: 30),
        (_) => add(const EvaluateStockThresholds()),
      );
    } catch (e) {
      emit(NotificationCenterError(e.toString()));
    }
  }

  Future<void> _onEvaluateStockThresholds(
    EvaluateStockThresholds event,
    Emitter<NotificationCenterState> emit,
  ) async {
    if (state is! NotificationCenterLoaded) return;
    final current = state as NotificationCenterLoaded;
    try {
      final stockAlerts =
          await notificationRepository.evaluateStockThresholds();
      emit(NotificationCenterLoaded(
        notifications: current.notifications,
        stockAlerts: stockAlerts,
        activeTab: current.activeTab,
      ));
    } catch (_) {}
  }

  void _onSelectTab(
    SelectTab event,
    Emitter<NotificationCenterState> emit,
  ) {
    if (state is NotificationCenterLoaded) {
      final current = state as NotificationCenterLoaded;
      emit(NotificationCenterLoaded(
        notifications: current.notifications,
        stockAlerts: current.stockAlerts,
        activeTab: event.tabIndex,
      ));
    }
  }

  Future<void> _onMarkAsResolved(
    MarkNotificationAsResolved event,
    Emitter<NotificationCenterState> emit,
  ) async {
    try {
      await notificationRepository.markAsResolved(event.notificationId);
      add(const LoadNotifications());
    } catch (_) {}
  }

  void _onDismissStockAlert(
    DismissStockAlert event,
    Emitter<NotificationCenterState> emit,
  ) {
    if (state is! NotificationCenterLoaded) return;
    final current = state as NotificationCenterLoaded;
    final updatedAlerts = current.stockAlerts
        .where((a) => a.id != event.alertId)
        .toList();
    emit(NotificationCenterLoaded(
      notifications: current.notifications,
      stockAlerts: updatedAlerts,
      activeTab: current.activeTab,
    ));
  }
}
