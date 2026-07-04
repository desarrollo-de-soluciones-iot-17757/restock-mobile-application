import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as pkg_http;
import 'package:restock/profiles/infrastructure/models/business_model.dart';
import 'package:restock/profiles/infrastructure/models/update_business_request.dart';
import 'package:restock/profiles/infrastructure/repositories/constants/business_api_constants.dart';
import 'package:restock/iam/infrastructure/interceptor/auth_http_client.dart';
import 'package:restock/shared/infrastructure/repositories/constants/api_constants.dart';

class BusinessRemoteDataProvider {
  const BusinessRemoteDataProvider({required this.http});

  final AuthHttpClient http;

  Future<BusinessModel> getBusinessByAccountId(String accountId) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${BusinessApiConstants.businesses}',
    ).replace(queryParameters: {'accountId': accountId});

    final response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) {
        if (decoded.isEmpty) {
          throw Exception('Business not found for account: $accountId');
        }
        return BusinessModel.fromJson(decoded.first as Map<String, dynamic>);
      }

      return BusinessModel.fromJson(decoded as Map<String, dynamic>);
    }

    throw Exception('Failed to load business: ${response.statusCode}');
  }

  Future<BusinessModel> updateBusiness({
    required String businessId,
    required UpdateBusinessRequest request,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${BusinessApiConstants.businessById.replaceAll('{businessId}', businessId)}',
    );

    final multipartRequest = await request.toMultipartRequest(uri);
    final streamedResponse = await http.send(multipartRequest);
    final response = await pkg_http.Response.fromStream(streamedResponse);

    if (response.statusCode == HttpStatus.ok) {
      return BusinessModel.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to update business: ${response.statusCode}');
  }
}
