import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/application/custom_supply_facade_service.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

import 'create_custom_supply_event.dart';
import 'create_custom_supply_state.dart';

class CreateCustomSupplyBloc
    extends Bloc<CreateCustomSupplyEvent, CreateCustomSupplyState> {
  CreateCustomSupplyBloc({required this.customSupplyFacadeService})
    : super(const CreateCustomSupplyState()) {
    on<CreateCustomSupplyNameChanged>(
      (event, emit) => emit(state.copyWith(name: event.name)),
    );
    on<CreateCustomSupplyMinimumStockChanged>(
      (event, emit) => emit(state.copyWith(minimumStock: event.minimumStock)),
    );
    on<CreateCustomSupplyMaximumStockChanged>(
      (event, emit) => emit(state.copyWith(maximumStock: event.maximumStock)),
    );
    on<CreateCustomSupplyUnitPriceChanged>(
      (event, emit) => emit(state.copyWith(unitPrice: event.unitPrice)),
    );
    on<CreateCustomSupplyCurrencyChanged>(
      (event, emit) => emit(state.copyWith(currency: event.currency)),
    );
    on<CreateCustomSupplyUnitChanged>(
      (event, emit) => emit(state.copyWith(unit: event.unit)),
    );
    on<CreateCustomSupplyDescriptionChanged>(
      (event, emit) => emit(state.copyWith(description: event.description)),
    );
    on<CreateCustomSupplyImageChanged>(
      (event, emit) => emit(state.copyWith(image: event.image)),
    );
    on<CreateCustomSupplySubmitted>(_onSubmitted);
  }

  final CustomSupplyFacadeService customSupplyFacadeService;

  Future<void> _onSubmitted(
    CreateCustomSupplySubmitted event,
    Emitter<CreateCustomSupplyState> emit,
  ) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: Status.loading));
    try {
      await customSupplyFacadeService.registerCustomSupply(
        supplyId: state.supplyId,
        name: state.name,
        description: state.description,
        unitPriceAmount: state.unitPrice,
        unitPriceCurrencyCode: state.currency,
        minimumStock: double.parse(state.minimumStock),
        maximumStock: double.parse(state.maximumStock),
        unitMeasurement: state.unitMeasurement,
        unitMeasurementAbbreviation: state.unit,
        picture: state.image,
      );

      emit(state.copyWith(status: Status.success));
    } catch (e) {
      emit(state.copyWith(status: Status.failure, errorMessage: e.toString()));
    }
  }
}
