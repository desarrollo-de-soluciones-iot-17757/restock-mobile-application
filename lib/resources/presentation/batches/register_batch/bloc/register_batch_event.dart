import 'package:restock/resources/domain/entities/custom_supply.dart';

sealed class RegisterBatchEvent {
  const RegisterBatchEvent();
}

class RegisterBatchStarted extends RegisterBatchEvent {
  const RegisterBatchStarted();
}

class RegisterBatchSupplyChanged extends RegisterBatchEvent {
  const RegisterBatchSupplyChanged(this.customSupply);

  final CustomSupply customSupply;
}

class RegisterBatchCurrentStockChanged extends RegisterBatchEvent {
  const RegisterBatchCurrentStockChanged(this.currentStock);

  final String currentStock;
}

class RegisterBatchExpirationDateChanged extends RegisterBatchEvent {
  const RegisterBatchExpirationDateChanged(this.expirationDate);

  final String expirationDate;
}

class RegisterBatchSubmitted extends RegisterBatchEvent {
  const RegisterBatchSubmitted();
}
