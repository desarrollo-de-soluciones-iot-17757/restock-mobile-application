import 'package:restock/resources/domain/entities/custom_supply.dart';
import 'package:restock/resources/domain/entities/supply.dart';

/// Response model for the base supply nested in a custom supply response.
class SupplyResponseModel {
  const SupplyResponseModel({
    required this.supplyId,
    required this.name,
    required this.description,
    required this.category,
    required this.isPerishable,
  });

  final String supplyId;
  final String name;
  final String description;
  final String category;
  final bool isPerishable;

  factory SupplyResponseModel.fromJson(Map<String, dynamic> json) {
    return SupplyResponseModel(
      supplyId: _string(json['id']),
      name: _string(json['name']),
      description: _string(json['description']),
      category: _string(json['category']),
      isPerishable: _bool(json['isPerishable']),
    );
  }

  Supply toDomain() {
    return Supply(
      supplyId: supplyId,
      name: name,
      description: description,
      category: category,
      isPerishable: isPerishable,
    );
  }
}

/// Response model for `/api/v1/custom-supplies/{customSupplyId}`.
class CustomSupplyResponseModel {
  const CustomSupplyResponseModel({
    required this.customSupplyId,
    required this.name,
    required this.description,
    required this.unitPriceAmount,
    required this.unitPriceCurrencyCode,
    required this.minimumStock,
    required this.maximumStock,
    required this.unitMeasurement,
    required this.unitMeasurementAbbreviation,
    required this.pictureUrl,
    required this.picturePublicId,
    required this.accountId,
    required this.supply,
  });

  final String customSupplyId;
  final String name;
  final String description;
  final String unitPriceAmount;
  final String unitPriceCurrencyCode;
  final double minimumStock;
  final double maximumStock;
  final String unitMeasurement;
  final String unitMeasurementAbbreviation;
  final String pictureUrl;
  final String picturePublicId;
  final String accountId;
  final SupplyResponseModel supply;

  factory CustomSupplyResponseModel.fromJson(Map<String, dynamic> json) {
    final supplyJson = json['supply'];

    return CustomSupplyResponseModel(
      customSupplyId: _string(json['id']),
      name: _string(json['name']),
      description: _string(json['description']),
      unitPriceAmount: _string(json['unitPriceAmount']),
      unitPriceCurrencyCode: _string(json['unitPriceCurrencyCode']),
      minimumStock: _double(json['minimumStock']),
      maximumStock: _double(json['maximumStock']),
      unitMeasurement: _string(json['unitMeasurement']),
      unitMeasurementAbbreviation: _string(json['unitMeasurementAbbreviation']),
      pictureUrl: _string(json['pictureUrl']),
      picturePublicId: _string(json['picturePublicId']),
      accountId: _string(json['accountId']),
      supply: supplyJson is Map<String, dynamic>
          ? SupplyResponseModel.fromJson(supplyJson)
          : const SupplyResponseModel(
              supplyId: '',
              name: '',
              description: '',
              category: '',
              isPerishable: false,
            ),
    );
  }

  CustomSupply toDomain() {
    return CustomSupply(
      customSupplyId: customSupplyId,
      name: name,
      description: description,
      unitPriceAmount: unitPriceAmount,
      unitPriceCurrencyCode: unitPriceCurrencyCode,
      minimumStock: minimumStock,
      maximumStock: maximumStock,
      unitMeasurement: unitMeasurement,
      unitMeasurementAbbreviation: unitMeasurementAbbreviation,
      pictureUrl: pictureUrl,
      picturePublicId: picturePublicId,
      accountId: accountId,
      supply: supply.toDomain(),
    );
  }
}

String _string(Object? value) => value?.toString() ?? '';

double _double(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

bool _bool(Object? value) {
  if (value is bool) return value;
  return value?.toString().toLowerCase() == 'true';
}
