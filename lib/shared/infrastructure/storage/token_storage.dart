import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A secure storage helper used for storing authentication tokens, account IDs,
/// user IDs, active branch IDs, and first-time login flags.
class TokenStorage {
  /// The underlying [FlutterSecureStorage] instance used for encrypted key-value storage.
  late final FlutterSecureStorage _storage;

  /// Creates a new instance of [TokenStorage] and initializes the secure storage.
  TokenStorage() {
    _storage = const FlutterSecureStorage();
  }

  /// Key used to store the authentication token.
  static const String _key = 'token';

  /// Key used to store the unique account identifier.
  static const String _accountId = 'account_id';

  /// Key used to store the authenticated user identifier.
  static const String _userId = 'user_id';

  /// Key used to store the selected active branch identifier.
  static const String _branchId = 'branch_id';

  /// Key used to store the flag indicating if it's the user's first login.
  static const String _isFirstLogin = 'is_first_login';

  /// Saves the essential authentication details and metadata to secure storage.
  ///
  /// The [token] and [accountId] are required. Optional parameters [userId]
  /// and [branchId] will be stored if provided.
  Future<void> save(
    String token,
    String accountId, {
    String? userId,
    String? branchId,
  }) async {
    await _storage.write(key: _key, value: token);
    await _storage.write(key: _accountId, value: accountId);

    if (userId != null) {
      await _storage.write(key: _userId, value: userId);
    }

    if (branchId != null) {
      await saveBranchId(branchId);
    }

    await _storage.write(key: _isFirstLogin, value: 'true');
  }

  /// Saves the selected [branchId] to secure storage.
  Future<void> saveBranchId(String branchId) async {
    await _storage.write(key: _branchId, value: branchId);
  }

  /// Reads the stored authentication token from secure storage.
  ///
  /// Returns `null` if no token is found.
  Future<String?> readToken() async {
    return await _storage.read(key: _key);
  }

  /// Reads the stored account ID from secure storage.
  ///
  /// Returns `null` if no account ID is found.
  Future<String?> readAccountId() async {
    return await _storage.read(key: _accountId);
  }

  /// Reads the stored user ID from secure storage.
  ///
  /// Returns `null` if no user ID is found.
  Future<String?> readUserId() async {
    return await _storage.read(key: _userId);
  }

  /// Reads the stored branch ID from secure storage.
  ///
  /// Returns `null` if no branch ID is found.
  Future<String?> readBranchId() async {
    return await _storage.read(key: _branchId);
  }

  /// Determines whether this is the user's first login.
  ///
  /// Returns `true` if the first login flag is set to 'true'.
  Future<bool> isFirstLogin() async {
    final value = await _storage.read(key: _isFirstLogin);
    return value == 'true';
  }

  /// Marks the user's login as completed, setting the first login flag to false.
  Future<void> markLoginComplete() async {
    await _storage.write(key: _isFirstLogin, value: 'false');
  }

  /// Clears all stored authentication and session data from secure storage.
  Future<void> delete() async {
    await _storage.delete(key: _key);
    await _storage.delete(key: _accountId);
    await _storage.delete(key: _userId);
    await _storage.delete(key: _branchId);
    await _storage.delete(key: _isFirstLogin);
  }
}
