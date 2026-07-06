import 'package:restock/iam/domain/entities/auth.dart';

/// Repository interface handling core authentication operations.
abstract class AuthRepository {
  /// Signs in a user with the provided credentials.
  ///
  /// Takes an [email] and a [password]. Returns an [Auth] entity containing
  /// the session token, user details, and initial configuration on success.
  /// Throws an exception if authentication fails.
  Future<Auth> signIn({
    required String email,
    required String password,
  });
}