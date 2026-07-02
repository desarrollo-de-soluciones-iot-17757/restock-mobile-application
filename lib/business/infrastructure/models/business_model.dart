import 'package:restock/business/domain/entities/business.dart';

class BusinessModel extends Business {
  const BusinessModel({
    required super.id,
    required super.accountId,
    required super.userId,
    required super.ruc,
    required super.pictureUrl,
    required super.picturePublicId,
    required super.companyName,
    required super.mainLocation,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'] as String? ?? '',
      accountId: json['accountId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      ruc: json['ruc'] as String? ?? '',
      pictureUrl: json['pictureUrl'] as String? ?? '',
      picturePublicId: json['picturePublicId'] as String? ?? '',
      companyName: json['companyName'] as String? ?? '',
      mainLocation: json['mainLocation'] as String? ?? '',
    );
  }
}
