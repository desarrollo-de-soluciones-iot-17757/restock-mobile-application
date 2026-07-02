import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as pkg_http;
import 'package:restock/iam/infrastructure/interceptor/auth_http_client.dart';
import 'package:restock/profiles/infrastructure/models/profile_model.dart';
import 'package:restock/profiles/infrastructure/models/update_profile_request.dart';
import 'package:restock/profiles/infrastructure/models/update_profile_response.dart';
import 'package:restock/profiles/infrastructure/repositories/constants/profiles_api_constants.dart';
import 'package:restock/shared/infrastructure/repositories/constants/api_constants.dart';

class ProfileRemoteDataProvider {
  const ProfileRemoteDataProvider({required this.http});

  final AuthHttpClient http;

  Future<ProfileModel> getProfileByAccountId(String accountId) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ProfilesApiConstants.profiles}',
    ).replace(queryParameters: {'accountId': accountId});

    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      return ProfileModel.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to load profile: ${response.statusCode}');
  }

  Future<UpdateProfileResponse> updateProfile({
    required String profileId,
    required UpdateProfileRequest request,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ProfilesApiConstants.profileById.replaceAll('{profileId}', profileId)}',
    );

    final multipartRequest = await request.toMultipartRequest(uri);
    final streamedResponse = await http.send(multipartRequest);
    final response = await pkg_http.Response.fromStream(streamedResponse);

    if (response.statusCode == HttpStatus.ok) {
      return UpdateProfileResponse.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to update profile: ${response.statusCode}');
  }
}
