// lib/shared/infrastructure/services/auth_status_notifier.dart
import 'package:flutter/material.dart';
import 'package:restock/shared/infrastructure/storage/token_storage.dart';

/// A [ChangeNotifier] that manages and exposes the user's authentication state.
///
/// It listens for changes to authentication status and notifies any active listeners,
/// triggering UI rebuilds or route redirects as appropriate.
class AuthStatusNotifier extends ChangeNotifier {
  /// Creates an [AuthStatusNotifier] with the required [TokenStorage] dependency.
  AuthStatusNotifier({required TokenStorage tokenStorage})
    : _tokenStorage = tokenStorage;

  /// The secure storage helper used to retrieve or clear authentication state.
  final TokenStorage _tokenStorage;

  /// Whether the user is currently authenticated.
  bool _isAuthenticated = false;

  /// Gets the current authentication status.
  ///
  /// Returns `true` if the user is authenticated, otherwise `false`.
  bool get isAuthenticated => _isAuthenticated;

  /// Initializes the authentication status.
  ///
  /// It checks secure storage for a saved token. If a token is found,
  /// [_isAuthenticated] is set to `true`, and listeners are notified.
  Future<void> initialize() async {
    final token = await _tokenStorage.readToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }

  /// Updates the authentication status to authenticated and notifies listeners.
  ///
  /// This must be invoked upon successful login.
  void onSignInSuccess() {
    _isAuthenticated = true;
    notifyListeners();
  }

  /// Logs the user out by removing all stored data and notifying listeners.
  Future<void> signOut() async {
    await _tokenStorage.delete();
    _isAuthenticated = false;
    notifyListeners();
  }
}
