import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/communications/domain/repositories/notification_repository.dart';
import 'package:restock/communications/presentation/notification_center/bloc/notification_center_bloc.dart';
import 'package:restock/communications/presentation/notification_center/bloc/notification_center_event.dart';
import 'package:restock/communications/presentation/notification_center/bloc/notification_center_state.dart';
import 'package:restock/communications/presentation/notification_center/widgets/alerts_body.dart';
import 'package:restock/injections.dart';
import 'package:restock/shared/presentation/widgets/app_bar.dart';

class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = NotificationCenterBloc(
          notificationRepository: serviceLocator<NotificationRepository>(),
        );
        bloc.add(const LoadNotifications());
        return bloc;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F8),
        appBar: const RestockAppBar(),
        body: BlocBuilder<NotificationCenterBloc, NotificationCenterState>(
          builder: (context, state) => _buildBody(context, state),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, NotificationCenterState state) {
    if (state is NotificationCenterInitial ||
        state is NotificationCenterLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is NotificationCenterError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Color(0xFFB42318),
              ),
              const SizedBox(height: 16),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF7B7F88)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context
                    .read<NotificationCenterBloc>()
                    .add(const LoadNotifications()),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    if (state is NotificationCenterLoaded) {
      return AlertsBody(state: state);
    }
    return const SizedBox.shrink();
  }
}
