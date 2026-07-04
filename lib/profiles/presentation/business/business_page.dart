import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/profiles/presentation/business/widgets/business_error_view.dart';
import 'package:restock/profiles/presentation/business/widgets/business_information_card.dart';
import 'package:restock/profiles/presentation/business/widgets/business_loading_view.dart';
import 'package:restock/profiles/presentation/profile/widgets/profile_action_buttons.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

import 'bloc/business_bloc.dart';
import 'bloc/business_event.dart';
import 'bloc/business_state.dart';

class BusinessPage extends StatelessWidget {
  const BusinessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BusinessBloc, BusinessState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.saveSucceeded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Business preferences saved')),
          );
        } else if (state.status == Status.failure && state.business != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Could not update business'),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const BusinessLoadingView();
        }

        if (state.status == Status.failure && state.business == null) {
          return BusinessErrorView(
            message: state.errorMessage ?? 'Could not load business',
            onRetry: () =>
                context.read<BusinessBloc>().add(const BusinessStarted()),
          );
        }

        if (state.business == null) {
          return const SizedBox.shrink();
        }

        final isEnabled = !state.isSaving;

        return ColoredBox(
          color: const Color(0xFFF3F6F5),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 26, 20, 34),
            children: [
              BusinessInformationCard(
                state: state,
                enabled: isEnabled,
                onEvent: context.read<BusinessBloc>().add,
              ),
              const SizedBox(height: 28),
              ProfileActionButtons(
                hasChanges: state.hasChanges,
                isSaving: state.isSaving,
                onSave: () =>
                    context.read<BusinessBloc>().add(const BusinessSubmitted()),
                onDiscard: () => context.read<BusinessBloc>().add(
                  const BusinessChangesDiscarded(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
