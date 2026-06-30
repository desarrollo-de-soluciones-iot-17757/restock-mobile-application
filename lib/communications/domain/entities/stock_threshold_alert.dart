enum StockAlertStatus {
  active,
  resolved,
}

class StockThresholdAlert {
  const StockThresholdAlert({
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
  final StockAlertStatus status;
  final DateTime detectedAt;
  final DateTime? resolvedAt;

  StockThresholdAlert copyWith({
    String? id,
    String? productName,
    String? branchName,
    double? currentLevel,
    double? maxThreshold,
    StockAlertStatus? status,
    DateTime? detectedAt,
    DateTime? resolvedAt,
  }) {
    return StockThresholdAlert(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      branchName: branchName ?? this.branchName,
      currentLevel: currentLevel ?? this.currentLevel,
      maxThreshold: maxThreshold ?? this.maxThreshold,
      status: status ?? this.status,
      detectedAt: detectedAt ?? this.detectedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }
}
