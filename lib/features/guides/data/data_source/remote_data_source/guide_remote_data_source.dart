// lib/features/guides/data/data_source/guide_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // Import for debugPrint
import 'package:thrill_quest/app/constant/api/api_endpoints.dart';
import 'package:thrill_quest/core/network/api_service.dart';
import 'package:thrill_quest/core/network/hive_service.dart'; // Ensure HiveService is correctly implemented
import 'package:thrill_quest/features/guides/data/data_source/guide_data_source.dart'; // The interface
import 'package:thrill_quest/features/guides/data/model/guide_api_model.dart'; // Make sure this is correct
import 'package:thrill_quest/features/guides/data/model/guide_hive_model.dart'; // Make sure this is correct
import 'package:thrill_quest/features/guides/domain/entity/guide_entity.dart';

class GuideRemoteDataSource implements IGuideDataSource {
  final ApiService _apiService;

  GuideRemoteDataSource({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<List<GuideEntity>> getAllGuides({
    String search = '',
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = {
        'search': search,
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
      };

      debugPrint('GuideRemoteDataSource: Sending GET request to ${ApiEndpoints.getAllGuides}');
      debugPrint('GuideRemoteDataSource: Query Params: $queryParams');

      final response = await _apiService.dio.get(
        ApiEndpoints.getAllGuides,
        queryParameters: queryParams,
      );

      debugPrint('GuideRemoteDataSource: Response Status Code: ${response.statusCode}');
      debugPrint('GuideRemoteDataSource: Response Data (type): ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        // Step 1: Check the raw 'data' from the response.
        final rawResponseData = response.data;
        debugPrint('GuideRemoteDataSource: Raw response.data: ${rawResponseData}');

        if (rawResponseData is! Map<String, dynamic>) {
            debugPrint('GuideRemoteDataSource: ERROR: response.data is not a Map!');
            throw Exception('Invalid response format: expected map for data');
        }

        final List<dynamic>? dataList = rawResponseData['data']; // Ensure it's accessed correctly
        debugPrint('GuideRemoteDataSource: Extracted "data" list: $dataList');

        if (dataList == null) {
          debugPrint('GuideRemoteDataSource: "data" key is null in response.');
          return []; // No data, return empty list
        }

        if (dataList.isEmpty) {
          debugPrint('GuideRemoteDataSource: "data" list is empty.');
          return []; // Empty list, return empty
        }

        // Step 2: Map raw JSON objects to GuideApiModel
        final List<GuideEntity> guides = [];
        for (var item in dataList) {
          if (item is Map<String, dynamic>) {
            try {
              final guideApiModel = GuideApiModel.fromJson(item);
              final guideEntity = guideApiModel.toEntity();
              guides.add(guideEntity);
              debugPrint('GuideRemoteDataSource: Successfully mapped Guide: ${guideEntity.name}');
            } catch (e) {
              debugPrint('GuideRemoteDataSource: ERROR mapping individual GuideApiModel or toEntity: $e, Raw JSON: $item');
              // Continue to next item or rethrow based on your error handling strategy
            }
          } else {
            debugPrint('GuideRemoteDataSource: Warning: Item in "data" is not a Map: ${item.runtimeType} - $item');
          }
        }

        debugPrint('GuideRemoteDataSource: Total guides parsed into entities: ${guides.length}');

        // Step 3: Cache guides (if HiveService works correctly)
        try {
          final guideHiveModels = guides.map((e) => GuideHiveModel.fromEntity(e)).toList();
          await HiveService().cacheGuides(guideHiveModels);
          debugPrint('GuideRemoteDataSource: Successfully cached ${guideHiveModels.length} guides to Hive.');
        } catch (e) {
          debugPrint('GuideRemoteDataSource: ERROR caching guides to Hive: $e');
        }

        return guides;
      } else {
        debugPrint('GuideRemoteDataSource: API returned non-200 status: ${response.statusCode}');
        throw Exception('Failed to fetch guides: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      debugPrint('GuideRemoteDataSource: DioException - Type: ${e.type}, Message: ${e.message}');
      debugPrint('GuideRemoteDataSource: DioException - Response: ${e.response?.data}');
      throw Exception('Get guides failed: ${e.message}');
    } catch (e) {
      debugPrint('GuideRemoteDataSource: General Exception: $e');
      throw Exception('Get guides failed: $e');
    }
  }
}