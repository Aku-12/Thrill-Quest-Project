import 'package:dartz/dartz.dart';
import 'package:thrill_quest/core/error/failure.dart';
import 'package:thrill_quest/features/review/domain/entity/review_entity.dart';

abstract interface class IReviewRepository {
  Future<Either<Failure, List<ReviewEntity>>> getActivityReviews(String activityId);

  Future<Either<Failure, ReviewEntity>> createReview({
    required String activityId,
    required double rating,
    String? comment,
  });
}
