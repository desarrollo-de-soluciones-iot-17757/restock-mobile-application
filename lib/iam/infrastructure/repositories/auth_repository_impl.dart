import 'package:restock/iam/domain/entities/auth.dart';
import 'package:restock/iam/domain/repositories/auth_repository.dart';
import 'package:restock/iam/infrastructure/data_sources/auth_remote_data_provider.dart';
import 'package:restock/iam/infrastructure/models/sign_in_request.dart';

/// Concrete implementation of [AuthRepository] that interacts with a remote authentication service.
class AuthRepositoryImpl implements AuthRepository {
  /// Creates an [AuthRepositoryImpl] with the required [authRemoteDataProvider] dependency.
  const AuthRepositoryImpl({required this.authRemoteDataProvider});

  /// The data provider used to perform remote HTTP calls for authentication.
  final AuthRemoteDataProvider authRemoteDataProvider;

  /// Signs in a user using the remote auth provider and maps the result to the domain.
  ///
  /// Throws a generic [Exception] if the network request or domain mapping fails.
  @override
  Future<Auth> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final request = SignInRequest(email: email, password: password);
      final response = await authRemoteDataProvider.signIn(request);
      return response.toDomain();
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }
}