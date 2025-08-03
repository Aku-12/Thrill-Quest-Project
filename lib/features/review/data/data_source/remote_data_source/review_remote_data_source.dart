import 'package:dio/dio.dart';
import 'package:thrill_quest/features/review/data/data_source/review_data_source.dart';
import 'package:thrill_quest/features/review/data/model/review_api_model.dart';
import 'package:thrill_quest/features/review/domain/entity/review_entity.dart';
import 'package:thrill_quest/app/constant/api/api_endpoints.dart';

class ReviewRemoteDataSource implements IReviewDataSource {
  final Dio _dio;

  ReviewRemoteDataSource(this._dio);

  @override
  Future<List<ReviewEntity>> getActivityReviews(String activityId) async {
    final response = await _dio.get('${ApiEndpoints.review}/$activityId');

    if (response.statusCode == 200 && response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => ReviewApiModel.fromJson(json).toEntity()).toList();
    } else {
      throw Exception(response.data['message'] ?? 'Failed to fetch reviews');
    }
  }

  @override
  Future<ReviewEntity> createReview({
    required String activityId,
    required double rating,
    String? comment,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.review,
      data: {
        'activityId': activityId,
        'rating': rating,
        'comment': comment,
      },
    );

    if (response.statusCode == 201 && response.data['success'] == true) {
      return ReviewApiModel.fromJson(response.data['data']).toEntity();
    } else {
      throw Exception(response.data['message'] ?? 'Failed to submit review');
    }
  }
}
