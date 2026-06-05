import 'package:image_picker/image_picker.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

class CreateCustomSupplyState {
  const CreateCustomSupplyState({
    this.status = Status.initial,
    this.name = '',
    this.category = '',
    this.supplyId = '',
    this.minimumStock = '',
    this.maximumStock = '',
    this.unitPrice = '',
    this.currency = 'PEN',
    this.unit = 'kg',
    this.description = '',
    this.image,
    this.errorMessage,
  });

  final Status status;
  final String name;
  final String category;
  final String supplyId;
  final String minimumStock;
  final String maximumStock;
  final String unitPrice;
  final String currency;
  final String unit;
  final String description;
  final XFile? image;
  final String? errorMessage;

  bool get isValid =>
      name.isNotEmpty &&
      double.tryParse(minimumStock) != null &&
      double.tryParse(maximumStock) != null &&
      double.tryParse(unitPrice) != null;

  String get unitMeasurement => switch (unit) {
    'kg' => 'Kilograms',
    'l' => 'Liters',
    'dozen' => 'Dozen',
    'g' => 'Grams',
    'unit' => 'Units',
    _ => unit,
  };

  CreateCustomSupplyState copyWith({
    Status? status,
    String? name,
    String? category,
    String? supplyId,
    String? minimumStock,
    String? maximumStock,
    String? unitPrice,
    String? currency,
    String? unit,
    String? description,
    XFile? image,
    String? errorMessage,
  }) {
    return CreateCustomSupplyState(
      status: status ?? this.status,
      name: name ?? this.name,
      category: category ?? this.category,
      supplyId: supplyId ?? this.supplyId,
      minimumStock: minimumStock ?? this.minimumStock,
      maximumStock: maximumStock ?? this.maximumStock,
      unitPrice: unitPrice ?? this.unitPrice,
      currency: currency ?? this.currency,
      unit: unit ?? this.unit,
      description: description ?? this.description,
      image: image ?? this.image,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
