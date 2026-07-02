import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/profiles/application/profiles_facade_service.dart';
import 'package:restock/profiles/presentation/profile/bloc/profile_event.dart';
import 'package:restock/profiles/presentation/profile/bloc/profile_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required this.profilesFacadeService})
    : super(const ProfileState()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileNameChanged>(
      (event, emit) => emit(state.copyWith(name: event.name)),
    );
    on<ProfileLastNameChanged>(
      (event, emit) => emit(state.copyWith(lastName: event.lastName)),
    );
    on<ProfilePhoneChanged>(
      (event, emit) => emit(state.copyWith(phoneNumber: event.phoneNumber)),
    );
    on<ProfileGenderChanged>(
      (event, emit) => emit(state.copyWith(gender: event.gender)),
    );
    on<ProfileBirthDateChanged>(
      (event, emit) => emit(state.copyWith(birthDate: event.birthDate)),
    );
    on<ProfileImageChanged>(
      (event, emit) => emit(state.copyWith(image: event.image)),
    );
    on<ProfileChangesDiscarded>(_onDiscarded);
    on<ProfileSubmitted>(_onSubmitted);
  }

  final ProfilesFacadeService profilesFacadeService;

  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, clearErrorMessage: true));

    try {
      final profile = await profilesFacadeService.getProfileByAccountId();
      emit(state.withProfile(profile));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.toString()));
    }
  }

  void _onDiscarded(ProfileChangesDiscarded event, Emitter<ProfileState> emit) {
    final profile = state.profile;
    if (profile == null) return;

    emit(state.withProfile(profile));
  }

  Future<void> _onSubmitted(
    ProfileSubmitted event,
    Emitter<ProfileState> emit,
  ) async {
    final profile = state.profile;
    if (profile == null || state.isSaving) return;

    final submittedState = state.copyWith(submitted: true);
    emit(submittedState);

    if (!submittedState.isValid) return;

    emit(submittedState.copyWith(status: Status.loading));

    try {
      final updatedProfile = await profilesFacadeService.updateProfile(
        profileId: profile.id,
        name: submittedState.name.trim(),
        lastName: submittedState.lastName.trim(),
        phoneNumber: submittedState.phoneNumber.trim(),
        gender: submittedState.gender.trim(),
        birthDate: submittedState.birthDate.trim(),
        image: submittedState.image,
      );

      emit(state.withProfile(updatedProfile, saveSucceeded: true));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.toString()));
    }
  }
}
