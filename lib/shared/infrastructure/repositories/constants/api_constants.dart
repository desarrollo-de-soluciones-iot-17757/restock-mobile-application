import 'dart:io';

class ApiConstants {
  /// Injected at build time via --dart-define or --dart-define-from-file.
  /// Empty by default for local development.
  static const String _prodUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_prodUrl.isNotEmpty) {
      return _prodUrl;
    }

    // Local development fallback
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080/api/v1/';
    }
    return 'http://127.0.0.1:8080/api/v1/';
  }
}