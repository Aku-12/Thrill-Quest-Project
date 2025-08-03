import 'package:thrill_quest/features/review/domain/entity/review_entity.dart';

abstract interface class IReviewDataSource {
  Future<List<ReviewEntity>> getActivityReviews(String activityId);

  Future<ReviewEntity> createReview({
    required String activityId,
    required double rating,
    String? comment,
  });
}
