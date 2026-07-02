import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/profiles/presentation/profile/bloc/profile_bloc.dart';
import 'package:restock/profiles/presentation/profile/bloc/profile_event.dart';
import 'package:restock/profiles/presentation/profile/bloc/profile_state.dart';
import 'package:restock/profiles/presentation/profile/widgets/profile_action_buttons.dart';
import 'package:restock/profiles/presentation/profile/widgets/profile_avatar_editor.dart';
import 'package:restock/profiles/presentation/profile/widgets/profile_error_view.dart';
import 'package:restock/profiles/presentation/profile/widgets/profile_loading_view.dart';
import 'package:restock/profiles/presentation/profile/widgets/profile_personal_information_card.dart';
import 'package:restock/profiles/presentation/profile/widgets/profile_security_status_card.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.saveSucceeded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile preferences saved')),
          );
        } else if (state.status == Status.failure && state.profile != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Could not update profile'),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const ProfileLoadingView();
        }

        if (state.status == Status.failure && state.profile == null) {
          return ProfileErrorView(
            message: state.errorMessage ?? 'Could not load profile',
            onRetry: () =>
                context.read<ProfileBloc>().add(const ProfileStarted()),
          );
        }

        final profile = state.profile;
        if (profile == null) {
          return const SizedBox.shrink();
        }

        final isEnabled = !state.isSaving;

        return ColoredBox(
          color: const Color(0xFFF3F6F5),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 26, 20, 34),
            children: [
              ProfileAvatarEditor(
                avatarUrl: profile.avatarUrl,
                image: state.image,
                enabled: isEnabled,
                onImageChanged: (image) =>
                    context.read<ProfileBloc>().add(ProfileImageChanged(image)),
              ),
              const SizedBox(height: 22),
              ProfilePersonalInformationCard(
                state: state,
                enabled: isEnabled,
                onEvent: context.read<ProfileBloc>().add,
              ),
              const SizedBox(height: 22),
              const ProfileSecurityStatusCard(),
              const SizedBox(height: 28),
              ProfileActionButtons(
                hasChanges: state.hasChanges,
                isSaving: state.isSaving,
                onSave: () =>
                    context.read<ProfileBloc>().add(const ProfileSubmitted()),
                onDiscard: () => context.read<ProfileBloc>().add(
                  const ProfileChangesDiscarded(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
