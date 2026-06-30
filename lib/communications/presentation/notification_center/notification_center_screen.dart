import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/communications/domain/repositories/notification_repository.dart';
import 'package:restock/communications/presentation/notification_center/bloc/notification_center_bloc.dart';
import 'package:restock/communications/presentation/notification_center/bloc/notification_center_event.dart';
import 'package:restock/communications/presentation/notification_center/bloc/notification_center_state.dart';
import 'package:restock/communications/presentation/notification_center/widgets/alerts_body.dart';
import 'package:restock/injections.dart';

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
        appBar: AppBar(
          backgroundColor: const Color(0xFF151C2A),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'RESTOCK',
                style: TextStyle(
                  color: Color(0xFF4ECCA3),
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'MAIN BRANCH',
                style: TextStyle(
                  color: Color(0xFF9EA2AA),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none_outlined,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE53E3E),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 8),
              child: CircleAvatar(
                radius: 18,
                backgroundImage: const NetworkImage(
                  'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=100',
                ),
                backgroundColor: Colors.grey.shade300,
              ),
            ),
          ],
        ),
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
