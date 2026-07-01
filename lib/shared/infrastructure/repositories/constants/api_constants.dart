import 'dart:io';

/// This file contains constants related to the API endpoints used in the application.
class ApiConstants {

  static const String _productionUrl = String.fromEnvironment('API_BASE_URL');

  /// Deployed backend base URL on Azure.
  static const String _azureUrl =
      'https://restock-api-17757.azurewebsites.net/api/v1/';

  /// The base URL for Android and IOS Simulator (localhost).
  static String get baseUrl {

    if (_productionUrl.isNotEmpty) {
      return _productionUrl;
    }

    // Use the deployed Azure backend by default.
    return _azureUrl;
  }
}
