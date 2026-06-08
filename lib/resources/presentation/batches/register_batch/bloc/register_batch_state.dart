import 'package:restock/resources/domain/entities/custom_supply.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class RegisterBatchState {
  const RegisterBatchState({
    this.status = Status.initial,
    this.suppliesStatus = Status.initial,
    this.customSupplies = const [],
    this.selectedCustomSupply,
    this.currentStock = '',
    this.expirationDate = '',
    this.submitted = false,
    this.errorMessage,
  });

  final Status status;
  final Status suppliesStatus;
  final List<CustomSupply> customSupplies;
  final CustomSupply? selectedCustomSupply;
  final String currentStock;
  final String expirationDate;
  final bool submitted;
  final String? errorMessage;

  bool get isLoading => status == Status.loading;

  bool get isValid =>
      selectedCustomSupply != null &&
      currentStockError == null &&
      expirationDateError == null;

  String? get supplyError {
    if (!submitted) return null;
    if (selectedCustomSupply == null) return 'Select a supply';
    return null;
  }

  String? get currentStockError {
    if (!submitted) return null;
    if (currentStock.trim().isEmpty) return 'Initial stock is required';

    final value = double.tryParse(currentStock.trim());
    if (value == null) return 'Enter a valid number';
    if (value < 0) return 'Stock cannot be negative';

    return null;
  }

  String? get expirationDateError {
    if (!submitted) return null;
    if (expirationDate.trim().isEmpty) return 'Expiration date is required';
    if (_parseDate(expirationDate) == null) return 'Use mm/dd/yyyy';
    return null;
  }

  DateTime? get parsedExpirationDate => _parseDate(expirationDate);

  RegisterBatchState copyWith({
    Status? status,
    Status? suppliesStatus,
    List<CustomSupply>? customSupplies,
    CustomSupply? selectedCustomSupply,
    bool clearSelectedCustomSupply = false,
    String? currentStock,
    String? expirationDate,
    bool? submitted,
    String? errorMessage,
  }) {
    return RegisterBatchState(
      status: status ?? this.status,
      suppliesStatus: suppliesStatus ?? this.suppliesStatus,
      customSupplies: customSupplies ?? this.customSupplies,
      selectedCustomSupply: clearSelectedCustomSupply
          ? null
          : selectedCustomSupply ?? this.selectedCustomSupply,
      currentStock: currentStock ?? this.currentStock,
      expirationDate: expirationDate ?? this.expirationDate,
      submitted: submitted ?? this.submitted,
      errorMessage: errorMessage,
    );
  }

  DateTime? _parseDate(String value) {
    final parts = value.trim().split('/');
    if (parts.length != 3) return null;

    final month = int.tryParse(parts[0]);
    final day = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (month == null || day == null || year == null) return null;

    final date = DateTime(year, month, day);
    if (date.month != month || date.day != day || date.year != year) {
      return null;
    }

    return date;
  }
}
