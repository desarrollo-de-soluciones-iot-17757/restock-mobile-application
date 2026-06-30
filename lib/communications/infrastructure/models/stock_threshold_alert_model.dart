import 'package:restock/communications/domain/entities/stock_threshold_alert.dart';

class StockThresholdAlertModel {
  const StockThresholdAlertModel({
    required this.id,
    required this.productName,
    required this.branchName,
    required this.currentLevel,
    required this.maxThreshold,
    required this.status,
    required this.detectedAt,
    this.resolvedAt,
  });

  final String id;
  final String productName;
  final String branchName;
  final double currentLevel;
  final double maxThreshold;
  final String status;
  final DateTime detectedAt;
  final DateTime? resolvedAt;

  factory StockThresholdAlertModel.fromJson(Map<String, dynamic> json) {
    return StockThresholdAlertModel(
      id: json['alertId'] as String? ??
          json['customSupplyId'] as String? ??
          json['id'] as String? ??
          '',
      productName: json['customSupplyName'] as String? ??
          json['productName'] as String? ??
          '',
      branchName: json['branchName'] as String? ?? 'All Branches',
      currentLevel: (json['currentStock'] as num?)?.toDouble() ??
          (json['currentLevel'] as num?)?.toDouble() ??
          0.0,
      maxThreshold: (json['maxStock'] as num?)?.toDouble() ??
          (json['maxThreshold'] as num?)?.toDouble() ??
          0.0,
      status: json['status'] as String? ?? 'ACTIVE',
      detectedAt: json['detectedAt'] != null
          ? DateTime.parse(json['detectedAt'] as String)
          : DateTime.now(),
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'branchName': branchName,
      'currentLevel': currentLevel,
      'maxThreshold': maxThreshold,
      'status': status,
      'detectedAt': detectedAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
    };
  }

  StockThresholdAlert toDomain() {
    return StockThresholdAlert(
      id: id,
      productName: productName,
      branchName: branchName,
      currentLevel: currentLevel,
      maxThreshold: maxThreshold,
      status: _parseStatus(status),
      detectedAt: detectedAt,
      resolvedAt: resolvedAt,
    );
  }

  static StockAlertStatus _parseStatus(String status) {
    switch (status) {
      case 'ACTIVE':
        return StockAlertStatus.active;
      case 'RESOLVED':
        return StockAlertStatus.resolved;
      default:
        return StockAlertStatus.active;
    }
  }

  static String _statusToJson(StockAlertStatus status) {
    switch (status) {
      case StockAlertStatus.active:
        return 'ACTIVE';
      case StockAlertStatus.resolved:
        return 'RESOLVED';
    }
  }

  factory StockThresholdAlertModel.fromDomain(StockThresholdAlert alert) {
    return StockThresholdAlertModel(
      id: alert.id,
      productName: alert.productName,
      branchName: alert.branchName,
      currentLevel: alert.currentLevel,
      maxThreshold: alert.maxThreshold,
      status: _statusToJson(alert.status),
      detectedAt: alert.detectedAt,
      resolvedAt: alert.resolvedAt,
    );
  }
}
