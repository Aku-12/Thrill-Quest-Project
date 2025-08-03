import 'package:dio/dio.dart';
import 'package:thrill_quest/app/constant/api/api_endpoints.dart';
import 'package:thrill_quest/core/network/api_service.dart';

import 'package:thrill_quest/features/home/data/data_source/activity_data_source.dart';
import 'package:thrill_quest/features/home/data/model/activity_api_model.dart';
import 'package:thrill_quest/features/home/domain/entity/activity_entity.dart';

class ActivityRemoteDatasource implements IActivityDatasource {
  final ApiService _apiService;

  ActivityRemoteDatasource({required ApiService apiService})
      : _apiService = apiService;

 @override
Future<List<ActivityEntity>> getAllActivities() async {
  try {
    final response = await _apiService.dio.get(ApiEndpoints.activities);
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data
          .map((json) => ActivityApiModel.fromJson(json).toEntity())
          .toList();
    } else {
      throw Exception('Failed to fetch activities: ${response.statusMessage}');
    }
  } on DioException catch (e) {
    throw Exception('Dio error: ${e.message}');
  } catch (e) {
    throw Exception('Unexpected error: $e');
  }
}


  @override
  Future<ActivityEntity> getActivityById(String id) async {
    try {
      final response = await _apiService.dio.get('${ApiEndpoints.activities}/$id');
      if (response.statusCode == 200) {
        return ActivityApiModel.fromJson(response.data).toEntity();
      } else {
        throw Exception('Failed to fetch activity: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> createActivity(ActivityEntity activity) async {
    try {
      final model = ActivityApiModel.fromEntity(activity);
      final response = await _apiService.dio.post(
        ApiEndpoints.activities,
        data: model.toJson(),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to create activity: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> updateActivity(String id, ActivityEntity activity) async {
    try {
      final model = ActivityApiModel.fromEntity(activity);
      final response = await _apiService.dio.put(
        '${ApiEndpoints.activities}/$id',
        data: model.toJson(),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update activity: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteActivity(String id) async {
    try {
      final response = await _apiService.dio.delete(
        '${ApiEndpoints.activities}/$id',
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete activity: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
