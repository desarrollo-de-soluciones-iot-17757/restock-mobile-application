import 'package:image_picker/image_picker.dart';
import 'package:restock/business/domain/entities/business.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class BusinessState {
  const BusinessState({
    this.status = Status.initial,
    this.business,
    this.ruc = '',
    this.companyName = '',
    this.mainLocation = '',
    this.image,
    this.submitted = false,
    this.errorMessage,
    this.saveSucceeded = false,
  });

  final Status status;
  final Business? business;
  final String ruc;
  final String companyName;
  final String mainLocation;
  final XFile? image;
  final bool submitted;
  final String? errorMessage;
  final bool saveSucceeded;

  bool get isLoading => status == Status.loading && business == null;
  bool get isSaving => status == Status.loading && business != null;

  bool get hasChanges {
    final current = business;
    if (current == null) return false;

    return ruc != current.ruc ||
        companyName != current.companyName ||
        mainLocation != current.mainLocation ||
        image != null;
  }

  String? get rucError => _requiredError(ruc, 'RUC is required');

  String? get companyNameError =>
      _requiredError(companyName, 'Company name is required');

  String? get mainLocationError =>
      _requiredError(mainLocation, 'Main location is required');

  bool get isValid =>
      rucError == null && companyNameError == null && mainLocationError == null;

  String? _requiredError(String value, String message) {
    if (!submitted) return null;
    return value.trim().isEmpty ? message : null;
  }

  BusinessState copyWith({
    Status? status,
    Business? business,
    String? ruc,
    String? companyName,
    String? mainLocation,
    XFile? image,
    bool clearImage = false,
    bool? submitted,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? saveSucceeded,
  }) {
    return BusinessState(
      status: status ?? this.status,
      business: business ?? this.business,
      ruc: ruc ?? this.ruc,
      companyName: companyName ?? this.companyName,
      mainLocation: mainLocation ?? this.mainLocation,
      image: clearImage ? null : image ?? this.image,
      submitted: submitted ?? this.submitted,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      saveSucceeded: saveSucceeded ?? false,
    );
  }

  BusinessState withBusiness(Business business, {bool saveSucceeded = false}) {
    return copyWith(
      status: Status.success,
      business: business,
      ruc: business.ruc,
      companyName: business.companyName,
      mainLocation: business.mainLocation,
      clearImage: true,
      submitted: false,
      clearErrorMessage: true,
      saveSucceeded: saveSucceeded,
    );
  }
}
