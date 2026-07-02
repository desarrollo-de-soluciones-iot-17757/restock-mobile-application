import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/business/application/business_facade_service.dart';
import 'package:restock/business/presentation/bloc/business_event.dart';
import 'package:restock/business/presentation/bloc/business_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  BusinessBloc({required this.businessFacadeService})
    : super(const BusinessState()) {
    on<BusinessStarted>(_onStarted);
    on<BusinessRucChanged>(
      (event, emit) => emit(state.copyWith(ruc: event.ruc)),
    );
    on<BusinessCompanyNameChanged>(
      (event, emit) => emit(state.copyWith(companyName: event.companyName)),
    );
    on<BusinessMainLocationChanged>(
      (event, emit) => emit(state.copyWith(mainLocation: event.mainLocation)),
    );
    on<BusinessImageChanged>(
      (event, emit) => emit(state.copyWith(image: event.image)),
    );
    on<BusinessChangesDiscarded>(_onDiscarded);
    on<BusinessSubmitted>(_onSubmitted);
  }

  final BusinessFacadeService businessFacadeService;

  Future<void> _onStarted(
    BusinessStarted event,
    Emitter<BusinessState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, clearErrorMessage: true));

    try {
      final business = await businessFacadeService.getCurrentBusiness();
      emit(state.withBusiness(business));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.toString()));
    }
  }

  void _onDiscarded(
    BusinessChangesDiscarded event,
    Emitter<BusinessState> emit,
  ) {
    final business = state.business;
    if (business == null) return;

    emit(state.withBusiness(business));
  }

  Future<void> _onSubmitted(
    BusinessSubmitted event,
    Emitter<BusinessState> emit,
  ) async {
    final business = state.business;
    if (business == null || state.isSaving) return;

    final submittedState = state.copyWith(submitted: true);
    emit(submittedState);

    if (!submittedState.isValid) return;

    emit(submittedState.copyWith(status: Status.loading));

    try {
      final updatedBusiness = await businessFacadeService.updateBusiness(
        businessId: business.id,
        ruc: submittedState.ruc.trim(),
        companyName: submittedState.companyName.trim(),
        mainLocation: submittedState.mainLocation.trim(),
        image: submittedState.image,
      );

      emit(state.withBusiness(updatedBusiness, saveSucceeded: true));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.toString()));
    }
  }
}
