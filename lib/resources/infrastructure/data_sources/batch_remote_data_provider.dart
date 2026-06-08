import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:restock/iam/infrastructure/interceptor/auth_http_client.dart';
import 'package:restock/resources/infrastructure/models/register_batch_request.dart';
import 'package:restock/resources/infrastructure/repositories/constants/resources_api_constants.dart';
import 'package:restock/shared/infrastructure/repositories/constants/api_constants.dart';

import '../models/batch_response_model.dart';

class BatchRemoteDataProvider {
  BatchRemoteDataProvider({required this.http});

  final AuthHttpClient http;

  Future<List<BatchResponseModel>> getBatchesByBranchId({
    required String accountId,
    required String branchId,
    String? customSupplyId,
  }) async {
    // The backend accepts only one GET filter at a time for batches.
    // accountId is still required by upper layers for consistency and POST.
    final queryParameters = <String, String>{
      'branchId': branchId,
      if (customSupplyId != null && customSupplyId.isNotEmpty)
        'customSupplyId': customSupplyId,
    };

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ResourcesApiConstants.batches}',
    ).replace(queryParameters: queryParameters);

    debugPrint('[BatchRemoteDataProvider] GET $uri');
    final response = await http.get(uri);
    debugPrint(
      '[BatchRemoteDataProvider] Response status: ${response.statusCode}',
    );

    if (response.statusCode == HttpStatus.ok) {
      final decoded = jsonDecode(response.body);
      final data = _extractBatchList(decoded);
      debugPrint('[BatchRemoteDataProvider] Loaded ${data.length} batches');

      return data
          .map((j) => BatchResponseModel.fromJson(Map<String, dynamic>.from(j)))
          .toList();
    }

    debugPrint(
      '[BatchRemoteDataProvider] Response error body: ${response.body}',
    );
    throw Exception(
      'Failed to load batches: ${response.statusCode} ${response.body}',
    );
  }

  Future<BatchResponseModel> registerBatch(
    RegisterBatchRequest request,
    String accountId,
  ) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ResourcesApiConstants.batches}',
    ).replace(queryParameters: {'accountId': accountId});

    debugPrint('[BatchRemoteDataProvider] POST $uri');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    debugPrint(
      '[BatchRemoteDataProvider] Response status: ${response.statusCode}',
    );

    if (response.statusCode == HttpStatus.created ||
        response.statusCode == HttpStatus.ok) {
      return BatchResponseModel.fromJson(jsonDecode(response.body));
    }

    debugPrint(
      '[BatchRemoteDataProvider] Response error body: ${response.body}',
    );
    throw Exception(
      'Failed to register batch: ${response.statusCode} ${response.body}',
    );
  }

  List<dynamic> _extractBatchList(Object? decoded) {
    if (decoded is List) return decoded;

    if (decoded is Map<String, dynamic>) {
      final content = decoded['content'];
      if (content is List) return content;

      final data = decoded['data'];
      if (data is List) return data;

      final items = decoded['items'];
      if (items is List) return items;
    }

    throw FormatException('Unexpected batches response format: $decoded');
  }
}
